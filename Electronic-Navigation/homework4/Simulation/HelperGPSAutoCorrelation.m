function [] = HelperGPSAutoCorrelation(gpsWaveform, PRN, OutputDir)
    %% ===== Initial Value ===== %%
    downsampleFactor = 10;
    lags = (-1023:1023).';
    
    % I sample
    subplot(2,1,1);
    QBranchData = imag(gpsWaveform(1:downsampleFactor:end));
    plot(lags,xcorr(QBranchData(1:1023),1023));
    grid on;
    xlabel('Number of Samples Delayed');
    ylabel('Auto-Correlation');
    title(['Auto-Correlation of GPS Spreading Code in I Sample of ', PRN]);
    
    % Q sample
    subplot(2,1,2);
    QBranchData = real(gpsWaveform(1:downsampleFactor:end));
    plot(lags,xcorr(QBranchData(1:1023),1023));
    grid on;
    xlabel('Number of Samples Delayed');
    ylabel('Auto-Correlation');
    title(['Auto-Correlation of GPS Spreading Code in Q Sample of ', PRN]);

    % Save figure
    saveas(gcf, [OutputDir, 'Auto-Correlation-', PRN, '.png']);
end