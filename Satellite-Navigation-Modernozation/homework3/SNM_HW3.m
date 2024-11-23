%% ========== Setup ========== %%
% ===== Setup
clc; clear; close all;

% ===== Creat Output Folder
OutputFolder = sprintf('OutputFigure');
if ~exist(OutputFolder, 'dir'); mkdir(OutputFolder); end

% ===== Create Output File
file = fopen([OutputFolder '/SNM_HW2_output.txt'], 'w');

% ===== Initial Value
syms x y;

loc_A = [8.6; -1.5];    % m
loc_B = [7.6; 14.9];    % m

theta_A = 187;          % deg
theta_B = 226;          % deg
std_theta = 0.1;        % deg

rho_A = 13.9;           % m
rho_B = 24.7;           % m
std_rho = 0.01;         % m

sigma0 = 1;

%% ========== (a) ========== %%
fprintf(file, '%%%% ========== Homework2 - (a) ========== %%%%\n');

F1_a = sqrt((x-loc_A(1))^2 + (y-loc_A(2))^2);
F2_a = sqrt((x-loc_B(1))^2 + (y-loc_B(2))^2);

% ===== LSE Param
A = jacobian([F1_a; F2_a],[x; y]);
L = [rho_A; rho_B];
X = [F1_a; F2_a];
W = L - X;
P = diag([std_rho^-2 std_rho^-2]);

% ===== Initial 1
init1 = [loc_A(1)+1; loc_A(2)];   % m
fprintf(file, '%% ===== Initial Value 1 ===== %%\n');
fprintf(file, 'x = %.1f\n', init1(1));
fprintf(file, 'y = %.1f\n\n',init1(2)); 
[x_hat, y_hat] = LSE_rr(A, W, [x y], init1, file);

[majoraxis, minoraxis, theta] = Error_Ellipse_Params([x y], A, P, sigma0, x_hat, y_hat);
Error_Ellipse_Plot(majoraxis, minoraxis, [x_hat y_hat], theta, [OutputFolder '/error_ellipse_a_1']);

% ===== Initial 2
init2 = [loc_A(1)-1; loc_A(2)];   % m
fprintf(file, '%% ===== Initial Value 2 ===== %%\n');
fprintf(file, 'x = %.1f\n', init2(1));
fprintf(file, 'y = %.1f\n\n',init2(2)); 
[x_hat, y_hat] = LSE_rr(A, W, [x y], init2, file);

[majoraxis, minoraxis, theta] = Error_Ellipse_Params([x y], A, P, sigma0, x_hat, y_hat);
Error_Ellipse_Plot(majoraxis, minoraxis, [x_hat y_hat], theta, [OutputFolder '/error_ellipse_a_2']);

% ===== Geometry
Geometry_rr(loc_A, loc_B, rho_A, rho_B, [OutputFolder '/geometry_a']);

%% ========== (b) ========== %%
fprintf(file, '%%%% ========== Homework2 - (b) ========== %%%%\n');

F1_b = atan2((y-loc_A(2)), (x-loc_A(1)));
F2_b = atan2((y-loc_B(2)), (x-loc_B(1)));

% ===== LSE Param
A = jacobian([F1_b; F2_b],[x; y]);
L = [deg2rad(theta_A); deg2rad(theta_B)];
X = [F1_b; F2_b];
P = diag([deg2rad(std_theta)^-2 deg2rad(std_theta)^-2]);

% ===== Initial
init = [0; 0];
fprintf(file, '%% ===== Initial Value ===== %%\n');
fprintf(file, 'x = %.1f\n', init(1));
fprintf(file, 'y = %.1f\n\n',init(2));
[x_hat, y_hat] = LSE_aa(A, X, L, [x y], init, file);

[majoraxis, minoraxis, theta] = Error_Ellipse_Params([x y], A, P, sigma0, x_hat, y_hat);
Error_Ellipse_Plot(majoraxis, minoraxis, [x_hat y_hat], theta, [OutputFolder '/error_ellipse_b']);

% ===== Geometry
Geometry_aa(loc_A, loc_B, theta_A, theta_B, [x_hat, y_hat], [OutputFolder '/geometry_b']);

%% ========== (c) ========== %%
fprintf(file, '%%%% ========== Homework2 - (c) ========== %%%%\n');

F1_c = sqrt((x-loc_A(1))^2 + (y-loc_A(2))^2);
F2_c = atan2((y-loc_A(2)), (x-loc_A(1)));

% ===== LSE Param
A = jacobian([F1_c; F2_c],[x; y]);
L = [rho_A; deg2rad(theta_A)];
X = [F1_c; F2_c];
P = diag([std_rho^-2 deg2rad(std_theta)^-2]);

% ===== Initial
init = [0; 0];
fprintf(file, '%% ===== Initial Value ===== %%\n');
fprintf(file, 'x = %.1f\n', init(1));
fprintf(file, 'y = %.1f\n\n',init(2));
[x_hat, y_hat] = LSE_ra(A, X, L, [x y], init, file);

[majoraxis, minoraxis, theta] = Error_Ellipse_Params([x y], A, P, sigma0, x_hat, y_hat);
Error_Ellipse_Plot(majoraxis, minoraxis, [x_hat y_hat], theta, [OutputFolder '/error_ellipse_c']);

% ===== Geometry
Geometry_ra(loc_A, rho_A, theta_A, [x_hat, y_hat], [OutputFolder '/geometry_c']);

%% ========== (d) ========== %%
fprintf(file, '%%%% ========== Homework2 - (d) ========== %%%%\n');

F1_d = sqrt((x-loc_B(1))^2 + (y-loc_B(2))^2);
F2_d = atan2((y-loc_B(2)), (x-loc_B(1)));

% ===== LSE Param
A = jacobian([F1_d; F2_d],[x; y]);
L = [rho_B; deg2rad(theta_B)];
X = [F1_d; F2_d];
P = diag([std_rho^-2 deg2rad(std_theta)^-2]);

% ===== Initial
init = [0; 0];
fprintf(file, '%% ===== Initial Value ===== %%\n');
fprintf(file, 'x = %.1f\n', init(1));
fprintf(file, 'y = %.1f\n\n',init(2));
[x_hat, y_hat] = LSE_ra(A, X, L, [x y], init, file);

[majoraxis, minoraxis, theta] = Error_Ellipse_Params([x y], A, P, sigma0, x_hat, y_hat);
Error_Ellipse_Plot(majoraxis, minoraxis, [x_hat y_hat], theta, [OutputFolder '/error_ellipse_d']);

% ===== Geometry
Geometry_ra(loc_B, rho_B, theta_B, [x_hat, y_hat], [OutputFolder '/geometry_d']);

%% ========== (e) ========== %%
fprintf(file, '%%%% ========== Homework2 - (e) ========== %%%%\n');

F1_e = sqrt((x-loc_A(1))^2 + (y-loc_A(2))^2);
F2_e = sqrt((x-loc_B(1))^2 + (y-loc_B(2))^2);
F3_e = atan2((y-loc_A(2)), (x-loc_A(1)));
F4_e = atan2((y-loc_B(2)), (x-loc_B(1)));

% ===== LSE Param
A = jacobian([F1_e; F2_e; F3_e; F4_e],[x; y]);
L = [rho_A; rho_B; deg2rad(theta_A); deg2rad(theta_B)];
X = [F1_e; F2_e; F3_e; F4_e];
P = diag([std_rho^-2 std_rho^-2 deg2rad(std_theta)^-2 deg2rad(std_theta)^-2]);

% ===== Initial
init = [0; 0];
fprintf(file, '%% ===== Initial Value ===== %%\n');
fprintf(file, 'x = %.1f\n', init(1));
fprintf(file, 'y = %.1f\n\n',init(2));
[x_hat, y_hat, std] = LSE_rraa(A, X, L, P, [x y], init, file);

[majoraxis, minoraxis, theta] = Error_Ellipse_Params([x y], A, P, sigma0, x_hat, y_hat);
Error_Ellipse_Plot(majoraxis, minoraxis, [x_hat y_hat], theta, [OutputFolder '/error_ellipse_e_1']);

[majoraxis, minoraxis, theta] = Error_Ellipse_Params([x y], A, P, std, x_hat, y_hat);
Error_Ellipse_Plot(majoraxis, minoraxis, [x_hat y_hat], theta, [OutputFolder '/error_ellipse_e_2']);

% ===== Geometry
Geometry_rraa(loc_A, loc_B, rho_A, rho_B, theta_A, theta_B, [x_hat y_hat], [OutputFolder '/geometry_e']);

%% ===== Close file
fclose(file);