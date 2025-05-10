%% ========== Setup ========== %%
% ===== Setup
clc; clear; close all;

%% ========== Question 5 ========== %%
P = [1 0 1; -1 1 0; 1 -1 -1];
P_inv = inv(P);
A = [1 3 3; -3 -5 -3; 3 3 1];
A*A*A*A*A
P*diag([1 -32 -32])*inv(P)