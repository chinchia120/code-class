%% ========== Setup ========== %%
% ===== Setup
clc; clear; close all;

% ===== Create file
file = fopen('SNM_HW2_output.txt', 'w');

% ===== Initial Value
loc_A = [8.6; -1.5]; % m
loc_B = [7.6; 14.9]; % m

theta_A = 187;      % deg
theta_B = 226;      % deg
rho_A = 13.9;       % m
rho_B = 24.7;       % m

%% ========== (a) ========== %%
fprintf(file, '%%%% ========== Homework2 - (a) ========== %%%%\n');
syms x y dx dy;
F1_a = sqrt((x-loc_A(1))^2 + (y-loc_A(2))^2);
F2_a = sqrt((x-loc_B(1))^2 + (y-loc_B(2))^2);

A_a = [diff(F1_a, x, 1) diff(F1_a, y, 1);
       diff(F1_a, x, 1) diff(F2_a, y, 1)];

L_a = [rho_A; rho_B];

X_a = [F1_a; F2_a];

W_a = L_a - X_a;

it = 1;
while 1
    if it == 1
        x_ = 0;
        y_ = 0;
    end

    d = vpa(subs((A_a'*A_a)\A_a'*W_a, [x y], [x_ y_]));
    x_ = x_ + d(1);
    y_ = y_ + d(2);

    fprintf(file, '%% ===== iteration %02d ===== %%\n', it);
    fprintf(file, 'x = %.10f\n', x_);
    fprintf(file, 'y = %.10f\n\n', y_);
    it = it + 1;

    if abs(d(1)) < 10^-6 && abs(d(2)) < 10^-6; break; end
end


% ===== Close file
fclose(file);