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
% Select file Z1
PathZ1 = 'C:\Users\P66134111\Documents\code-class\Inertial-Survey-and-Navigation-System\Assignment2-git\data-sample\';
FileZ1 = 'imu_pointer_z1.txt';
% PathZ1 = 'C:\Users\chin\Documents\code-class\Inertial-Survey-and-Navigation-System\Assignment2-git\data-sample\';
% [FileZ1, PathZ1, ~] = uigetfile('*.txt', 'Please select Z1 file (.txt)');
Z1 = load([PathZ1, FileZ1]);

% Select file Z2
PathZ2 = 'C:\Users\P66134111\Documents\code-class\Inertial-Survey-and-Navigation-System\Assignment2-git\data-sample\';
FileZ2 = 'imu_pointer_z2.txt';
% PathZ2 = 'C:\Users\chin\Documents\code-class\Inertial-Survey-and-Navigation-System\Assignment2-git\data-sample\';
% [FileZ2, PathZ2, ~] = uigetfile('*.txt', 'Please select Z2 file (.txt)');
Z2 = load([PathZ2, FileZ2]);

%% ========== Make Scatter Plot ========== %%
% Z1 scatter
helperScatterPlotGyro(Z1(1:25979, [1 2 3 4]), [OutputFolder, '\','Z1-Gyro']);
helperScatterPlotAcce(Z1(1:25979, [1 5 6 7]), [OutputFolder, '\','Z1-Acce']);

% Z2 scatter
helperScatterPlotGyro(Z2(1:13580, [1 2 3 4]), [OutputFolder, '\','Z2-Gyro']);
helperScatterPlotAcce(Z2(1:13580, [1 5 6 7]), [OutputFolder, '\','Z2-Acce']);