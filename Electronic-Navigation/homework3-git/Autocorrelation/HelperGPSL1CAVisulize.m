function [] = HelperGPSL1CAVisulize(IBranchContent, QBranchContent, gpsBBWaveform,  type, OutputDir)
    % ===== Signal Visualization ===== %
    % Plot auto-correlation of the C/A-code and visualize the spectrum of the GPS signals
    % Because P-code is 10 times faster than C/A-code or L2 CM-/L2 CL-code, initialise down sample factor to 10
    downsampleFactor = 10;
    IBranchData = real(gpsBBWaveform);
    QBranchData = imag(gpsBBWaveform(1:downsampleFactor:end));
    lags = (-1023:1023).';
    plot(lags,xcorr(real(QBranchData(1:1023)),1023));
    grid on;
    xlabel("Number of Samples Delayed");
    ylabel("Autocorrelation");
    title(['Autocorrelation of GPS Spreading Code of ' , type]);

    % Save figure
    saveas(gcf, [OutputDir, 'Auto-Correlation-', type, '.png']);

    % repeatFactor = 40;
    % % Repeat the generated BPSK signal of C/A-code to see the adjacent bands spectrum
    % QBranchUpsampled = repmat(QBranchData(:).',repeatFactor,1);
    % QBranchUpsampled = QBranchUpsampled(:);
    % 
    % % Repeat the generated BPSK signal of in-phase component to see the adjacent bands spectrum
    % IBranchUpsampled = repmat(IBranchData(:).',repeatFactor/10,1);
    % IBranchUpsampled = real(IBranchUpsampled(:));
    % iqScope = spectrumAnalyzer(SampleRate = 1.023e6*repeatFactor, ...
    %     SpectrumType = "Power density", ...
    %     SpectrumUnits = "dBW", ...
    %     YLimits = [-130, -50], ...
    %     Title = ['Comparison of Power Spectral Density of GPS baseband I and Q Signals of ', type], ...
    %     ShowLegend = true, ...
    %     ChannelNames = ["Q-branch spectrum with content: " + QBranchContent, "I-branch spectrum with content: " + IBranchContent]);
    % iqScope([QBranchUpsampled,IBranchUpsampled]);
    
    repeatFactor = 4;
    % Repeat the generated BPSK signal to see the adjacent bands spectrum
    updata = repmat(gpsBBWaveform(:).',repeatFactor,1);
    updata = updata(:);
    bbscope = spectrumAnalyzer(SampleRate = 10*1.023e6*repeatFactor, ...
        SpectrumType = "Power density", ...
        SpectrumUnits = "dBW", ...
        YLimits = [-120,-50], ...
        Title = ['Power Spectral Density of Complex Baseband GPS Signal of ', type]);
    bbscope(updata);

    % Save figure
    scopeFig = printToFigure(bbscope, Visible=false);
    saveas(scopeFig, [OutputDir, 'PSD-', type, '.png']);
end