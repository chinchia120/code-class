%% ========== Setup ========== %%
% ===== Setup
clc; clear; close all;

%% ========== Read Grid Dataset ========== %%
FolderPath = uigetdir(pwd, 'Select Grid Folder');

%% ========== Creat Output Folder ========== %%
tmp = strsplit(FolderPath, '/');
OutputFolder = [cell2mat(tmp(end)) '_OutputFigure'];
if ~exist(OutputFolder, 'dir'); mkdir(OutputFolder); end

%% ========== Read Station Data ========== %%
StationData = readmatrix([FolderPath '/sta.dat'], 'FileType', 'text');
StationData = StationData(:, 1:2);

%% ========== Read Strain Data ========== %%
StrainFile = fopen([FolderPath '/strain.gmt']);
cnt = 0;
while ~feof(StrainFile)
    cnt = cnt + 1;
    strainspt = strsplit(fgetl(StrainFile), ' ');

    StrainData(cnt, :) = [str2double(strainspt(2:6))];
end
fclose(StrainFile);

%% ========== Plot Principal Strain Rate ========== %%
plotStrain(StationData, StrainData, [OutputFolder '/Strain']);

