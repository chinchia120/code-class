function [waveform, I_samples, Q_samples] = generateGNSSWaveform(PRN1, PRN2)
    % Sampling parameters
    fs = 5e6; % Sampling frequency in Hz
    fIF = 1.25e6; % Intermediate frequency in Hz
    codeRate = 1.023e6; % C/A code rate in Hz
    codeLength = 1023; % Length of the C/A code
    duration = 0.001; % Duration of the signal in seconds (1 ms)

    % Generate C/A codes for the specified PRNs
    caCode1 = generateCACode(PRN1);
    caCode2 = generateCACode(PRN2);

    % Repeat C/A codes to match the sampling duration
    caCode1 = repmat(caCode1, 1, ceil(duration * codeRate / codeLength));
    caCode2 = repmat(caCode2, 1, ceil(duration * codeRate / codeLength));

    % Truncate to the correct length
    caCode1 = caCode1(1:round(duration * codeRate));
    caCode2 = caCode2(1:round(duration * codeRate));

    % Create time vector for the duration of the signal
    t = 0:1/fs:duration-1/fs;
    t = t(1: 1023);

    % Modulate the C/A codes onto a carrier
    carrier_I = cos(2 * pi * fIF * t); % Cosine for I channel
    caSignal1_I = caCode1 .* carrier_I;
    caSignal2_I = caCode2 .* carrier_I;

    carrier_Q = sin(2 * pi * fIF * t); % Sine for Q channel
    caSignal1_Q = caCode1 .* carrier_Q;
    caSignal2_Q = caCode2 .* carrier_Q;

    % Combine I and Q signals
    I_samples = caSignal1_I + caSignal2_I;
    Q_samples = caSignal1_Q + caSignal2_Q;

    % Combine I and Q to form the complex baseband signal
    waveform = I_samples + 1i * Q_samples;
end