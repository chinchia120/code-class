%% ========== Setup ========== %%
% ===== Setup
clc; clear; close all;

%% ========== Question 1 ========== %%
func1 = @(x,y) (x^2 + y^2 + 3*x - 4*y + 6);
initial = [0, 0];
ub = [10, 10];
lb = [-10, -10];

%% ========== Question 2 ========== %%