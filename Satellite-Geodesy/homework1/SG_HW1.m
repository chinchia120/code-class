%% ========== Setup ========== %%
% ===== Setup
clc; clear; close all;

% ===== Creat Output Folder
OutputFolder = sprintf('OutputFigure');
if ~exist(OutputFolder, 'dir'); mkdir(OutputFolder); end

% ===== Create Output File
file = fopen([OutputFolder '/SG_HW1_output.txt'], 'w');

% ===== Initial Value

%% ========== Q1 ========== %% 

%% ===== Close file
fclose(file);