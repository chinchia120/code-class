%% ========== Setup ========== %%
% Setup
clc;
clear;
close all;

% Creat output folder
OutputFolder = sprintf('OutputFigure');
if ~exist(OutputFolder, 'dir'); mkdir(OutputFolder); end

%% ========== Initial Value ========== %%
student_id = 'P66134111';
PRN1 = mod(str2num(extractAfter(student_id, 1)), 32) + 1;
PRN2 = mod(str2num(extractBefore(reverse(student_id), 9)), 32) + 1;

%% ========== Open Example ========== %%
% openExample('satcom/GPSWaveformGenerationExample');
% openExample('satcom/GPSL1CWaveformGenerationExample');

%% ========== GPS Waveform Generation ========== %%
% L1 C/A PRN1
[gpsBBWaveform_L1CA_PRN1] = HelperGPSL1CAGeneration(PRN1);

% L1 C/A PRN2
[gpsBBWaveform_L1CA_PRN2] = HelperGPSL1CAGeneration(PRN2);

% L1C PRN1
[gpsL1CWaveform_L1C_PRN1] = HelperGPSL1CGeneration(PRN1);

% L1C PRN2
[gpsL1CWaveform_L1C_PRN2] = HelperGPSL1CGeneration(PRN2);

%% ========== Auto-Correlation ========== %%
% L1 C/A PRN1
HelperGPSAutoCorrelation(gpsBBWaveform_L1CA_PRN1, 1, 'PRN1', [OutputFolder, '\']);

% L1 C/A PRN2
HelperGPSAutoCorrelation(gpsBBWaveform_L1CA_PRN2, 1, 'PRN2', [OutputFolder, '\']);

% L1C PRN1
HelperGPSAutoCorrelation(gpsL1CWaveform_L1C_PRN1, 2, 'PRN1', [OutputFolder, '\']);

% L1C PRN2
HelperGPSAutoCorrelation(gpsL1CWaveform_L1C_PRN2, 2, 'PRN2', [OutputFolder, '\']);

%% ========== Cross-Correlation ========== %%
% L1 C/A PRN1 and L1 C/A PRN2
HelperGPSCrossCorrelation(gpsBBWaveform_L1CA_PRN1, gpsBBWaveform_L1CA_PRN2, 1, [OutputFolder, '\']);

% L1C PRN1 and L1C PRN2
HelperGPSCrossCorrelation(gpsL1CWaveform_L1C_PRN1, gpsL1CWaveform_L1C_PRN2, 2, [OutputFolder, '\']);

% L1 C/A PRN2 and L1C PRN2
HelperGPSCrossCorrelation(gpsBBWaveform_L1CA_PRN2, gpsL1CWaveform_L1C_PRN2, 3, [OutputFolder, '\']);

%% ========== Power Spectral Density ========== %%
% L1 C/A PRN1
HelperGPSPowerSpectralDensity(gpsBBWaveform_L1CA_PRN1, 1, [OutputFolder, '\']);

% L1C PRN1
HelperGPSPowerSpectralDensity(gpsL1CWaveform_L1C_PRN1, 2, [OutputFolder, '\']);