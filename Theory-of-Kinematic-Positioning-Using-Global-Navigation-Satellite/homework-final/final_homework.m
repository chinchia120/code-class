%% ========== Setup ========== %%
clc;
clear;
close all;

%% ========== Select Input Folder ========== %%
PathNameInput = uigetdir(addpath(genpath(pwd)), 'Please Select Input .FRS Folder.');
FileList = dir(fullfile(PathNameInput, '*.FRS'));

%% ========== Select Output Folder ========== %%
PathNameOutput = uigetdir(addpath(genpath(pwd)), 'Please Select Output Folder.');

%% ========== Load Data ========== %%
RawData = [];

for i = 1: numel(FileList)
    file = readmatrix([FileList(i).folder,'\' FileList(i).name], 'FileType', 'text', 'ConsecutiveDelimitersRule', 'join', 'Range', 22);
    RawData(size(RawData, 1)+1: size(RawData, 1)+size(file, 1), :) = file;
end
