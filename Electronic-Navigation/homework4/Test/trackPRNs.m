function [tracking_PRN1, tracking_PRN2] = trackPRNs(waveform, PRN1, PRN2)
    % Tracking parameters
    fs = 5e6; % Sampling frequency in Hz
    codeRate = 1.023e6; % C/A code rate in Hz
    codeLength = 1023; % Length of the C/A code
    numSamples = length(waveform);

    % Generate the local C/A codes for the specified PRNs
    caCode1 = generateCACode(PRN1);
    caCode2 = generateCACode(PRN2);

    % Upsample C/A codes to match the sampling rate
    samplesPerChip = fs / codeRate;
    caCode1_upsampled = upsample(caCode1, samplesPerChip);
    caCode2_upsampled = upsample(caCode2, samplesPerChip);

    % Truncate to the correct length if necessary
    caCode1_upsampled = caCode1_upsampled(1:numSamples);
    caCode2_upsampled = caCode2_upsampled(1:numSamples);

    % Initialize tracking loops
    codePhase_PRN1 = 0;
    codePhase_PRN2 = 0;
    carrierFreq_PRN1 = 0;
    carrierFreq_PRN2 = 0;
    codeFreq = codeRate; % Initial code frequency
    carrierFreq = 1.25e6; % Initial carrier frequency (IF)

    % Initialize tracking results storage
    tracking_PRN1.codePhaseError = zeros(1, numSamples);
    tracking_PRN1.carrierPhaseError = zeros(1, numSamples);
    tracking_PRN2.codePhaseError = zeros(1, numSamples);
    tracking_PRN2.carrierPhaseError = zeros(1, numSamples);

    % Loop through the samples to perform tracking
    for i = 1:numSamples
        % Generate local replica signals for PRN1
        localCode_PRN1 = circshift(caCode1_upsampled, codePhase_PRN1);
        localCarrier_PRN1 = exp(1i * 2 * pi * carrierFreq_PRN1 * (0:numSamples-1) / fs);
        replica_PRN1 = localCode_PRN1 .* real(localCarrier_PRN1);

        % Generate local replica signals for PRN2
        localCode_PRN2 = circshift(caCode2_upsampled, codePhase_PRN2);
        localCarrier_PRN2 = exp(1i * 2 * pi * carrierFreq_PRN2 * (0:numSamples-1) / fs);
        replica_PRN2 = localCode_PRN2 .* real(localCarrier_PRN2);

        % Compute prompt, early, and late correlations for DLL (PRN1)
        promptCorrelation_PRN1 = sum(waveform .* replica_PRN1);
        earlyCorrelation_PRN1 = sum(waveform .* circshift(replica_PRN1, -1));
        lateCorrelation_PRN1 = sum(waveform .* circshift(replica_PRN1, 1));

        % Compute prompt, early, and late correlations for DLL (PRN2)
        promptCorrelation_PRN2 = sum(waveform .* replica_PRN2);
        earlyCorrelation_PRN2 = sum(waveform .* circshift(replica_PRN2, -1));
        lateCorrelation_PRN2 = sum(waveform .* circshift(replica_PRN2, 1));

        % Update code phase error (DLL)
        tracking_PRN1.codePhaseError(i) = earlyCorrelation_PRN1 - lateCorrelation_PRN1;
        tracking_PRN2.codePhaseError(i) = earlyCorrelation_PRN2 - lateCorrelation_PRN2;

        % Update carrier phase error (PLL)
        tracking_PRN1.carrierPhaseError(i) = angle(promptCorrelation_PRN1);
        tracking_PRN2.carrierPhaseError(i) = angle(promptCorrelation_PRN2);

        % Adjust code phase and carrier frequency for the next iteration
        codePhase_PRN1 = codePhase_PRN1 + round(codeFreq / fs);
        codePhase_PRN2 = codePhase_PRN2 + round(codeFreq / fs);
        carrierFreq_PRN1 = carrierFreq_PRN1 + tracking_PRN1.carrierPhaseError(i) / (2 * pi);
        carrierFreq_PRN2 = carrierFreq_PRN2 + tracking_PRN2.carrierPhaseError(i) / (2 * pi);
    end
end