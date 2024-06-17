function corr_result = fft_correlate(signal, caCode)
    % Perform circular correlation using FFT
    signal_fft = fft(signal);
    caCode_fft = fft(caCode);
    product_fft = signal_fft .* conj(caCode_fft);
    corr_result = abs(ifft(product_fft));
end