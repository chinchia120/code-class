function [gpsBBWaveform] = HelperGenerateGPSWaveform(PRN)
    %% ===== Transmitter configuration ===== %% 
    % Specify the pseudo-random noise (PRN) identification number (ID) for the satellites that are visible at the receiver
    PRNIDs = PRN;

    % GPS legacy navigation data
    % Set this value to 1 to generate the waveform from the first bit of the navigation data. Set this to any other number to generate waveform from the point of interest
    % Starting from a random point in this example
    NavDataBitStartIndex = 1321;

    % Set this value to control the number of navigation data bits in the generated waveform
    NumNavDataBits = 20;

    %% ===== Consider one extra navigation data bit for delay modeling ===== %%
    numBitsForDelay = 1;

    %% ===== Generate the legacy GPS transmission data from each satellite ===== %%
    % Generate waveform from each satellite, scale and add based on SNR
    % Initialize the legacy navigation (LNAV) configuration object
    lnavConfig = HelperGPSNavigationConfig("SignalType","LNAV","PRNID",PRNIDs);

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
    pgen = gpsPCode(PRNID = PRNIDs, ...
        InitialTime = inittime, ...
        OutputCodeLength = (NumNavDataBits+numBitsForDelay)*numPChipsPerNavBit);
    pcode = 1-2*double(pgen());

    % Reduce the power of I-branch signal by 3 dB as per IS-GPS-200 [2]
    % See table 3-Va in [2]
    isig = pcode/sqrt(2);

    cacode = 1-2*double(gnssCACode(PRNIDs,"GPS"));

    numCACodeBlocks = (NumNavDataBits+numBitsForDelay)*bitDuration*1e3;
    caCodeBlocks = repmat(cacode(:),numCACodeBlocks,1);

    % Because C/A-code is 10 times slower than P-code, repeat each sample of C/A-code 10 times
    qsig = repelem(caCodeBlocks,10,1);

    % Generate the baseband waveform
    gpsBBWaveform = (isig + 1j*qsig).*upSampledNavData;
end