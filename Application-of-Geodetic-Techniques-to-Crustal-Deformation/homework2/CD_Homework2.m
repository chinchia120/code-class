%% ========== Setup ========== %%
% ===== Setup
clc; clear; close all;

%% ========== Read Grid Dataset ========== %%
FolderPath = '/Users/chinchia120/Documents/code-class/Application-of-Geodetic-Techniques-to-Crustal-Deformation/dataset/32_P66134111_filter1_grid';
% FolderPath = uigetdir(pwd, 'Select Grid Folder');

%% ========== Creat Output Folder ========== %%
tmp = strsplit(FolderPath, '/');
OutputFolder = [cell2mat(tmp(end)) '_OutputFigure'];
if ~exist(OutputFolder, 'dir'); mkdir(OutputFolder); end

%% ========== Read Station Data ========== %%
StationData = readmatrix([FolderPath '/sta.dat'], 'FileType', 'text');
StationData = StationData(:, 1:2);

%% ========== Read Strain Data ========== %%
StrainFile = fopen([FolderPath '/strain.gmt']);
StrainData = cell2mat(textscan(StrainFile, '%f %f %f %f %f', 'Delimiter', '\t', 'MultipleDelimsAsOne', true));
fclose(StrainFile);

%% ========== Read Shear Data ========== %%
ShearFile = fopen([FolderPath '/shear_dex.gmt']);
ShearData = cell2mat(textscan(ShearFile, '%f %f %f %f', 'Delimiter', '\t', 'MultipleDelimsAsOne', true));
ShearData = ShearData(1:2:end, :);
fclose(ShearFile);

%% ========== Read Shear Angle Data ========== %%
AngleFile = fopen([FolderPath '/strain.out']);
AngleData = zeros(size(StrainData, 1), 1);
cnt = 0;
while ~feof(AngleFile)
    cnt = cnt + 1;

    anglespt = strsplit(fgetl(AngleFile), ' ');
    if cnt == 1; continue; end

    AngleData(cnt-1, :) = [str2double(anglespt(18))];
end
fclose(AngleFile);

%% ========== Plot Principal Strain Rate ========== %%
plotStrain(StationData, StrainData, [OutputFolder '/Strain']);

%% ========== Plot Shear Strain Rate ========== %%
ShearAngleData = [ShearData AngleData];
plotShear(StationData, ShearAngleData, [OutputFolder '/Shear']);