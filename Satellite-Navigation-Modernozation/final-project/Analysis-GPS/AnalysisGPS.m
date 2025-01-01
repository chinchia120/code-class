%% ========== Setup ========== %%
% ===== Setup
clear; close all; close all;

%% ========== Select Reference File ========== %%
[reffname, refpname] = uigetfile({'*.txt'}, 'Please Select Reference File', pwd);
refData = readmatrix([refpname, reffname]);

%% ========== Select Experiment File ==========%%
[expfname, exppname] = uigetfile({'*.txt'}, 'Please Select Experiment File', refpname);
expData = readmatrix([exppname, expfname]);

%% ========== Creat Output Folder ========== %%
% ===== Output Folder
OutputFolder = sprintf('OutputFigure');
if ~exist(OutputFolder, 'dir'); mkdir(OutputFolder); end

% ===== Output File
OutputFile = [OutputFolder '/' extractBefore(expfname, '.txt')];

%% ========== Error Analysis ========== %%
ReceiverAnalysis(expData, refData, OutputFile);