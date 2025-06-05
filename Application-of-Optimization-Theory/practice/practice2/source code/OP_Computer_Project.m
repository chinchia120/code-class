%% ========== Setup ========== %%
% ===== Setup
clc; clear; close all;

% ===== Output Figure
OutputFigure = sprintf('OutputFigure');
if ~exist(OutputFigure, 'dir'); mkdir(OutputFigure); end

% ===== Output File
OutputFile = sprintf('OutputFile');
if ~exist(OutputFile, 'dir'); mkdir(OutputFile); end

%% ========== Question 1 ========== %%
% ===== Config
syms x1 x2;

epsilon = 0.0001;
max_iter = 100;

ub = [10, 10];
lb = [-10, -10];

f = symfun(-cos(x1) * cos(x2) * exp((x1-pi)^2+(x2-pi)^2), [x1 x2]);
[f_gradient,f_hessian,f_approx,f_gradient_cg] = funcs_2d(f);

OutputFile1 = [OutputFile '/Question1.txt'];

% ===== Initial Value 1
x0 = [5, -5];

% ===== Newton Method
[point, output, time, iter, loss, points_array, values_array] = newton_method(f, f_gradient,f_hessian, x0, epsilon, max_iter, ub, lb);
WriteOutputFile(point, output, time, iter, loss, points_array, values_array, 'Newton Method', OutputFile1);

clear point output time iter loss points_array values_array;

% ===== Steepest Descent Method
[point, output, time, iter, loss, points_array, values_array] = gradient_descent(f, f_gradient, x0, epsilon, max_iter, ub, lb);
WriteOutputFile(point, output, time, iter, loss, points_array, values_array, 'Steepest Descent Method', OutputFile1);

clear point output time iter loss points_array values_array;

% ===== Conjugate Gradient Method
