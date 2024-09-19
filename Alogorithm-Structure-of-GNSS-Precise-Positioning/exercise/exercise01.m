%% ========== Setup ========== %%
% Setup
clc;
clear;
close all;

% Create file
file = fopen('exercise01_output.txt', 'w');

%% ========== Initial Value ========== %%
syms x y dx dy;

F1 =  x*x + y;      %  1
F2 =    x - y*y;    % -0.4
F3 = 10*x + y;      %  0.1
F4 =    x - 2*y;    % -0.05

f1 = 2*x*dx + 1*dy;
f2 =   1*dx - 2*y*dy;
f3 =  10*dx + 1*dy;
f4 =   1*dx - 2*dy;

A = [diff(f1, dx, 1), diff(f1, dy, 1);
     diff(f2, dx, 1), diff(f2, dy, 1);
     diff(f3, dx, 1), diff(f3, dy, 1);
     diff(f4, dx, 1), diff(f4, dy, 1)];

L = [1; -0.4; 0.1; -0.05];

X = [F1; F2; F3; F4];

W = L - X;

P = diag([1/3/3, 1/0.5/0.5, 1/0.1/0.1, 1/0.05/0.05]);

%% ========== Iteration ========== %%
it = 1;
while 1
    if it == 1
        x_ = 0;
        y_ = 0;
    end
    
    d = vpa(subs((A'*P*A)\A'*P*W, [x y], [x_, y_]));
    x_ = x_ + d(1);
    y_ = y_ + d(2);

    fprintf(file, '%%%% ========== iteration%2d ========== %%%%\n', it);
    fprintf(file, 'x = %.10f\n', x_);
    fprintf(file, 'y = %.10f\n\n', y_);
    it = it + 1;
    
    if d(1) < 10^-10 && d(2) < 10^-10; break; end
end

fclose(file);