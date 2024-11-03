%% ========== Setup ========== %%
% ===== Setup
clc; clear; close all;

% ===== Creat Output Folder
OutputFolder = sprintf('OutputFigure');
if ~exist(OutputFolder, 'dir'); mkdir(OutputFolder); end

% ===== Create Output File
file = fopen([OutputFolder '/SG_HW1_output.txt'], 'w');

% ===== Initial Value
x = 20952940.878790;        % m
y = 11599221.8785432;       % m
z = 11802653.3351916;       % m
vx = -2338.53157760597;     % m/s
vy = 1501.60308576919;      % m/s
vz = 2669.76244747639;      % m/s

GM = 3.986005 * 10^14;      % m^3/s^2
ae = 6378137;               % m

%% ========== Q1 ========== %% 

a = helperAcceleration(x, y, z)

%% ===== Close file
fclose(file);