%% ========== Setup ========== %%
% ===== Setup
clc; clear; close all;

% ===== Create file
file = fopen('SNM_HW2_output.txt', 'w');

% ===== Initial Value
loc_A = [8.6; -1.5];    % m
loc_B = [7.6; 14.9];    % m

theta_A = 187;          % deg
theta_B = 226;          % deg
std_theta = 0.1;        % deg

rho_A = 13.9;           % m
rho_B = 24.7;           % m
std_rho = 0.01;         % m

syms x y;

%% ========== (a) ========== %%
fprintf(file, '%%%% ========== Homework2 - (a) ========== %%%%\n');

F1_a = sqrt((x-loc_A(1))^2 + (y-loc_A(2))^2);
F2_a = sqrt((x-loc_B(1))^2 + (y-loc_B(2))^2);

A = Setup_A([F1_a; F2_a], [x; y]);
L = [rho_A; rho_B];
X = [F1_a; F2_a];
W = L - X;
Srr = diag([std_rho^2 std_rho^2]);

% ===== Geometry
Geometry_rr(loc_A, loc_B, rho_A, rho_B, 'geometry_a');

% ===== Initial 1
init1 = [loc_A(1)+1; loc_A(2)];   % m
fprintf(file, '%% ===== Initial Value 1 ===== %%\n');
fprintf(file, 'x = %.1f\n', init1(1));
fprintf(file, 'y = %.1f\n\n',init1(2)); 
[x_hat, y_hat] = LSE(A, W, [x y], init1, file);

[majoraxis, minoraxis, error_ellipse_theta] = Error_Ellipse_Params([x y], A, x_hat, y_hat, Srr);
Error_Ellipse_Plot(majoraxis, minoraxis, [x_hat y_hat], error_ellipse_theta(1), 'error_ellipse_a_1_1');
Error_Ellipse_Plot(majoraxis, minoraxis, [x_hat y_hat], error_ellipse_theta(2), 'error_ellipse_a_1_2');

% ===== Initial 2
init2 = [loc_A(1)-1; loc_A(2)];   % m
fprintf(file, '%% ===== Initial Value 2 ===== %%\n');
fprintf(file, 'x = %.1f\n', init2(1));
fprintf(file, 'y = %.1f\n\n',init2(2)); 
[x_hat, y_hat] = LSE(A, W, [x y], init1, file);

[majoraxis, minoraxis, error_ellipse_theta] = Error_Ellipse_Params([x y], A, x_hat, y_hat, Srr);
Error_Ellipse_Plot(majoraxis, minoraxis, [x_hat y_hat], error_ellipse_theta(1), 'error_ellipse_a_2_1');
Error_Ellipse_Plot(majoraxis, minoraxis, [x_hat y_hat], error_ellipse_theta(2), 'error_ellipse_a_2_2');

%% ========== (b) ========== %%
fprintf(file, '%%%% ========== Homework2 - (b) ========== %%%%\n');

F1_b = atan((y-loc_A(2)) / (x-loc_A(1)));
F2_b = atan((y-loc_B(2)) / (x-loc_B(1)));

A = Setup_A([F1_b; F2_b], [x; y]);

L = [rho_A; rho_B];

X = [theta_A; theta_B];

W = L - X;

% LSE(A, W, [x y], init, file);

% ===== Close file
fclose(file);