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
[waveform] = HelperGenerateGPSWaveform(PRN1);

downsampleFactor = 1;
I_sample = real(waveform(1:downsampleFactor:end));
Q_sample = imag(waveform(1:downsampleFactor:end));

plot(1:1023, I_sample(1:1023));
%plot(1:1023, Q_sample(1:1023));