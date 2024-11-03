%% ========== Setup ========== %%
% ===== Setup
clc; clear; close all;

% ===== Creat Output Folder
OutputFolder = sprintf('OutputFigure');
if ~exist(OutputFolder, 'dir'); mkdir(OutputFolder); end

% ===== Initial Value
R = 0.1;
rng(0);
r = random('normal', 0, R, 1000, 1);
A = 1;
Phi = 1;
Qw = 0^2;

%% ========== Question 1 ========== %%
% ===== Case 1
X0_1 = 100;
Q0_1 = 10000^2;
Qw_1 = 0.0001^2;

estimated_X = kalman_filter(A, r, R, X0_1, Q0_1, Qw_1, Phi);
scatter_plot(1: length(estimated_X), estimated_X(:, 1), [OutputFolder '/exercise06_Q1_Case1']);

% ===== Case 2
X0_2 = 100;
Q0_2 = 0.0001^2;
Qw_2 = 0.0001^2;

estimated_X = kalman_filter(A, r, R, X0_2, Q0_2, Qw_2, Phi);
scatter_plot(1: length(estimated_X), estimated_X(:, 1), [OutputFolder '/exercise06_Q1_Case2']);

% ===== Case 3
X0_3 = 0;
Q0_3 = 10000^2;
Qw_3 = 0.0001^2;

estimated_X = kalman_filter(A, r, R, X0_3, Q0_3, Qw_3, Phi);
scatter_plot(1: length(estimated_X), estimated_X(:, 1), [OutputFolder '/exercise06_Q1_Case3']);

% ===== Case 4
X0_4 = 0;
Q0_4 = 0.0001^2;
Qw_4 = 0.0001^2;

estimated_X = kalman_filter(A, r, R, X0_4, Q0_4, Qw_4, Phi);
scatter_plot(1: length(estimated_X), estimated_X(:, 1), [OutputFolder '/exercise06_Q1_Case4']);

% ===== Case 5
X0_5 = 0;
Q0_5 = 10000^2;
Qw_5 = 100^2;

estimated_X = kalman_filter(A, r, R, X0_5, Q0_5, Qw_5, Phi);
scatter_plot(1: length(estimated_X), estimated_X(:, 1), [OutputFolder '/exercise06_Q1_Case5']);

% ===== Case 6
X0_6 = 0;
Q0_6 = 10000^2;
Qw_6 = 0.00001^2;

estimated_X = kalman_filter(A, r, R, X0_6, Q0_6, Qw_6, Phi);
scatter_plot(1: length(estimated_X), estimated_X(:, 1), [OutputFolder '/exercise06_Q1_Case6']);
