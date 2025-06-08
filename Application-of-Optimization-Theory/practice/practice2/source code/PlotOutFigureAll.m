function PlotOutFigureAll(f_plot, ub, lb, loss, points_array, values_array, method, outname)
%% ========== Setup ========== %%
% ===== Setup
figure;

%% ========== Convergence Curve ========== %%
% ===== Setup
subplot(2, 2, 1);

% ===== Plot Convergence Curve
x = linspace(0, length(values_array)-1, length(values_array));
plot(x, values_array, 'LineWidth', 2);

% ===== Plot Config
grid minor;
title('Convergence Curve');
xlabel('Iteration');
ylabel('Value');
xlim([x(1) x(end)]);

%% ========== Gradient Curve ========== %%
% ===== Setup
subplot(2, 2, 2);

% ===== Plot Gradient Curve
x = linspace(1, length(loss), length(loss));
plot(x, loss, 'LineWidth', 2);

% ===== Plot Config
grid minor;
title('Gradient Curve');
xlabel('Iteration');
ylabel('Difference');
xlim([x(1) x(end)]);

%% ========== Level Set and Path ========== %%
% ===== Setup
subplot(2, 2, 3);

% ===== Plot Level Set
x = linspace(ub(1), lb(1), 100);
y = linspace(ub(2), lb(2), 100);
[xx, yy] = meshgrid(x, y);
xy = f_plot(xx, yy);
contour(xx, yy, xy, 'LineWidth', 1.5);
hold on;

% ===== Plot Path
plot(points_array(:, 1), points_array(:, 2), '-o', 'Color', 'r', 'LineWidth', 2);
hold off;

% ===== Plot Config
title('Level Set with Path');
xlabel('x1');
ylabel('x2');

%% ========== Surface and Path ========== %%
% ===== Setup
subplot(2, 2, 4);

% ===== Plot Surface
x = linspace(ub(1), lb(1), 100);
y = linspace(ub(2), lb(2), 100);
[xx, yy] = meshgrid(x, y);
xy = f_plot(xx, yy);
surf(xx, yy, xy);
hold on;

% ===== Plot Path
plot3(points_array(:, 1), points_array(:, 2), values_array, '-o', 'Color', 'r', 'LineWidth', 2);
hold off;

% ===== Plot Config
title('Surface with Path');
xlabel('x1');
ylabel('x2');
zlabel('f(x1, x2)')

% ===== Adjust layout and save
sgtitle(sprintf('%s [%.4f, %.4f]', method, points_array(1, :)), 'FontSize', 14, 'FontWeight', 'bold');
set(gcf, 'Color', 'white');
saveas(gcf, [outname '_All.png']);

end