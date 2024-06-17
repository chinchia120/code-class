function [] = HelperGPSAutoCorrelation(gpsWaveform, type, PRN, OutputDir)
    %% ===== Initial Value ===== %%
    downsampleFactor = 1;
    lags = (-1023:1023).';

    %% ===== Auto-Correlation of Q Sample ===== %%
    if type == 1
        QBranchData = imag(gpsWaveform(1:downsampleFactor:end));
        plot(lags,xcorr(real(QBranchData(1:1023)),1023));
        grid on;
        xlabel('Number of Samples Delayed');
        ylabel('Auto-Correlation');
        title(['Auto-Correlation of GPS Spreading Code in Q Sample of ', PRN]);
    
        % Save figure
        saveas(gcf, [OutputDir, 'Auto-Correlation-Q-', PRN, '.png']);
    end
    
    %% ===== Auto-Correlation of I Sample ===== %%
    if type == 2
        IBranchData = real(gpsWaveform(1:downsampleFactor:end));
        plot(lags,xcorr(real(IBranchData(1:1023)),1023));
        grid on;
        xlabel('Number of Samples Delayed');
        ylabel('Auto-Correlation');
        title(['Auto-Correlation of GPS Spreading Code in I Sample of ', PRN]);
    
        % Save figure
        saveas(gcf, [OutputDir, 'Auto-Correlation-I-', PRN, '.png']);
    end
end