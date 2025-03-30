%% ========== Setup ========== %%
% ===== Setup
clc; clear; close all;

%% ========== Read Dataset ========== %%
FolderPath = uigetdir(pwd, 'Select Folder');
Files = dir(fullfile(FolderPath, '*.gmt'));

%% ========== Creat Output Folder ========== %%
OutputFolder = sprintf([FolderPath '_nohearder']);
if ~exist(OutputFolder, 'dir'); mkdir(OutputFolder); end

%% ========== Remove Header ========== %%
for i = 1:length(Files)
    % ===== Select .gmt file
    FilePath = fullfile(FolderPath, Files(i).name);
    FileData = readmatrix(FilePath, 'FileType', 'text');
    
    % ===== Select Output File
    OutputFile = sprintf([OutputFolder '/' Files(i).name]);
    fid = fopen(OutputFile, 'w');

    for j = 1:length(FileData)
        fprintf(fid, '%.5f    %8.4f    %8.4f\r\n', FileData(j, 1:3));
    end
    fclose(fid);
end