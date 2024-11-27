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
chip = 10;
helperPlotCACode([CA_01; CA_13; CA_19; CA_22], [01; 13; 19; 22], chip, [OutputFolder '/CA-Code-Figure']);

%% ========== Problem 2 ========== %%
% ===== Auto-Correlation of PRN 13
CA_13_Shift = circshift(CA_13, -500);
helperCorrelation(CA_13, CA_13_Shift, 13, [OutputFolder '/Auto-Correlation-PRN13-Shift']);

% ===== Cross-Correlation of PRN 19 and PRN 22
helperCorrelation(CA_19, CA_22, [19, 22], [OutputFolder '/Cross-Correlation-PRN19-PRN22']);

% ===== Auto-correlation of Signal
helperCorrelation(CA_01, signal_1, 01, [OutputFolder '/Auto-Correlation-PRN01']);
helperCorrelation(CA_13, signal_1, 13, [OutputFolder '/Auto-Correlation-PRN13']);
helperCorrelation(CA_19, signal_1, 19, [OutputFolder '/Auto-Correlation-PRN19']);
helperCorrelation(CA_22, signal_1, 22, [OutputFolder '/Auto-Correlation-PRN22']);