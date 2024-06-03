function [] = HelperGPSPowerSpectralDensity(gpsWaveform, type, OutputDir)
    %% ===== Power Spectral Density of L1 C/A ===== %%
    if type == 1
        gpsScope = spectrumAnalyzer( ...
            Title = 'Spectrum of GPS Signal of L1 C/A PRN1', ...
            SpectrumType = "power-density", ...
            SpectrumUnits = "dBW/Hz");
        gpsScope(gpsWaveform/rms(gpsWaveform));
        
        % Save figure
        scopeFig = printToFigure(gpsScope, Visible=false);
        saveas(scopeFig, [OutputDir, 'PSD-L1CA-PRN1.png']);
    end
    
    %% ===== Power Spectral Density of L1C ===== %%
    if type == 2
        gpsScope = spectrumAnalyzer( ...
            Title = 'Spectrum of GPS Signal of L1C PRN1', ...
            SpectrumType = "power-density", ...
            SpectrumUnits = "dBW/Hz");
        gpsScope(gpsWaveform/rms(gpsWaveform));
        
        % Save figure
        scopeFig = printToFigure(gpsScope, Visible=false);
        saveas(scopeFig, [OutputDir, 'PSD-L1C-PRN1.png']);
    end
end