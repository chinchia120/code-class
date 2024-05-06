%% ========== Setup ========== %%
clc;
clear;
close all;

%% ========== Select Input Folder ========== %%
PathNameInput = 'C:\Users\chin\Documents\code-git\Theory-of-Kinematic-Positioning-Using-Global-Navigation-Satellite\homework-midterm\input-OUT';
%PathNameInput = uigetdir(addpath(genpath(pwd)), 'Please Select Input Folder.');
FileList = dir(fullfile(PathNameInput, '*.OUT'));

%% ========== Select Output Folder ========== %%
PathNameOutput = 'C:\Users\chin\Documents\code-git\Theory-of-Kinematic-Positioning-Using-Global-Navigation-Satellite\homework-midterm\output-figure';
%PathNameOutput = uigetdir(addpath(genpath(pwd)), 'Please Select Output Folder.');

%% ========== Load Data ========== %%
RawData = [];
for i = 1: numel(FileList)
    file = readmatrix([FileList(i).folder,'\' FileList(i).name], 'FileType', 'text', 'ConsecutiveDelimitersRule', 'join', 'Range', 72);
    RawData(size(RawData, 1)+1: size(RawData, 1)+size(file, 1), :) = file(:, 1: 20);
end

%% ========== Make Plot ========== %%
scatter_plot(RawData(:, 2), [RawData(:, 7), RawData(:, 10), RawData(:, 13)], 'difference', sprintf('%s\\difference-OUT.png', PathNameOutput));
