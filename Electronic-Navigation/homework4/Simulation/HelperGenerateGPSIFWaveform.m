function [gpsBBWaveform] = HelperGenerateGPSIFWaveform(PRN1, PRN2)
    %% ===== Transmitter configuration ===== %% 
    % Specify the number of GPS satellites in the waveform
    numSat = 2;

    % Specify the pseudo-random noise (PRN) identification number (ID) for the satellites that are visible at the receiver
    PRNIDs = [PRN1; PRN2];

    % GPS legacy navigation data
    % Set this value to 1 to generate the waveform from the first bit of the navigation data. Set this to any other number to generate waveform from the point of interest
    % Starting from a random point in this example
    NavDataBitStartIndex = 1321;

    % Set this value to control the number of navigation data bits in the generated waveform
    NumNavDataBits = 20;

    % Define the received signal properties
    % Set the center frequency of the transmission waveform
    CenterFrequency = 10e6; % In Hz

    % Set the sample rate of the transmission waveform
    SampleRate = 38.192e6;  % In samples/sec

    %% ===== Channel configuration ===== %%
    SNRs = [-18; -18.5; -19.5; -19]; % In dB
    sigdelay = [300.34; 587.21; 425.89; 312.88]; % Number of C/A-code chips delay
    peakDoppler = [3589; 4256; 8596; 9568]; % In Hz
    dopplerRate = [1000; 500; 700; 500];    % In Hz/sec

    %% ===== Receiver configuration ===== %%
    PLLNoiseBandwidth = 90; % In Hz
    FLLNoiseBandwidth = 4;  % In Hz
    DLLNoiseBandwidth = 1;  % In Hz

    IntegrationTime = 1e-3; % In seconds

    %% ===== Calculate  noise power to scale each satellite signal appropriately ===== %%
    k = 1.38064852e-23; % Boltzmann constant in Joules/Kelvin
    T = 300;            % Room temperature in Kelvin
    B = 24e6;           % Bandwidth in Hz
    N = k*T*B;          % Thermal noise power in watts

    %% ===== Consider one extra navigation data bit for delay modeling ===== %%
    numBitsForDelay = 1;

    %% ===== Generate the legacy GPS transmission data from each satellite ===== %%
    resultsig = 0;
    % Generate waveform from each satellite, scale and add based on SNR
    for isat = 1:numSat
        % Initialize the legacy navigation (LNAV) configuration object
        lnavConfig = HelperGPSNavigationConfig("SignalType","LNAV","PRNID",PRNIDs(isat));

        % Generate the navigation data bits from the configuration object
        lnavData = HelperGPSNAVDataEncode(lnavConfig);

        % Configure the GPS waveform generation properties
        t = lnavConfig.HOWTOW*6; % First get the initial time
        % HOWTOW is an indication of next subframe starting point
        % Because each subframe is 300 bits long, 300 bits must be subtracted from the initial value to get the first subframe's starting value 
        % This value can be negative as well. Each bit is of 20 millisecond duration and to get time elapsed for bits, bit index must be multiplied with 20e-3
        bitDuration = 20e-3; % In sec
        pCodeRate = 10.23e6; % In Hz
        numPChipsPerNavBit = bitDuration*pCodeRate;
        navdatalen = length(lnavData);
        offsetTime = mod(NavDataBitStartIndex-301,navdatalen)*bitDuration;
        inittime = t + offsetTime;

        % For modeling delay, get one extra navigation bit from previous bit
        navBitIndices = mod(NavDataBitStartIndex+(-1*numBitsForDelay:(NumNavDataBits-1)),navdatalen);
        navBitIndices(navBitIndices==0) = navdatalen;
        navbits = lnavData(navBitIndices);
        navdata = 1-2*navbits;
        upSampledNavData = repelem(navdata,numPChipsPerNavBit,1); 

        % Generate P-code and C/A-code
        pgen = gpsPCode(PRNID = PRNIDs(isat), ...
            InitialTime = inittime, ...
            OutputCodeLength = (NumNavDataBits+numBitsForDelay)*numPChipsPerNavBit);
        pcode = 1-2*double(pgen());

        % Reduce the power of I-branch signal by 3 dB as per IS-GPS-200 [2]
        % See table 3-Va in [2]
        isig = pcode/sqrt(2);

        cacode = 1-2*double(gnssCACode(PRNIDs(isat),"GPS"));

        numCACodeBlocks = (NumNavDataBits+numBitsForDelay)*bitDuration*1e3;
        caCodeBlocks = repmat(cacode(:),numCACodeBlocks,1);

        % Because C/A-code is 10 times slower than P-code, repeat each sample of C/A-code 10 times
        qsig = repelem(caCodeBlocks,10,1);

        % Generate the baseband waveform
        gpsBBWaveform = (isig + 1j*qsig).*upSampledNavData;

        % Initialize the number of samples per bit at IF
        numSamplesPerBit = SampleRate*bitDuration;

        % Introduce Doppler and up-convert the signal to IF
        upconvert = HelperGPSUpConvert;
        upconvert.PeakDoppler = peakDoppler(isat);
        upconvert.DopplerRate = dopplerRate(isat);
        upconvert.CenterFrequency = CenterFrequency;
        upconvert.IFSampleRate = SampleRate;
        gpsIFWaveform = upconvert(gpsBBWaveform);

        % Get the number of samples for delay
        caCodeRate = 1.023e6;
        numDelaySamples = floor(sigdelay(isat)*upconvert.IFSampleRate/caCodeRate);

        % Add delay to the signal by keeping samples of previous bit at the beginning of the signal
        delayedSig = gpsIFWaveform(numSamplesPerBit-numDelaySamples+1:end); 

        % Remove the final samples to make all signals of equal length
        delayedSig = delayedSig(1:end-numDelaySamples);

        % Scale this delayed signal to appropriate power level
        currentSNR = 10^(SNRs(isat)/10);                          % Convert to linear form
        signalpower = currentSNR*N;
        scaledsig = sqrt(signalpower)*delayedSig/rms(delayedSig);

        % Get the composite signal by adding the current satellite signal
        resultsig = resultsig + scaledsig;
    end

    % Add AWGN to the resultant IF waveform
    numSamples = length(resultsig);

    % For repeatable simulations, set the random number generator to default
    rng default;
    if CenterFrequency == 0
        % Generate complex noise samples
        noisesig = (wgn(numSamples,1,10*log10(N)) + 1j*wgn(numSamples,1,10*log10(N)))./sqrt(2);
    else
        noisesig = wgn(numSamples,1,10*log10(N));
    end
    rxwaveform = resultsig + noisesig;

    % Scale the received signal for having unit power
    rxwaveform = rxwaveform/rms(rxwaveform);
end