%% ========== Setup ========== %%
% ===== Setup
clc; clear; close all;

%% ========== Read Dataset ========== %%
FolderPath = uigetdir(pwd, 'Select Folder');
Files = dir(fullfile(FolderPath, '*.gmt'));

%% ========== Creat Output Folder ========== %%
OutputFolder = sprintf('OutputFigure');
if ~exist(OutputFolder, 'dir'); mkdir(OutputFolder); end

%% ========== Plot Raw Time Series ========== %%
for sta = 1: length(Files)/3
    staE = [FolderPath sprintf('/ts_CK%02d_e.gmt', sta)];
    staN = [FolderPath sprintf('/ts_CK%02d_n.gmt', sta)];
    staU = [FolderPath sprintf('/ts_CK%02d_u.gmt', sta)];

    plotTimeSeries(staE, staN, staU, sprintf('CK%02d', sta), [OutputFolder sprintf('/CK%02d', sta)]);
end