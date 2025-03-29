%% ========== Setup ========== %%
% ===== Setup
clc; clear; close all;

%% ========== Read Dataset ========== %%
FolderPath = uigetdir(pwd, 'Select Dataset Folder');
Files = dir(fullfile(FolderPath, '*.gmt'));

%% ========== Creat Output Folder ========== %%
OutputFolder = sprintf('OutputFigure');
if ~exist(OutputFolder, 'dir'); mkdir(OutputFolder); end

%% ========== Plot Raw Time Series ========== %%
for sta = 1: 49
    staE = [FolderPath sprintf('/ts_CK%02d_e.gmt', sta)];
    staN = [FolderPath sprintf('/ts_CK%02d_n.gmt', sta)];
    staU = [FolderPath sprintf('/ts_CK%02d_u.gmt', sta)];

    plotTimeSeries(staE, staN, staU, sprintf('CK%02d', sta), [OutputFolder sprintf('/CK%02d', sta)]);
end

%% ========== Plot Filter Time Series ========== %%
for sta = 1: 49
    staE = [FolderPath sprintf('/ts_CK%02d_e_f.gmt', sta)];
    staN = [FolderPath sprintf('/ts_CK%02d_n_f.gmt', sta)];
    staU = [FolderPath sprintf('/ts_CK%02d_u_f.gmt', sta)];

    plotTimeSeriesFilter(staE, staN, staU, sprintf('CK%02d', sta), [OutputFolder sprintf('/CK%02d_filter', sta)]);
end

%% ========== Plot Common Mode Error ========== %%
for sta = 1: 1
    staE = [FolderPath '/come.gmt'];
    staN = [FolderPath '/comn.gmt'];
    staU = [FolderPath '/comu.gmt'];

    plotCommonModeError(staE, staN, staU, [OutputFolder '/CommonModeError']);
end

%% ========== Plot Velocities and Coseismic Displacements ========== %%
for sta = 1: 1
    cor = [FolderPath '/sta.dat'];
    dis = [FolderPath '/comfilt.out'];

    plotCommonModeError(cor, dis, [OutputFolder '/Displacement']);
end