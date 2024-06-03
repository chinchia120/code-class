function [gpsL1CWaveform] = HelperGPSL1CGeneration(PRN)
    % ===== GPS CNAV-2 Data Initialization and Waveform Generation ===== %
    % Generate data for one satellite
    PRNID = PRN;
    numBits = 10;       % Generate waveform for 10 data bits

    % Initialize the CNAV-2 data by using the HelperGPSNavigationConfig helper object
    cfgCNAV2 = HelperGPSNavigationConfig(SignalType = "CNAV2", PRNID = PRNID);

    % Pass the configuration object cfgCNAV2 of the HelperGPSNAVDataEncode helper function, which encodes the CNAV-2 data
    dataCNAV2 = HelperGPSNAVDataEncode(cfgCNAV2);

    % Generate the ranging codes and overlay codes by using the gpsL1CCodes function
    [l1cd,l1cp,l1co] = gpsL1CCodes(PRNID); % Generate the codes for the specified PRNID

    % Initialize overlay code. Initialize indices to circularly start from 1 after reading 1800 bits.
    overlayCodeIndices = mod((1:numBits)-1,size(l1co,1))+1;
    overlayBits = l1co(overlayCodeIndices);
    
    % TMBOC indices initialization as given in section 3.3 of IS-GPS-800 [1]
    ut = [0; 4; 6; 29];
    vt = 0:309;
    
    boc61Indices = reshape(ut + 33*vt,[],1);
    boc11Indices = setdiff(0:10229,boc61Indices);
    m6 = 6;
    m1 = 1;
    n = 1;
    halfCyclSPS61 = 2;
    halfCyclSPS11 = m6*halfCyclSPS61;
    sps = halfCyclSPS11*2;
    numChipsPerBit = 10230;
    tmbocSig = zeros(numChipsPerBit*sps,numBits);
    oneBitSig = zeros(sps,numChipsPerBit);
    for ibit = 1:numBits
        l1cpo = xor(l1cp,overlayBits(ibit));
        oneBitSig(:,boc61Indices+1) = reshape(-1*bocmod(l1cpo(boc61Indices+1),m6,n),sps,[]);
        oneBitSig(:,boc11Indices+1) = reshape(-1*bocmod(l1cpo(boc11Indices+1),m1,n,halfCyclSPS11),sps,[]);
    	tmbocSig(:,ibit) = oneBitSig(:);
    end

    % Generate a BOC-modulated signal such that the rate of the generated signal and the TMBOC signal match
    spreadBitsData = xor(l1cd,dataCNAV2(1:numBits).'); 
    l1cdSig = -1*bocmod(spreadBitsData(:),1,1,halfCyclSPS11); % L1CD is modulated by BOC(1,1). This is at a sampling rate of 2*HalfCycleSPS11*1.023e6

    %　Combine the TMBOC- and BOC-modulated signals
    % Scale and add the signals. Both the pilot and data channels of GPS L1C have the phasing similar to the P(Y)-code of the legacy GPS signal.
    scaleFactordB = 4.75;                        % dB Watts
    scaleFactor = 10^(scaleFactordB/10);
    llcdSigScaled = l1cdSig/sqrt(scaleFactor);
    gpsL1CWaveform = tmbocSig(:) + llcdSigScaled;

end