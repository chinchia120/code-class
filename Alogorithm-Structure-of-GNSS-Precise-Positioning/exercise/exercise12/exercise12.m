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
SigmaX = 0;
SigmaY = 0;
SigmaZ = 0;
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
[estimatedX, ~] = kalman_filter(ACOM, LCOM, WeightMatrix, InitialVector, InitialVCMatrix, VCMatrix, TransitionMatrix);




