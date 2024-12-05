%% ========== Setup ========== %%
% ===== Setup
clc; clear; close all;

% ===== Creat Output Folder
OutputFolder = sprintf('OutputFigure');
if ~exist(OutputFolder, 'dir'); mkdir(OutputFolder); end

% ===== Initial Value
CKSV = -[2956619.417; 5075902.173; 2476625.484];

%% ========== Question 1 ========== %%
