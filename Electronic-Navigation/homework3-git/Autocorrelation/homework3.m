%% ========== Setup ========== %%
clc;
clear;
close all;

%% ========== Initial Value ========== %%
student_id = 'P66134111';
PRN1 = mod(str2num(extractAfter(student_id, 1)), 32)+1;
PRN2 = mod(str2num(extractBefore(reverse(student_id), 9)), 32)+1;

%% ========== Open Example ========== %%
% openExample('satcom/GPSWaveformGenerationExample');
% openExample('satcom/GPSL1CWaveformGenerationExample');

%% ========== GPS Waveform Generation ========== %%
% ===== GPS Signal Structure ===== %
% To select the content for transmitting over the in-phase and quadrature-phase branches
IBranchContent = "P(Y) + D";
QBranchContent = "C/A + D";

% Enables visualizations and disables writing the waveform to a file
ShowVisualizations = true;
WriteWaveformToFile = false;

% Specify the satellite PRN index as an integer in the range [1,63]
PRNID = PRN1;

% Set this value to 1 to generate the waveform from the first bit of the navigation data
NavDataBitStartIndex = 1321;

% Set this value to control the number of navigation data bits in the generated waveform
NumNavDataBits = 100;

% ===== GPS Data Initialization ===== %
% Initialize the data configuration object to generate the CNAV data
cnavConfig = HelperGPSNavigationConfig(SignalType = "CNAV", PRNID = PRNID);

% Initialize the data configuration object to generate the LNAV data
lnavConfig = HelperGPSNavigationConfig(SignalType = "LNAV", PRNID = PRNID);

% ===== GPS Signal Generation ===== %
% Based on the configuration, generate the CNAV data
cnavData = HelperGPSNAVDataEncode(cnavConfig);

% Initialize the trellis for convolutional encoder
trellis = poly2trellis(7, ["1+x+x^2+x^3+x^6" "1+x^2+x^3+x^5+x^6"]);
cenc = comm.ConvolutionalEncoder(TrellisStructure = trellis, TerminationMethod = "Continuous");
encodedCNAVData = cenc(cnavData);

% Based on the configuration, generate the LNAV data
lnavData = HelperGPSNAVDataEncode(lnavConfig);

% Specify all of the required properties for waveform generation
CLCodeResetIdx = 75; % CL-code spans over 75 data bits before resetting
numBBSamplesPerDataBit = 204600;
CLCodeIdx = mod(NavDataBitStartIndex-1,CLCodeResetIdx);
IQContent = [IBranchContent,QBranchContent];
pgen = gpsPCode(PRNID = PRNID, InitialTime = lnavConfig.ReferenceTimeOfEphemeris, OutputCodeLength = numBBSamplesPerDataBit);

% Pre-initialize the baseband waveform for speed
gpsBBWaveform = zeros(numBBSamplesPerDataBit*NumNavDataBits,1);

% Create a file into which the waveform is written
if WriteWaveformToFile == 1
    bbWriter = comm.BasebandFileWriter("Waveform.bb",10.23e6,0);
end

% Independently process each navigation data bit in a loop
for iDataBit = 1:NumNavDataBits
    dataBitIdx = iDataBit+NavDataBitStartIndex-1;
    bbSamplesIndices = ((iDataBit-1)*numBBSamplesPerDataBit+1): ...
        (iDataBit*numBBSamplesPerDataBit);
    gpsBBWaveform(bbSamplesIndices) = HelperGPSBasebandWaveform(IQContent,pgen,PRNID, ...
        CLCodeIdx,lnavData(dataBitIdx),encodedCNAVData(dataBitIdx));
    CLCodeIdx = mod(CLCodeIdx+1,CLCodeResetIdx);
    if WriteWaveformToFile == 1
        bbWriter(gpsBBWaveform(bbSamplesIndices));
    end
end

% Close the file if it is opened
if WriteWaveformToFile == 1
    release(bbWriter);
end

% ===== Signal Visualization
% Plot auto-correlation of the C/A-code and visualize the spectrum of the GPS signals
if ShowVisualizations
    % Because P-code is 10 times faster than C/A-code or L2 CM-/L2 CL-code, initialise down sample factor to 10
    downsampleFactor = 10;
    IBranchData = real(gpsBBWaveform);
    QBranchData = imag(gpsBBWaveform(1:downsampleFactor:end));
    lags = (-1023:1023).';
    plot(lags,xcorr(real(QBranchData(1:1023)),1023))
    grid on
    xlabel("Number of Samples Delayed")
    ylabel("Autocorrelation")
    title("Autocorrelation of GPS Spreading Code")
    
    repeatFactor = 40;
    % Repeat the generated BPSK signal of C/A-code to see the adjacent bands spectrum
    QBranchUpsampled = repmat(QBranchData(:).',repeatFactor,1);
    QBranchUpsampled = QBranchUpsampled(:);
    % Repeat the generated BPSK signal of in-phase component to see the adjacent bands spectrum. Repeat the in-phase branch samples ten times less as every sample in quadrature-branch corresponds to 10 samples in in-phase branch
    IBranchUpsampled = repmat(IBranchData(:).',repeatFactor/10,1);
    IBranchUpsampled = real(IBranchUpsampled(:));
    iqScope = spectrumAnalyzer(SampleRate = 1.023e6*repeatFactor, ...
        SpectrumType = "Power density", ...
        SpectrumUnits = "dBW", ...
        YLimits = [-130, -50], Title = ...
        "Comparison of Power Spectral Density of GPS baseband I and Q Signals", ...
        ShowLegend = true, ChannelNames = ...
        ["Q-branch spectrum with content: " + QBranchContent, ...
         "I-branch spectrum with content: " + IBranchContent]);

    iqScope([QBranchUpsampled,IBranchUpsampled]);

    repeatFactor = 4;
    % Repeat the generated BPSK signal to see the adjacent bands spectrum
    updata = repmat(gpsBBWaveform(:).',repeatFactor,1);
    updata = updata(:);
    bbscope = spectrumAnalyzer(SampleRate = 10*1.023e6*repeatFactor, ...
        SpectrumType = "Power density", ...
        SpectrumUnits = "dBW", ...
        YLimits = [-120,-50], ...
        Title = "Power Spectral Density of Complex Baseband GPS Signal");
    bbscope(updata);
end


