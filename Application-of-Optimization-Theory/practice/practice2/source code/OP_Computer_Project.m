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
x0 = [ 5, -5;
      -9, -9;];

f = symfun(-cos(x1) * cos(x2) * exp((x1-pi).^2+(x2-pi).^2), [x1 x2]);
[f_gradient, f_hessian, f_approx, f_gradient_cg] = funcs_2d(f);

OutputFile1 = [OutputFile '/Question1.txt'];
fid = fopen(OutputFile1, 'w');
fprintf(fid, '%%%% ==================== Question 1 ==================== %%%%\r\n');
fclose(fid);

% ===== Optimization
for idx = 1: size(x0, 1)
    % ===== Newton Method
    [point, output, time, iter, loss, points_array, values_array] = newton_method(f, f_gradient, f_hessian, x0(idx, :), epsilon, max_iter, ub, lb);
    WriteOutputFile(point, output, time, iter, loss, points_array, values_array, 'Newton Method', OutputFile1);

    clear point output time iter loss points_array values_array;

    % ===== Steepest Descent Method
    [point, output, time, iter, loss, points_array, values_array] = gradient_descent(f, f_gradient, x0(idx, :), epsilon, max_iter, ub, lb);
    WriteOutputFile(point, output, time, iter, loss, points_array, values_array, 'Steepest Descent Method', OutputFile1);

    clear point output time iter loss points_array values_array;

    % ===== Conjugate Gradient Method
    [point, output, time, iter, loss, points_array, values_array] = nonlinear_CG(f_approx, f, f_gradient_cg, x0(idx, :), epsilon, max_iter, ub, lb);
    WriteOutputFile(point, output, time, iter, loss, points_array, values_array, 'Conjugate Gradient Method', OutputFile1);

    clear point output time iter loss points_array values_array;
end

% ===== Clear Variable
clear x1 x2 x0 ub lb epsilon max_iter f_gradient f_hessian f_approx f_gradient_cg;
