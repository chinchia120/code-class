%% ========== Setup ========== %%
% ===== Setup
clear; close all;

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

if ispc; OutputFile = [OutputFolder '\' extractBefore(expfname, '.txt')];
elseif isunix; OutputFile = [OutputFolder '/' extractBefore(expfname, '.txt')]; end

%% ========== Error Analysis ========== %%
ReceiverAnalysis(expData, refData, OutputFile);