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

%% ========== OpenExample ========== %%
% openExample('satcom/GPSWaveformGenerationExample');
% openExample('satcom/GPSReceiverAcquisitionTrackingUsingCACodeExample');
% openExample('shared_nav_satcom/EndtoEndGPSLNAVReceiverExample');

%% ========== GPS Waveform Generate ========== %%
% % PRN1
% [waveform_PRN1] = HelperGenerateGPSWaveform(PRN1);
% 
% % PRN2
% [waveform_PRN2] = HelperGenerateGPSWaveform(PRN2);

%% ========== Auto-Correlation ========== %%
% % PRN1
% HelperGPSAutoCorrelation(waveform_PRN1, 'PRN1', [OutputFolder, '\']);
% 
% % PRN2
% HelperGPSAutoCorrelation(waveform_PRN2, 'PRN2', [OutputFolder, '\']);

%% ========== Configure ========== %%
ConfigureSimulationParameters;

%% ========== Generate ========== %%
GenerateGPSIFWaveform;

%% ========== Tracking ========== %%
InitialSynchronizationandTracking;