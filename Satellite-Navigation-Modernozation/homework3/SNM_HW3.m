%% ========== Setup ========== %%
% ===== Setup
clc; clear; close all;

% ===== Creat Output Folder
OutputFolder = sprintf('OutputFigure');
if ~exist(OutputFolder, 'dir'); mkdir(OutputFolder); end

% ===== Create Output File
% file = fopen([OutputFolder '/SNM_HW2_output.txt'], 'w');

% ===== Initial Value
mat = load('signal.mat');
signal_1 = mat.signal_1;
G1 = ones(1, 10);
G2 = ones(1, 10);

%% ========== Problem 1 ========== %%
% ===== PRN Setup
PRN_01 = [2 6];
PRN_13 = [6 7];
PRN_19 = [3 6];
PRN_22 = [6 9];

% ===== Generate C/A Code with Different PRN 
CA_01 = helperCAGenerator(PRN_01, G1, G2);
CA_13 = helperCAGenerator(PRN_13, G1, G2);
CA_19 = helperCAGenerator(PRN_19, G1, G2);
CA_22 = helperCAGenerator(PRN_22, G1, G2);

% ===== Plot C/A Code with Different PRN
helperPlotCACode([CA_01; CA_13; CA_19; CA_22], [01; 13; 19; 22], [OutputFolder '/CA-Code-Figure']);

