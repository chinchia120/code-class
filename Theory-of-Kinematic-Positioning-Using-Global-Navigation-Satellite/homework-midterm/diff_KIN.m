%% ========== Setup ========== %%
clc;
clear;
close all;

%% ========== Initial Value ========== %%
ABMF = [2919785.7178, -5383745.0532, 1774604.7152];

%% ========== Select Input Folder ========== %%
PathNameInput = 'C:\Users\chin\Documents\code-git\Theory-of-Kinematic-Positioning-Using-Global-Navigation-Satellite\homework-midterm\input-KIN';
%PathNameInput = uigetdir(addpath(genpath(pwd)), 'Please Select Input Folder.');
FileList = dir(fullfile(PathNameInput, '*.KIN'));

%% ========== Select Output Folder ========== %%
PathNameOutput = 'C:\Users\chin\Documents\code-git\Theory-of-Kinematic-Positioning-Using-Global-Navigation-Satellite\homework-midterm\output-figure';
%PathNameOutput = uigetdir(addpath(genpath(pwd)), 'Please Select Output Folder.');

%% ========== Load Data ========== %%
RawData = [];
for i = 1: numel(FileList)
    file = readmatrix([FileList(i).folder,'\' FileList(i).name], 'FileType', 'text', 'ConsecutiveDelimitersRule', 'join', 'Range', 7);
    res = [file(:, 3: 4), file(:, 5)-ABMF(1), file(:, 6)-ABMF(2), file(:, 7)-ABMF(3)];
    RawData(size(RawData, 1)+1: size(RawData, 1)+size(res, 1), :) = res;

    scatter_plot(res(:, 2), res(:, 3: 5), sprintf('Difference of Day of GPS Week %d%d', res(1, 1), fix(res(1, 2)/86400)), sprintf('%s\\difference-KIN-%d%d.png', PathNameOutput, res(1, 1), fix(res(1, 2)/86400)));
end

%% ========== Make Plot ========== %%
scatter_plot(RawData(:, 2), RawData(:, 3: 5), sprintf('Difference of Day of GPS Week %d%d to %d%d', RawData(1, 1), fix(RawData(1, 2)/86400), RawData(end, 1), fix(RawData(end, 2)/86400)), sprintf('%s\\difference-KIN.png', PathNameOutput));
