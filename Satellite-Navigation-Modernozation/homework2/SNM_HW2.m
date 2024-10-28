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
theta = linspace(0, 2*pi, 200);

%% ========== (a) ========== %%
fprintf(file, '%%%% ========== Homework2 - (a) ========== %%%%\n');

F1_a = sqrt((x-loc_A(1))^2 + (y-loc_A(2))^2);
F2_a = sqrt((x-loc_B(1))^2 + (y-loc_B(2))^2);

A = Setup_A([F1_a; F2_a], [x; y]);
L = [rho_A; rho_B];
X = [F1_a; F2_a];
W = L - X;
Srr = diag([std_rho^2 std_rho^2]);

% ===== Initial 1
init1 = [loc_A(1)+1; loc_A(2)];   % m
fprintf(file, '%% ===== Initial Value 1 ===== %%\n');
fprintf(file, 'x = %.1f\n', init1(1));
fprintf(file, 'y = %.1f\n\n',init1(2)); 
[x_hat, y_hat] = LSE(A, W, [x y], init1, file);
Sx = double(subs(A*Srr*A', [x y], [x_hat y_hat]));
[eigVec, eigVal] = eig(Sx);
error_ellipse_theta = atand(eigVec(1, 1)/eigVec(1, 2));

majoraxis = sqrt(eigVal(1, 1));
minoraxis = sqrt(eigVal(2, 2));
transformMatrix = [cosd(error_ellipse_theta), sind(error_ellipse_theta); -sind(error_ellipse_theta), cosd(error_ellipse_theta)];
xyRotated = [majoraxis*sin(theta); minoraxis*cos(theta)]'*transformMatrix;

% ===== Central Sol1
plot(x_hat, y_hat, 'o', Color='blue');
text(x_hat+1, y_hat+0.25, sprintf('[%.4f, %.4f]', x_hat, y_hat), 'fontweight', 'bold');
hold on;

% ===== x-axis
x_axis = zeros(1, 200);
y_axis = linspace(-minoraxis*1.2, minoraxis*1.2, 200);
xRotated = [x_axis; y_axis]'*transformMatrix;
plot(xRotated(:, 1)+x_hat, xRotated(:, 2)+y_hat, 'red');
hold on;

% ===== y-axis
x_axis = linspace(-majoraxis*1.5, majoraxis*1.5, 200);
y_axis = zeros(1, 200);
yRotated = [x_axis; y_axis]'*transformMatrix;
plot(yRotated(:, 1)+x_hat, yRotated(:, 2)+y_hat, 'red');
hold on;

% ===== Error Ellipse
plot(xyRotated(:, 1)+x_hat, xyRotated(:, 2)+y_hat, 'Blue');
title('Error Ellipse');
xlabel("x (m)");
ylabel("y (m)");
legend('Sol 1', 'x-axis', 'y-axis','Error Ellipse of Sol 1');
axis('equal');
hold off;

saveas(gcf, 'error_ellipse_a.fig');
saveas(gcf, 'error_ellipse_a.png');

% ===== Initial 2
init2 = [loc_A(1)-1; loc_A(2)];   % m
fprintf(file, '%% ===== Initial Value 2 ===== %%\n');
fprintf(file, 'x = %.1f\n', init2(1));
fprintf(file, 'y = %.1f\n\n',init2(2)); 
LSE(A, W, [x y], init2, file);

% ===== Central A
plot(loc_A(1), loc_A(2), 'o', Color='blue');
text(loc_A(1)+1, loc_A(2)+0.25, sprintf('[%.1f, %.1f]', loc_A(1), loc_A(2)), 'fontweight', 'bold');
hold on;

% ===== Central B
plot(loc_B(1), loc_B(2), 'o', Color='red');
text(loc_B(1)+1, loc_B(2)+0.25, sprintf('[%.1f, %.1f]', loc_B(1), loc_B(2)), 'fontweight', 'bold');
hold on;

% ===== Circle A
x1 = rho_A*cos(theta) + loc_A(1);
y1 = rho_A*sin(theta) + loc_A(2);
plot(x1, y1, 'blue');
hold on;

% ===== Circle B
x2 = rho_B*cos(theta) + loc_B(1);
y2 = rho_B*sin(theta) + loc_B(2);
plot(x2, y2, 'red');
hold on;

% ===== Intersection
[xout, yout] = circcirc(loc_A(1), loc_A(2), rho_A, loc_B(1), loc_B(2), rho_B);
text(xout(1)+1, yout(1)+0.25, sprintf('[%.4f, %.4f]', xout(1), yout(1)), 'fontweight', 'bold');
text(xout(2)+1, yout(2)+0.25, sprintf('[%.4f, %.4f]', xout(2), yout(2)), 'fontweight', 'bold');
plot(xout, yout, '*', Color='black');
hold off;

% ===== Plot Config
title('Geometry');
xlabel("x (m)");
ylabel("y (m)");
legend('Beacon A', 'Beacon B', 'Range A', 'Range B', 'Solution');
axis('equal');

% ===== Save Plot
saveas(gcf, 'geometry_a.fig');
saveas(gcf, 'geometry_a.png');


% it = 1;
% while 1
%     if it == 1
%         x_ = init_x;
%         y_ = init_y;
%     end
% 
%     d = vpa(subs((A'*A)\A'*W, [x y], [x_ y_]));
%     x_ = x_ + d(1);
%     y_ = y_ + d(2);
% 
%     fprintf(file, '%% ===== iteration %02d ===== %%\n', it);
%     fprintf(file, 'x = %.10f\n', x_);
%     fprintf(file, 'y = %.10f\n\n', y_);
%     it = it + 1;
% 
%     if abs(d(1)) < 10^-6 && abs(d(2)) < 10^-6; break; end
% end

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