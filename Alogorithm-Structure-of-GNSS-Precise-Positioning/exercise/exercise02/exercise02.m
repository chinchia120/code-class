%% ========== Setup ========== %%
% ===== Setup
clc; clear; close all;

% ===== Create File
file = fopen('exercise02_output.txt', 'w');
fprintf(file, '%%%% ========== Exercise 2 ========== %%%%\n');

% ===== Initial Value
syms x y;

F1 = [x + y;        % 0
      x - y;        % 0
      3*x;          % 2.5
      10*x + y;     % 13
      x - 2*y];     % -0.5

F2 = [4*y;          % 3.5
      9*x - 2*y];   % 6

F3 = [5*x + 0.5*y;  % 5
      -x - y];      % -2

A1 = [diff(F1(1), x, 1) diff(F1(1), y, 1);
      diff(F1(2), x, 1) diff(F1(2), y, 1);
      diff(F1(3), x, 1) diff(F1(3), y, 1);
      diff(F1(4), x, 1) diff(F1(4), y, 1);
      diff(F1(5), x, 1) diff(F1(5), y, 1)];

A2 = [diff(F2(1), x, 1) diff(F2(1), y, 1);
      diff(F2(2), x, 1) diff(F2(2), y, 1)];

A3 = [diff(F3(1), x, 1) diff(F3(1), y, 1);
      diff(F3(2), x, 1) diff(F3(2), y, 1)];

L1 = [0.0; 0.0; 2.5; 13; -0.5];
L2 = [3.5; 6];
L3 = [5.0; -2];

P1 = diag([1/3.0^2, 1/0.5^2, 1/0.5^2, 1/2^2, 1/1^2]);
P2 = diag([1/0.5^2, 1/1.0^2]);
P3 = diag([1/0.5^2, 1/0.3^2]);

%% ========== Question 1 ========== %%
X1 = vpa((A1'*P1*A1)\A1'*P1*L1);

fprintf(file, '%% ===== Question 1 ===== %%\n');
fprintf(file, 'x = %.10f (m)\n', X1(1));
fprintf(file, 'y = %.10f (m)\n\n', X1(2));

%% ========== Question 2 ========== %%
A = [A1; A2; A3];
L = [L1; L2; L3];
P = diag([1/3.0^2, 1/0.5^2, 1/0.5^2, 1/2^2, 1/1^2, 1/0.5^2, 1/1.0^2, 1/0.5^2, 1/0.3^2]);

X = vpa((A'*P*A)\A'*P*L);
V = L-A*X;
var2 = V'*P*V;

fprintf(file, '%% ===== Question 2 ===== %%\n');
fprintf(file, 'x = %.10f (m)\n', X(1));
fprintf(file, 'y = %.10f (m)\n', X(2));
fprintf(file, 'var = %.10f (m)\n\n', var2);

%% ========== Question 3 ========== %%
N1 = A1'*P1*A1;
N2 = A2'*P2*A2;
N3 = A3'*P3*A3;

X = vpa((N1+N2+N3)\(A1'*P1*L1 + A2'*P2*L2 + A3'*P3*L3));
V = L-A*X;
var3 = V'*P*V;

fprintf(file, '%% ===== Question 3 ===== %%\n');
fprintf(file, 'x = %.10f (m)\n', X(1));
fprintf(file, 'y = %.10f (m)\n', X(2));
fprintf(file, 'var = %.10f (m)\n\n', var3);

fprintf(file, '%% ===== Analysis ===== %%\n');
fprintf(file, ['In the Question 2 and Question 3, they use the same parameters but different way to\n' ...
               'calculate the unknown variables. In theory, they should present the same result in this\n' ...
               'exercise. As the calculating result, they present the same estimates and variances.']);

fclose(file);