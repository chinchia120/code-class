%% ========== Setup ========== %%
% ===== Setup
clc; clear; close all;

% ===== Creat Output Folder
OutputFolder = sprintf('OutputFigure');
if ~exist(OutputFolder, 'dir'); mkdir(OutputFolder); end

% ===== Initial Value
CKSV = [-2956619.406; 5075902.161; 2476625.471];
SigmaPhase = 0.003; 
SigmaCode = 0.300;
SigmaX = 100;
SigmaY = 100;
SigmaZ = 100;
SigmaN = 0;
SigmaZTD = 0.00003;

ACOM = struct2array(load('A_Matrix.mat'));
LCOM = struct2array(load('L_Vector.mat'));
WeightMatrix = struct2array(load('WeightMatrix.mat'));

%% ========== Design Matrix ========== %%
TransitionMatrix = diag([ones(size(ACOM{1}, 2), 1)]);
VCMatrix = diag([SigmaX^2 SigmaY^2 SigmaZ^2 SigmaN^2*ones(1, 77) SigmaZTD^2]);
InitialVector = zeros(size(ACOM{1}, 2), 1);
InitialVCMatrix = diag([SigmaX^2 SigmaY^2 SigmaZ^2 SigmaN^2*ones(1, 77) SigmaZTD^2]);

%% ========== Kalman Filter ========== %%
[estimatedX, estimatedQx] = KalmanFilter(ACOM, LCOM, WeightMatrix, InitialVector, InitialVCMatrix, VCMatrix, TransitionMatrix);

%% ========== Static ========== %%
Static_X = zeros(length(ACOM), 1);
Static_Y = zeros(length(ACOM), 1);
Static_Z = zeros(length(ACOM), 1);
Static_ZTD = zeros(length(ACOM), 1);

for i = 1: length(Static_X)
    X = estimatedX{i};
    Static_X(i) = X(1);
    Static_Y(i) = X(2);
    Static_Z(i) = X(3);
    Static_ZTD(i) = X(end);
end

% GNSSAnalysis(1: length(Static_X), Static_X, [OutputFolder '/StaticX']);
% GNSSAnalysis(1: length(Static_Y), Static_Y, [OutputFolder '/StaticY']);
% GNSSAnalysis(1: length(Static_Z), Static_Z, [OutputFolder '/StaticZ']);
% GNSSAnalysis(1: length(Static_ZTD), Static_ZTD, [OutputFolder '/StaticZTD']);

%% ========== Kinematic ========== %%
Kinematic_X = zeros(length(ACOM), 1);
Kinematic_Y = zeros(length(ACOM), 1);
Kinematic_Z = zeros(length(ACOM), 1);
Kinematic_ZTD = zeros(length(ACOM), 1);

for i = 1: length(Kinematic_X)
    X = estimatedX{i};
    Kinematic_X(i) = X(1);
    Kinematic_Y(i) = X(2);
    Kinematic_Z(i) = X(3);
    Kinematic_ZTD(i) = X(end);
end

GNSSAnalysis(1: length(Kinematic_X), Kinematic_X, [OutputFolder '/KinematicX']);
GNSSAnalysis(1: length(Kinematic_Y), Kinematic_Y, [OutputFolder '/KinematicY']);
GNSSAnalysis(1: length(Kinematic_Z), Kinematic_Z, [OutputFolder '/KinematicZ']);
GNSSAnalysis(1: length(Kinematic_ZTD), Kinematic_ZTD, [OutputFolder '/KinematicZTD']);
