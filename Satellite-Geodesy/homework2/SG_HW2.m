%% ========== Setup ========== %%
% ===== Setup
clc; clear; close all;

% ===== Creat Output Folder
OutputFolder = sprintf('OutputFigure');
if ~exist(OutputFolder, 'dir'); mkdir(OutputFolder); end

% ===== Initial Value
x = 20952940.878790;        % m
y = 11599221.8785432;       % m
z = 11802653.3351916;       % m
vx = -2338.53157760597;     % m/s
vy = 1501.60308576919;      % m/s
vz = 2669.76244747639;      % m/s

X = zeros(60*60*24+1, 6);
X(1, :) = [x y z vx vy vz];

we = 7.292115*10^-5;        % rad/s
GAST0 = 0;

%% ========== Sub-Satellite Track ========== %%
pos = zeros(60*60*24, 2);
for i = 2: 60*60*24+1
    X(i, :) = helperRK4(X(i-1, :), 1, 2);
    GAST = rad2deg(GAST0 + we*(i-1));
    sphe = xyz2sphe(X(i, 1: 3));
    pos(i-1, :) = ([sphe(1)-GAST sphe(2)]);
    
    if pos(i-1, 1) < -180; pos(i-1, 1) = pos(i-1, 1) + 360; end
end

%% ========== Plot Trajectory ========== %%
helperScatter(pos(:, 2), pos(:, 1), [OutputFolder '/ground_track']);