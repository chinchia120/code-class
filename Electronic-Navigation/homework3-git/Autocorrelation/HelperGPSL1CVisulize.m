function [] = HelperGPSL1CVisulize(fs, gpsL1CWaveform, type, OutputDir)
    % ===== Signal Visualization ===== %
    % Plot auto-correlation of the C/A-code and visualize the spectrum of the GPS signals
    % Because P-code is 10 times faster than C/A-code or L2 CM-/L2 CL-code, initialise down sample factor to 10
    downsampleFactor = 10;
    IBranchData = real(gpsL1CWaveform);
    QBranchData = imag(gpsL1CWaveform(1:downsampleFactor:end));
    lags = (-1023:1023).';
    plot(lags,xcorr(real(QBranchData(1:1023)),1023));
    grid on;
    xlabel("Number of Samples Delayed");
    ylabel("Auto-Correlation");
    title(['Auto-Correlation of GPS Spreading Code of ' , type]);

    % Save figure
    saveas(gcf, [OutputDir, 'Auto-Correlation-', type, '.png']);

    % Visualize the spectrum of the generated waveform
    gpsScope = spectrumAnalyzer(SampleRate = fs, ...
        Title = ['Spectrum of GPS L1C Signal of ', type], ...
        SpectrumType = "power-density", ...
        SpectrumUnits = "dBW/Hz");
    gpsScope(gpsL1CWaveform/rms(gpsL1CWaveform));

    % Save figure
    scopeFig = printToFigure(gpsScope, Visible=false);
    saveas(scopeFig, [OutputDir, 'PSD-', type, '.png']);
end