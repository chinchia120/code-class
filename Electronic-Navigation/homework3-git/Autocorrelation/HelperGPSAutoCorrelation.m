function [] = HelperGPSAutoCorrelation(gpsWaveform, type, PRN, OutputDir)
    %% ===== Initial Value ===== %%
    downsampleFactor = 10;
    lags = (-1023:1023).';

    %% ===== Auto-Correlation of L1 C/A ===== %%
    if type == 1
        QBranchData = imag(gpsWaveform(1:downsampleFactor:end));
        plot(lags,xcorr(real(QBranchData(1:1023)),1023));
        grid on;
        xlabel('Number of Samples Delayed');
        ylabel('Auto-Correlation');
        title(['Auto-Correlation of GPS Spreading Code of L1 C\\A ', PRN]);
    
        % Save figure
        saveas(gcf, [OutputDir, 'Auto-Correlation-L1CA-', PRN, '.png']);
    end
    
    %% ===== Auto-Correlation of L1C ===== %%
    if type == 2
        IBranchData = real(gpsWaveform(1:downsampleFactor:end));
        plot(lags,xcorr(real(IBranchData(1:1023)),1023));
        grid on;
        xlabel('Number of Samples Delayed');
        ylabel('Auto-Correlation');
        title(['Auto-Correlation of GPS Spreading Code of L1C ', PRN]);
    
        % Save figure
        saveas(gcf, [OutputDir, 'Auto-Correlation-L1C-', PRN, '.png']);
    end
end