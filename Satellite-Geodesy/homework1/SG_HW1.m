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

%% ========== Keplerian Motion ========== %%
% ===== Create Output File
file = fopen([OutputFolder '/SG_HW1_Keplerian.txt'], 'w');

% ===== Calculate State of Satellite
fprintf(file, '%%%% ========================= Satellite''s States Using Keplerian Motion ========================= %%%%\n');
fprintf(file, 'Hour\t        X\t                Y\t                Z\t           X_dot\t       Y_dot\t       Z_dot\n');
fprintf(file, '%3d\t %16.6f\t %16.6f\t %16.6f\t %12.6f\t %12.6f\t %12.6f\n', 0, X(1, :));

for i = 2: 60*60*24+1
    X(i, :) = helperRK4(X(i-1, :), 1, 1);
    if mod(i, 60*60) == 1
        fprintf(file, ' %2d\t %16.6f\t %16.6f\t %16.6f\t %12.6f\t %12.6f\t %12.6f\n', int32(i/3600), X(i, :));
    end
end

% ===== Close Output file
fclose(file);

%% ========== Keplerian with J2 ========== %%
% ===== Create Output File
file = fopen([OutputFolder '/SG_HW1_J2.txt'], 'w');

% ===== Calculate State of Satellite
fprintf(file, '%%%% ================== Satellite''s States Using Keplerian Motion and J2 Effect ================== %%%%\n');
fprintf(file, 'Hour\t        X\t                Y\t                Z\t           X_dot\t       Y_dot\t       Z_dot\n');
fprintf(file, ' %2d\t %16.6f\t %16.6f\t %16.6f\t %12.6f\t %12.6f\t %12.6f\n', 0, X(1, :));

for i = 2: 60*60*24+1
    X(i, :) = helperRK4(X(i-1, :), 1, 2);
    if mod(i, 60*60) == 1
        fprintf(file, ' %2d\t %16.6f\t %16.6f\t %16.6f\t %12.6f\t %12.6f\t %12.6f\n', int32(i/3600), X(i, :));
    end
end

% ===== Close Output file
fclose(file);
