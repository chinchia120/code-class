function [] = HelperGPSCrossCorrelation(gpsWaveform1, gpsWaveform2, type, OutputDir)
    %% ===== Initial Value ===== %%
    downsampleFactor = 10;

    %% ===== Cross-Correlation of L1 C/A ===== %%
    if type == 1
        QBranchData1 = imag(gpsWaveform1(1:downsampleFactor:end));
        QBranchData2 = imag(gpsWaveform2(1:downsampleFactor:end));
        [c,lags] = xcorr(real(QBranchData1(1:1023)), real(QBranchData2(1:1023)));
        plot(lags,c);
        grid on;
        xlabel('Number of Samples Delayed');
        ylabel('Cross-Correlation');
        title('Cross-Correlation of GPS Spreading Code of L1 C\\A');

        % Save figure
        saveas(gcf, [OutputDir, 'Cross-Correlation-L1CA.png']);
    end

    %% ===== Cross-Correlation of L1C ===== %%
    if type == 2
        IBranchData1 = real(gpsWaveform1(1:downsampleFactor:end));
        IBranchData2 = real(gpsWaveform2(1:downsampleFactor:end));
        [c,lags] = xcorr(real(IBranchData1(1:1023)), real(IBranchData2(1:1023)));
        plot(lags,c);
        grid on;
        xlabel('Number of Samples Delayed');
        ylabel('Cross-Correlation');
        title('Cross-Correlation of GPS Spreading Code of L1C');

        % Save figure
        saveas(gcf, [OutputDir, 'Cross-Correlation-L1C.png']);
    end

    %% ===== Cross-Correlation of L1 C/A and L1C ===== %%
    if type == 3
        QBranchData = imag(gpsWaveform1(1:downsampleFactor:end));
        IBranchData = real(gpsWaveform2(1:downsampleFactor:end));
        [c,lags] = xcorr(real(QBranchData(1:1023)), real(IBranchData(1:1023)));
        plot(lags,c);
        grid on;
        xlabel('Number of Samples Delayed');
        ylabel('Cross-Correlation');
        title('Cross-Correlation of GPS Spreading Code of L1 C\\A and L1C');

        % Save figure
        saveas(gcf, [OutputDir, 'Cross-Correlation-L1CA-L1C.png']);
    end
end