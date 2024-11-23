%% ========== Setup ========== %%
% ===== Setup
clc; clear; close all;

% ===== Creat Output Folder
OutputFolder = sprintf('OutputFigure');
if ~exist(OutputFolder, 'dir'); mkdir(OutputFolder); end

% ===== Create Output File
% file = fopen([OutputFolder '/SNM_HW2_output.txt'], 'w');

% ===== Initial Value
mat = load('signal.mat');
signal_1 = mat.signal_1;

%% ========== Problem 1 ========== %%

