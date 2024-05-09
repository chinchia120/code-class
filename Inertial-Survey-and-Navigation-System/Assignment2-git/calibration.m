%% ========== Setup ========== %%
% Setup
clc;
clear;
close all;

% Creat output folder and file
OutputFolder = sprintf('OutputFigure');
if ~exist(OutputFolder, 'dir'); mkdir(OutputFolder); end

%% ========== Open Example ========== %%
% openExample('shared_positioning/AllanVarianceExample');
% openExample('shared_positioning/DetermineAllanVarianceOfSingleAxisGyroscopeExample');

%% ========== Read File ========== %%
% Select GNSS file
PathGNSS = 'C:\Users\P66134111\Documents\code-class\Inertial-Survey-and-Navigation-System\Assignment2-git\Data\COM3_2024-05-09_15.12.53-up\';
FileGNSS = 'gnss_data_pointer.txt';
% [FileGNSS, PathGNSS, ~] = uigetfile('*.txt', 'Please select GNSS file (.txt)');
GNSS = readmatrix([PathGNSS, FileGNSS]);

% Select upside file
PathZUp = 'C:\Users\P66134111\Documents\code-class\Inertial-Survey-and-Navigation-System\Assignment2-git\Data\COM3_2024-05-09_15.12.53-up\';
FileZUp = 'imu_pointer.txt';
% [FileZUp, PathZUp, ~] = uigetfile('*.txt', 'Please select upside file (.txt)');
ZUp = readmatrix([PathZUp, FileZUp]);

% Select downside file
PathZDown = 'C:\Users\P66134111\Documents\code-class\Inertial-Survey-and-Navigation-System\Assignment2-git\Data\COM3_2024-05-09_15.00.31-down\';
FileZDown = 'imu_pointer.txt';
% [FileZDown, PathZDown, ~] = uigetfile('*.txt', 'Please select downside file (.txt)');
ZDown = readmatrix([PathZDown, FileZDown]);

% Select Allan file
PathAllan = 'C:\Users\P66134111\Documents\NCKU-Data\112-2\Inertial-Survey-and-Navigation-System\assignment\Assignment2-class\Sample\Assignment2\';
FileAllan = 'imu_pointer_Allan.txt';
% [FileAllan, PathAllan, ~] = uigetfile('*.txt', 'Please select Allan file (.txt)');
Allan = readmatrix([PathAllan, FileAllan]);

%% ========== Make Obervation Plot ========== %%
% Upside scatter
helperScatterPlotGyro(ZUp(:, [1 2 3 4]), 'negative', [OutputFolder, '\','Z1-Gyro']);
helperScatterPlotAcce(ZUp(:, [1 5 6 7]), 'negative', [OutputFolder, '\','Z1-Acce']);

% Downside scatter
helperScatterPlotGyro(ZDown(:, [1 2 3 4]), 'positive', [OutputFolder, '\','Z2-Gyro']);
helperScatterPlotAcce(ZDown(:, [1 5 6 7]), 'positive', [OutputFolder, '\','Z2-Acce']);

% Upside scatter of Z-Axis
helperScatterPlotGyro(ZUp(:, [1 4]), 'negative', [OutputFolder, '\','Z1-Gyro-z']);
helperScatterPlotAcce(ZUp(:, [1 7]), 'negative', [OutputFolder, '\','Z1-Acce-z']);

% Downside scatter of Z-Axis
helperScatterPlotGyro(ZDown(:, [1 4]), 'positive', [OutputFolder, '\','Z2-Gyro-z']);
helperScatterPlotAcce(ZDown(:, [1 7]), 'positive', [OutputFolder, '\','Z2-Acce-z']);

%% ========== Make Allan Plot ========== %%
% Accelerometer
helperAllanVarPlot(Allan(:, 2), 'Gyro-x', [OutputFolder, '\','AllanVar-Gyro-x']);
helperAllanVarPlot(Allan(:, 3), 'Gyro-y', [OutputFolder, '\','AllanVar-Gyro-y']);
helperAllanVarPlot(Allan(:, 4), 'Gyro-z', [OutputFolder, '\','AllanVar-Gyro-z']);

% Gyroscope
helperAllanVarPlot(Allan(:, 5), 'Acce-x', [OutputFolder, '\','AllanVar-Acce-x']);
helperAllanVarPlot(Allan(:, 6), 'Acce-y', [OutputFolder, '\','AllanVar-Acce-y']);
helperAllanVarPlot(Allan(:, 7), 'Acce-z', [OutputFolder, '\','AllanVar-Acce-z']);

%% ========== Calibration ========== %%
% Initial value
lat = mean(GNSS(:, 2)); % deg
AcceTrueZ = -9.8; % m/s^2
GyroTrueZ = 15*sind(lat)/60/60; % deg/s

% Accelerometer
AcceNegZ = mean(ZUp(:, 7));
AccePosZ = mean(ZDown(:, 7));

AcceBias = (AcceNegZ+AccePosZ)/2;
AcceScale = (AccePosZ-AcceNegZ-2*AcceTrueZ)/(2*AcceTrueZ);

% Gyroscope
GyroNegZ = -mean(ZUp(:, 4));
GyroPosZ = mean(ZDown(:, 4));

GyroBias = (GyroNegZ-GyroPosZ)/2;
GyroScale = (GyroPosZ+GyroNegZ-2*GyroTrueZ)/(2*GyroTrueZ);

% Output parameter
FilePara = fopen([OutputFolder, '\', 'Calibration-Parameter.txt'], 'w');
fprintf(FilePara,'%%%% ========== Calibration Parameter ========== %%%%\n');
fprintf(FilePara,'%% Accelerometer\n');
fprintf(FilePara,'Acce Bias  = %+.6f (m/s^2)\n', AcceBias);
fprintf(FilePara,'Acce Scale = %+.6f (m/s^2)\n\n', AcceScale);
fprintf(FilePara,'%% Gyroscope\n');
fprintf(FilePara,'Gyro Bias  = %+.6f (deg/s)\n', GyroBias);
fprintf(FilePara,'Gyro Scale = %+.6f (deg/s)\n', GyroScale);
fclose(FilePara);

