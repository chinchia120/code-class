function [] = HelperCrossCorrelation(gpsBBWaveform1, gpsBBWaveform2, type, OutputDir)
    %% ===== Cross-Correlation ===== %%
    % Cross-Correlation of two vectors
    downsampleFactor = 10;
    QBranchData1 = imag(gpsBBWaveform1(1:downsampleFactor:end));
    QBranchData2 = imag(gpsBBWaveform2(1:downsampleFactor:end));
    [c,lags] = xcorr(real(QBranchData1(1:1023)), real(QBranchData2(1:1023)));
    plot(lags,c);
    grid on;
    xlabel("Number of Samples Delayed");
    ylabel("Cross-Correlation");
    title(['Cross-Correlation of GPS Spreading Code of ', type]);

    % Save figure
    saveas(gcf, [OutputDir, 'Cross-Correlation-', type, '.png']);
end