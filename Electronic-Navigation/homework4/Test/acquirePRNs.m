function [acquisition_PRN1, acquisition_PRN2] = acquirePRNs(waveform, PRN1, PRN2)
    % Sampling parameters
    fs = 5e6; % Sampling frequency in Hz
    fIF = 1.25e6; % Intermediate frequency in Hz
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

    % Perform acquisition by correlating the received waveform with the local C/A codes
    % Here, we use FFT-based circular correlation
    acquisition_PRN1 = fft_correlate(waveform, caCode1_upsampled);
    acquisition_PRN2 = fft_correlate(waveform, caCode2_upsampled);
end