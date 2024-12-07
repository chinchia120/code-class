%% ========== Setup ========== %%
% ===== Setup
clc; clear; close all;

% ===== Creat Output Folder
OutputFolder = sprintf('OutputFigure');
if ~exist(OutputFolder, 'dir'); mkdir(OutputFolder); end

% ===== Initial Value
CKSV = [-2956619.417; 5075902.173; 2476625.484];
w = [0; 0; 7.2921151467*10^-5];
c = 299792458;
GM = 3.986005 * 10^14;
mat = load('CKSV_final_20230101.mat');
gsvmat = mat.gsvmat;

%% ========== Question 1 ========== %%
