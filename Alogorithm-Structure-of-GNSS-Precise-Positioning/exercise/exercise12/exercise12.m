%% ========== Setup ========== %%
% ===== Setup
clc; clear; close all;

% ===== Creat Output Folder
OutputFolder = sprintf('OutputFigure');
if ~exist(OutputFolder, 'dir'); mkdir(OutputFolder); end

% ===== Initial Value
CKSV = [-2956619.406; 5075902.161; 2476625.471];

ACOM = struct2array(load('A_Matrix.mat'));
LCOM = struct2array(load('L_Vector.mat'));
WeightMatrix = struct2array(load('WeightMatrix.mat'));
