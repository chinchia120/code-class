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
% openExample('satcom/GPSReceiverAcquisitionTrackingUsingCACodeExample');
% openExample('shared_nav_satcom/EndtoEndGPSLNAVReceiverExample');

%% ========== Sample Code ========== %%
[waveform] = HelperGenerateGPSIFWaveform(PRN1, PRN2);

I_sample = real(waveform);
Q_sample = imag(waveform);

plot(1:size(I_sample, 1), I_sample);