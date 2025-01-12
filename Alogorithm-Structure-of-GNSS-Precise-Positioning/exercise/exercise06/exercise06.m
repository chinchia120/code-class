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
X0_1_1 = 100;
Q0_1_1 = 10000^2;
Qw_1_1 = 0.0001^2;

[estimated_X_1_1, ~] = kalman_filter(A, r, R, X0_1_1, Q0_1_1, Qw_1_1, Phi);
scatter_plot(1: length(estimated_X_1_1), estimated_X_1_1(:, 1), [OutputFolder '/exercise06_Q1_Case1']);

% ===== Case 2
X0_1_2 = 100;
Q0_1_2 = 0.0001^2;
Qw_1_2 = 0.0001^2;

[estimated_X_1_2, ~] = kalman_filter(A, r, R, X0_1_2, Q0_1_2, Qw_1_2, Phi);
scatter_plot(1: length(estimated_X_1_2), estimated_X_1_2(:, 1), [OutputFolder '/exercise06_Q1_Case2']);

% ===== Case 3
X0_1_3 = 0;
Q0_1_3 = 10000^2;
Qw_1_3 = 0.0001^2;

[estimated_X_1_3, ~] = kalman_filter(A, r, R, X0_1_3, Q0_1_3, Qw_1_3, Phi);
scatter_plot(1: length(estimated_X_1_3), estimated_X_1_3(:, 1), [OutputFolder '/exercise06_Q1_Case3']);

% ===== Case 4
X0_1_4 = 0;
Q0_1_4 = 0.0001^2;
Qw_1_4 = 0.0001^2;

[estimated_X_1_4, ~] = kalman_filter(A, r, R, X0_1_4, Q0_1_4, Qw_1_4, Phi);
scatter_plot(1: length(estimated_X_1_4), estimated_X_1_4(:, 1), [OutputFolder '/exercise06_Q1_Case4']);

% ===== Case 5
X0_1_5 = 0;
Q0_1_5 = 10000^2;
Qw_1_5 = 100^2;

[estimated_X_1_5, ~] = kalman_filter(A, r, R, X0_1_5, Q0_1_5, Qw_1_5, Phi);
scatter_plot(1: length(estimated_X_1_5), estimated_X_1_5(:, 1), [OutputFolder '/exercise06_Q1_Case5']);

% ===== Case 6
X0_1_6 = 0;
Q0_1_6 = 10000^2;
Qw_1_6 = 0.00001^2;

[estimated_X_1_6, ~] = kalman_filter(A, r, R, X0_1_6, Q0_1_6, Qw_1_6, Phi);
scatter_plot(1: length(estimated_X_1_6), estimated_X_1_6(:, 1), [OutputFolder '/exercise06_Q1_Case6']);

%% ========== Question 3 ========== %%
X0_3 = 0;
Q0_3 = 10000^2;
Qw_3 = 0.0001^2;

% ===== Forward
r_for = r;
[estimated_X_for, ~] = kalman_filter(A, r_for, R, X0_3, Q0_3, Qw_3, Phi);
scatter_plot(1: length(estimated_X_for), estimated_X_for(:, 1), [OutputFolder '/exercise06_Q3_for']);

% ===== Backward
r_bac = r(end:-1:1);
[estimated_X_bac, ~] = kalman_filter(A, r_bac, R, X0_3, Q0_3, Qw_3, Phi);
estimated_X_bac = estimated_X_bac(end:-1:1);
scatter_plot(1: length(estimated_X_bac), estimated_X_bac(:, 1), [OutputFolder '/exercise06_Q3_bac']);

%% ========== Question 4 ========== %%
% ===== Smoothing
estimated_X_smooth = (estimated_X_for+estimated_X_bac)/2;
scatter_plot(1: length(estimated_X_smooth), estimated_X_smooth(:, 1), [OutputFolder '/exercise06_Q4_smooth']);
