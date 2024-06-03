function [gpsBBWaveform] = HelperGPSL1CAGeneration(PRN)
    %% ===== GPS Signal Structure ===== %%
    % To select the content for transmitting over the in-phase and quadrature-phase branches
    IBranchContent = "P(Y) + D";
    QBranchContent = "C/A + D";
    
    % Specify the satellite PRN index as an integer in the range [1,63]
    PRNID = PRN;
    
    % Set this value to 1 to generate the waveform from the first bit of the navigation data
    NavDataBitStartIndex = 1321;
    
    % Set this value to control the number of navigation data bits in the generated waveform
    NumNavDataBits = 1;

    %% ===== GPS Data Initialization ===== %%
    % Initialize the data configuration object to generate the CNAV data
    cnavConfig = HelperGPSNavigationConfig(SignalType = "CNAV", PRNID = PRNID);
    
    % Initialize the data configuration object to generate the LNAV data
    lnavConfig = HelperGPSNavigationConfig(SignalType = "LNAV", PRNID = PRNID);

    %% ===== GPS Signal Generation ===== %%
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
    
    % Independently process each navigation data bit in a loop
    for iDataBit = 1:NumNavDataBits
        dataBitIdx = iDataBit+NavDataBitStartIndex-1;
        bbSamplesIndices = ((iDataBit-1)*numBBSamplesPerDataBit+1):(iDataBit*numBBSamplesPerDataBit);
        gpsBBWaveform(bbSamplesIndices) = HelperGPSBasebandWaveform(IQContent,pgen,PRNID,CLCodeIdx,lnavData(dataBitIdx),encodedCNAVData(dataBitIdx));
        CLCodeIdx = mod(CLCodeIdx+1,CLCodeResetIdx);
    end
end