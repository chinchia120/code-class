%% ========== Setup ========== %%
clc;
clear;
close all;

OutputFolder = sprintf('OutputFigure');
if ~exist([pwd, '\', OutputFolder], 'dir')
    mkdir(OutputFolder);
end

%% ========== Open Example ========== %%
% openExample('shared_positioning/AllanVarianceExample');
% openExample('shared_positioning/DetermineAllanVarianceOfSingleAxisGyroscopeExample');

%% ========== Read File ========== %%
% Select Z1 file
PathZ1 = 'C:\Users\P66134111\Documents\code-class\Inertial-Survey-and-Navigation-System\Assignment2-git\data-sample\';
FileZ1 = 'imu_pointer_z1.txt';
% [FileZ1, PathZ1, ~] = uigetfile('*.txt', 'Please select Z1 file (.txt)');
Z1 = load([PathZ1, FileZ1]);

% Select Z2 file
PathZ2 = 'C:\Users\P66134111\Documents\code-class\Inertial-Survey-and-Navigation-System\Assignment2-git\data-sample\';
FileZ2 = 'imu_pointer_z2.txt';
% [FileZ2, PathZ2, ~] = uigetfile('*.txt', 'Please select Z2 file (.txt)');
Z2 = load([PathZ2, FileZ2]);

% Select Allen file
PathAllen = 'C:\Users\P66134111\Documents\NCKU-Data\112-2\Inertial-Survey-and-Navigation-System\assignment\Assignment2-class\Sample\Assignment2\';
FileAllen = 'imu_pointer_Allan.txt';
% [FileAllen, PathAllen, ~] = uigetfile('*.txt', 'Please select Allen file (.txt)');
Allen = load([PathAllen, FileAllen]);

%% ========== Make Scatter Plot ========== %%
% Z1 scatter
helperScatterPlotGyro(Z1(1:25979, [1 2 3 4]), [OutputFolder, '\','Z1-Gyro']);
helperScatterPlotAcce(Z1(1:25979, [1 5 6 7]), [OutputFolder, '\','Z1-Acce']);

% Z2 scatter
helperScatterPlotGyro(Z2(1:13580, [1 2 3 4]), [OutputFolder, '\','Z2-Gyro']);
helperScatterPlotAcce(Z2(1:13580, [1 5 6 7]), [OutputFolder, '\','Z2-Acce']);

% Z1 scatter of Z-Axis
helperScatterPlotGyro(Z1(1:25979, [1 4]), [OutputFolder, '\','Z1-Gyro-z-axis']);
helperScatterPlotAcce(Z1(1:25979, [1 7]), [OutputFolder, '\','Z1-Acce-z-axis']);

% Z2 scatter of Z-Axis
helperScatterPlotGyro(Z2(1:13580, [1 4]), [OutputFolder, '\','Z2-Gyro-z-axis']);
helperScatterPlotAcce(Z2(1:13580, [1 7]), [OutputFolder, '\','Z2-Acce-z-axis']);

%% ========== Make Allan Plot ========== %%
% [avar,tau] = allanvar(Allen(:, 2), 'octave', 50);
% 
% loglog(tau,avar);
% xlabel('\tau');s
% ylabel('\sigma^2(\tau)');
% title('Allan Variance');
% grid on;