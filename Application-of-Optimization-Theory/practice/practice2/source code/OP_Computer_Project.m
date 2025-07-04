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

ub = [ 10,  10];
lb = [-10, -10];
x0 = [ 5.0,-5.0;
      -9.0,-9.0;
      -9.9999,-9.9999];

f = symfun(-cos(x1) .* cos(x2) .* exp((x1-pi).^2+(x2-pi).^2), [x1 x2]);
f_plot = @(x1, x2)(-cos(x1) .* cos(x2) .* exp((x1-pi).^2+(x2-pi).^2));
[f_gradient, f_hessian, f_approx, f_gradient_cg] = funcs_2d(f);

OutputFile1 = [OutputFile '/Question1.txt'];
fid = fopen(OutputFile1, 'w');
fprintf(fid, '%%%% ==================== Question 1 ==================== %%%%\r\n');
fclose(fid);

% ===== Optimization
for idx = 1: size(x0, 1)
    % ===== Newton Method
    [point, output, time, iter, loss, points_array, values_array] = newton_method(f, f_gradient, f_hessian, x0(idx, :), epsilon, max_iter, ub, lb);
    WriteOutFile(point, output, time, iter, points_array, 'Newton Method', OutputFile1);
    PlotOutFigure(f_plot, ub, lb, loss, points_array, values_array, 'Newton Method', sprintf([OutputFigure '/Question1_Ini%d_NT'], idx));
    PlotOutFigureAll(f_plot, ub, lb, loss, points_array, values_array, 'Newton Method', sprintf([OutputFigure '/Question1_Ini%d_NT'], idx));

    clear point output time iter loss points_array values_array;

    % ===== Steepest Descent Method
    [point, output, time, iter, loss, points_array, values_array] = gradient_descent(f, f_gradient, x0(idx, :), epsilon, max_iter, ub, lb);
    WriteOutFile(point, output, time, iter, points_array, 'Steepest Descent Method', OutputFile1);
    PlotOutFigure(f_plot, ub, lb, loss, points_array, values_array, 'Steepest Descent Method', sprintf([OutputFigure '/Question1_Ini%d_SD'], idx));
    PlotOutFigureAll(f_plot, ub, lb, loss, points_array, values_array, 'Steepest Descent Method', sprintf([OutputFigure '/Question1_Ini%d_SD'], idx));

    clear point output time iter loss points_array values_array;

    % ===== Conjugate Gradient Method
    [point, output, time, iter, loss, points_array, values_array] = nonlinear_CG(f_approx, f, f_gradient_cg, x0(idx, :), epsilon, max_iter, ub, lb);
    WriteOutFile(point, output, time, iter, points_array, 'Conjugate Gradient Method', OutputFile1);
    PlotOutFigure(f_plot, ub, lb, loss, points_array, values_array, 'Conjugate Gradient Method', sprintf([OutputFigure '/Question1_Ini%d_CG'], idx));
    PlotOutFigureAll(f_plot, ub, lb, loss, points_array, values_array, 'Conjugate Gradient Method', sprintf([OutputFigure '/Question1_Ini%d_CG'], idx));

    clear point output time iter loss points_array values_array;
end

% ===== Clear Variable
clear x1 x2 x0 f f_plot ub lb epsilon max_iter f_gradient f_hessian f_approx f_gradient_cg;

%% ========== Question 2 ========== %%
% ===== Config
syms x1 x2;

epsilon = 0.0001;
max_iter = 100;

ub = [ 2.0,  2.0];
lb = [-2.0, -2.0];
x0 = [ 0.5, -0.5;
      -1.9, -1.9;
       0.12, 0.12];

f = symfun(-20*exp(-0.2*(((x1.^2+x2.^2)/2).^0.5)) - exp((cos(2*pi*x1)+cos(2*pi*x2))/2) + exp(1) + 20, [x1 x2]);
f_plot = @(x1, x2)(-20*exp(-0.2*(((x1.^2+x2.^2)/2).^0.5)) - exp((cos(2*pi*x1)+cos(2*pi*x2))/2) + exp(1) + 20);
[f_gradient, f_hessian, f_approx, f_gradient_cg] = funcs_2d(f);

OutputFile2 = [OutputFile '/Question2.txt'];
fid = fopen(OutputFile2, 'w');
fprintf(fid, '%%%% ==================== Question 2 ==================== %%%%\r\n');
fclose(fid);

% ===== Optimization
for idx = 1: size(x0, 1)
    % ===== Newton Method
    [point, output, time, iter, loss, points_array, values_array] = newton_method(f, f_gradient, f_hessian, x0(idx, :), epsilon, max_iter, ub, lb);
    WriteOutFile(point, output, time, iter, points_array, 'Newton Method', OutputFile2);
    PlotOutFigure(f_plot, ub, lb, loss, points_array, values_array, 'Newton Method', sprintf([OutputFigure '/Question2_Ini%d_NT'], idx));
    PlotOutFigureAll(f_plot, ub, lb, loss, points_array, values_array, 'Newton Method', sprintf([OutputFigure '/Question2_Ini%d_NT'], idx));

    clear point output time iter loss points_array values_array;

    % ===== Steepest Descent Method
    [point, output, time, iter, loss, points_array, values_array] = gradient_descent(f, f_gradient, x0(idx, :), epsilon, max_iter, ub, lb);
    WriteOutFile(point, output, time, iter, points_array, 'Steepest Descent Method', OutputFile2);
    PlotOutFigure(f_plot, ub, lb, loss, points_array, values_array, 'Steepest Descent Method', sprintf([OutputFigure '/Question2_Ini%d_SD'], idx));
    PlotOutFigureAll(f_plot, ub, lb, loss, points_array, values_array, 'Steepest Descent Method', sprintf([OutputFigure '/Question2_Ini%d_SD'], idx));

    clear point output time iter loss points_array values_array;

    % ===== Conjugate Gradient Method
    [point, output, time, iter, loss, points_array, values_array] = nonlinear_CG(f_approx, f, f_gradient_cg, x0(idx, :), epsilon, max_iter, ub, lb);
    WriteOutFile(point, output, time, iter, points_array, 'Conjugate Gradient Method', OutputFile2);
    PlotOutFigure(f_plot, ub, lb, loss, points_array, values_array, 'Conjugate Gradient Method', sprintf([OutputFigure '/Question2_Ini%d_CG'], idx));
    PlotOutFigureAll(f_plot, ub, lb, loss, points_array, values_array, 'Conjugate Gradient Method', sprintf([OutputFigure '/Question2_Ini%d_CG'], idx));

    clear point output time iter loss points_array values_array;
end

% ===== Clear Variable
clear x1 x2 x0 f f_plot ub lb epsilon max_iter f_gradient f_hessian f_approx f_gradient_cg;

%% ========== Question 3 ========== %%
% ===== Config
syms x1 x2;

epsilon = 0.0001;
max_iter = 100;

ub = [  10,  10];
lb = [ -10, -10];
x0 = [-0.5,  7.5;
      -8.0, -4.5;
       0.3,  0.3];

f = symfun(1 + (x1.^2+x2.^2)/4000 - cos(x1).*cos(x2./sqrt(2)), [x1 x2]);
f_plot = @(x1, x2)(1 + (x1.^2+x2.^2)/4000 - cos(x1).*cos(x2./sqrt(2)));
[f_gradient, f_hessian, f_approx, f_gradient_cg] = funcs_2d(f);

OutputFile3 = [OutputFile '/Question3.txt'];
fid = fopen(OutputFile3, 'w');
fprintf(fid, '%%%% ==================== Question 3 ==================== %%%%\r\n');
fclose(fid);

% ===== Optimization
for idx = 1: size(x0, 1)
    % ===== Newton Method
    [point, output, time, iter, loss, points_array, values_array] = newton_method(f, f_gradient, f_hessian, x0(idx, :), epsilon, max_iter, ub, lb);
    WriteOutFile(point, output, time, iter, points_array, 'Newton Method', OutputFile3);
    PlotOutFigure(f_plot, ub, lb, loss, points_array, values_array, 'Newton Method', sprintf([OutputFigure '/Question3_Ini%d_NT'], idx));
    PlotOutFigureAll(f_plot, ub, lb, loss, points_array, values_array, 'Newton Method', sprintf([OutputFigure '/Question3_Ini%d_NT'], idx));

    clear point output time iter loss points_array values_array;

    % ===== Steepest Descent Method
    [point, output, time, iter, loss, points_array, values_array] = gradient_descent(f, f_gradient, x0(idx, :), epsilon, max_iter, ub, lb);
    WriteOutFile(point, output, time, iter, points_array, 'Steepest Descent Method', OutputFile3);
    PlotOutFigure(f_plot, ub, lb, loss, points_array, values_array, 'Steepest Descent Method', sprintf([OutputFigure '/Question3_Ini%d_SD'], idx));
    PlotOutFigureAll(f_plot, ub, lb, loss, points_array, values_array, 'Steepest Descent Method', sprintf([OutputFigure '/Question3_Ini%d_SD'], idx));

    clear point output time iter loss points_array values_array;

    % ===== Conjugate Gradient Method
    [point, output, time, iter, loss, points_array, values_array] = nonlinear_CG(f_approx, f, f_gradient_cg, x0(idx, :), epsilon, max_iter, ub, lb);
    WriteOutFile(point, output, time, iter, points_array, 'Conjugate Gradient Method', OutputFile3);
    PlotOutFigure(f_plot, ub, lb, loss, points_array, values_array, 'Conjugate Gradient Method', sprintf([OutputFigure '/Question3_Ini%d_CG'], idx));
    PlotOutFigureAll(f_plot, ub, lb, loss, points_array, values_array, 'Conjugate Gradient Method', sprintf([OutputFigure '/Question3_Ini%d_CG'], idx));

    clear point output time iter loss points_array values_array;
end

% ===== Clear Variable
clear x1 x2 x0 f f_plot ub lb epsilon max_iter f_gradient f_hessian f_approx f_gradient_cg;