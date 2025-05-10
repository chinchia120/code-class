%% 
clc;
clear;
close all;

% 設定最大迭代次數 when reach to end of loop, evoke error
max_iter = 100;

% for terminating condition
epsilon = 0.0001;

% 設定 Question 1 的初始點 initial point for f 
point_q1_x01 = [0.5 -0.5];


% 設定 Question 1 的函式 set function
syms x1 x2;

% 範例 2d Question 1
f_1 = symfun(-20*exp(-0.2*(((x1.^2+x2.^2)/2).^0.5)) - exp((cos(2*pi*x1)+cos(2*pi*x2))/2) + exp(1) + 20, [x1 x2]);
f_1_plot = @(x1, x2)(-20*exp(-0.2*(((x1.^2+x2.^2)/2).^0.5)) - exp((cos(2*pi*x1)+cos(2*pi*x2))/2) + exp(1) + 20);

% 設定 Question 1 的輸入限制 set question 1 constraint
q1_x1_range = 2;
q1_x2_range = 2;

q1_ub = [q1_x1_range, q1_x2_range];
q1_lb = -q1_ub;

option=optimset('Display','off');
%% 
% Question 1

fprintf('=============== Question 1 inital_1 ================\n');
[f_gradient,f_hessian,f_approx,f_gradient_cg] = funcs_2d(f_1);
Output_2d(f_1, f_gradient, f_hessian, f_approx, f_gradient_cg, point_q1_x01, epsilon, max_iter, q1_ub, q1_lb, f_1_plot);
tic;




