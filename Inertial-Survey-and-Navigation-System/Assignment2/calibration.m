%% ========== Setup ========== %%
% Setup
clc;
clear;
close all;

% Creat output folder
OutputFolder = sprintf('OutputFigure');
if ~exist(OutputFolder, 'dir'); mkdir(OutputFolder); end

%% ========== Open Example ========== %%
% openExample('shared_positioning/AllanVarianceExample');
% openExample('shared_positioning/DetermineAllanVarianceOfSingleAxisGyroscopeExample');

%% ========== Read File ========== %%
% Select GNSS file
PathGNSS = 'C:\Users\P66134111\Documents\DATA\Class\Inertial-Survey-and-Navigation-System\Assignment2\COM3_2024-05-09_15.12.53-up\';
FileGNSS = 'gnss_data_pointer.txt';
% [FileGNSS, PathGNSS, ~] = uigetfile('*.txt', 'Please select GNSS file (.txt)');
GNSS = readmatrix([PathGNSS, FileGNSS]);

% Select IMU upward file
PathZUp = 'C:\Users\P66134111\Documents\DATA\Class\Inertial-Survey-and-Navigation-System\Assignment2\COM3_2024-05-09_15.12.53-up\';
FileZUp = 'imu_pointer.txt';
% [FileZUp, PathZUp, ~] = uigetfile('*.txt', 'Please select IMU upward file (.txt)');
ZUp = readmatrix([PathZUp, FileZUp]);

% Select IMU downward file
PathZDown = 'C:\Users\P66134111\Documents\DATA\Class\Inertial-Survey-and-Navigation-System\Assignment2\COM3_2024-05-09_15.00.31-down\';
FileZDown = 'imu_pointer.txt';
% [FileZDown, PathZDown, ~] = uigetfile('*.txt', 'Please select IMU downward file (.txt)');
ZDown = readmatrix([PathZDown, FileZDown]);

% Select Allan Variance file
PathAllan = 'C:\Users\P66134111\Documents\DATA\Class\Inertial-Survey-and-Navigation-System\Assignment2\Sample-Allan\';
FileAllan = 'imu_pointer_Allan.txt';
% [FileAllan, PathAllan, ~] = uigetfile('*.txt', 'Please select Allan file (.txt)');
Allan = readmatrix([PathAllan, FileAllan]);

%% ========== Make Obervation Plot ========== %%
% Upward scatter
helperScatterPlotGyro(ZUp(:, [1 2 3 4]), 'Upward', [OutputFolder, '\','Z1-Gyro']);
helperScatterPlotAcce(ZUp(:, [1 5 6 7]), 'Upward', [OutputFolder, '\','Z1-Acce']);

% Downward scatter
helperScatterPlotGyro(ZDown(:, [1 2 3 4]), 'Downward', [OutputFolder, '\','Z2-Gyro']);
helperScatterPlotAcce(ZDown(:, [1 5 6 7]), 'Downward', [OutputFolder, '\','Z2-Acce']);

% Upward scatter of Z-Axis
helperScatterPlotGyro(ZUp(:, [1 4]), 'Upward', [OutputFolder, '\','Z1-Gyro-z']);
helperScatterPlotAcce(ZUp(:, [1 7]), 'Upward', [OutputFolder, '\','Z1-Acce-z']);

% Downward scatter of Z-Axis
helperScatterPlotGyro(ZDown(:, [1 4]), 'Downward', [OutputFolder, '\','Z2-Gyro-z']);
helperScatterPlotAcce(ZDown(:, [1 7]), 'Downward', [OutputFolder, '\','Z2-Acce-z']);

%% ========== Calibration ========== %%
% Initial value
lat = mean(GNSS(:, 2)); % deg
GyroTrueZ = 15*sind(lat)/60/60; % deg/s
AcceTrueZ = -9.7890; % m/s^2

% Gyroscope
GyroUpZ = mean(ZUp(:, 4));
GyroDownZ = mean(ZDown(:, 4));

[GyroScale, GyroBias] = helperCalirate(GyroUpZ, GyroDownZ, GyroTrueZ);

% Accelerometer
AcceUpZ = mean(ZUp(:, 7));
AcceDownZ = mean(ZDown(:, 7));

[AcceScale, AcceBias] = helperCalirate(AcceUpZ, AcceDownZ, AcceTrueZ);

%% ========== Make Allan Plot ========== %%
% Gyroscope
[GyroRandomWalk, GyroBiasInstability] = helperAllanVarModel(Allan(:, 4), 'Gyroscope', [OutputFolder, '\','Gyro-']);

% Accelerometer
[AcceRandomWalk, AcceBiasInstability] = helperAllanVarModel(Allan(:, 7), 'Accelerometer', [OutputFolder, '\','Acce-']);

%% ========== Output parameter ========== %%
FilePara = fopen([OutputFolder, '\', 'Calibration-Parameter.txt'], 'w');

fprintf(FilePara,'%%%% ========== Calibration Parameter ========== %%%%\n');
fprintf(FilePara,'%% Gyroscope\n');
fprintf(FilePara,'Gyro Scale = %.6f (deg/s)\n', GyroScale);
fprintf(FilePara,'Gyro Bias  = %.6f (deg/s)\n', GyroBias);
fprintf(FilePara,'Gyro Z Upward   = %.6f (deg/s)\n', GyroUpZ);
fprintf(FilePara,'Gyro Z Downward = %.6f (deg/s)\n\n', GyroDownZ);

fprintf(FilePara,'%% Accelerometer\n');
fprintf(FilePara,'Acce Scale = %.6f (m/s^2)\n', AcceScale);
fprintf(FilePara,'Acce Bias  = %.6f (m/s^2)\n', AcceBias);
fprintf(FilePara,'Acce Z Upward   = %.6f (m/s^2)\n', AcceUpZ);
fprintf(FilePara,'Acce Z Downward = %.6f (m/s^2)\n\n', AcceDownZ);

fprintf(FilePara,'%% Allan Variance\n');
fprintf(FilePara,'Angle Random Walk     = %.6f (deg/sqrt(h))\n', GyroRandomWalk*60);
fprintf(FilePara,'Gyro Bias Instability = %.6f (deg/h)\n', GyroBiasInstability*3600);
fprintf(FilePara,'Velocity Random Walk  = %.6f (m/s/sqrt(h))\n', AcceRandomWalk*60);
fprintf(FilePara,'Acce Bias Instability = %.6f (uG)', AcceBiasInstability/9.8*10^6);

fclose(FilePara);