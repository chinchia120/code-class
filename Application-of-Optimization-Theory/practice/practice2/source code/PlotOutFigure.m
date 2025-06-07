function PlotOutFigure(f_plot, ub, lb, loss, points_array, values_array, method, outname)
%% ========== Convergence Curve ========== %%
% ===== Setup
figure;

% ===== Plot Convergence
x = linspace(0, length(values_array)-1, length(values_array));
plot(x, values_array);

% ===== Plot Config
grid minor;
title([method ' Convergence Curve']);
xlabel('Iteration');
ylabel('Value');
xlim([x(1) x(end)]);

% ===== Save Plot
saveas(gcf, [outname '_Convergence.png']);

%% ========== Gradient Curve ========== %%
% ===== Setup
figure;

% ===== Plot Gradient
x = linspace(0, length(loss)-1, length(loss));
plot(x, loss);

% ===== Plot Config
grid minor;
title([method ' Gradient Curve']);
xlabel('Iteration');
ylabel('Difference');
xlim([x(1) x(end)]);

% ===== Save Plot
saveas(gcf, [outname '_Gradient.png']);

%% ========== Level Set and Path ========== %%
% ===== Setup
figure;

% ===== Plot Level Set
x = linspace(ub(1), lb(1), 100);
y = linspace(ub(2), lb(2), 100);

[xx, yy] = meshgrid(x, y);
xy = f_plot(xx, yy);
contour(xx, yy, xy);

hold on;

% ===== Plot Path
plot(points_array(:, 1), points_array(:, 2), '-o', 'Color', 'r');

hold off;

% ===== Plot Config
title([method ' Level Set Path']);
xlabel('x1');
ylabel('x2');

% ===== Save Plot
saveas(gcf, [outname '_LevelSet.png']);

%% ========== Surface and Path ========== %%
% ===== Setup
figure;

% ===== Plot Level Set
x = linspace(ub(1), lb(1), 100);
y = linspace(ub(2), lb(2), 100);

[xx, yy] = meshgrid(x, y);
xy = f_plot(xx, yy);
surf(xx, yy, xy);

hold on;

% ===== Plot Path
plot3(points_array(:, 1), points_array(:, 2), values_array, '-o', 'Color', 'r');

hold off;

% ===== Plot Config
title([method ' Surface Path']);
xlabel('x1');
ylabel('x2');
zlabel('f(x1, x2)')

% ===== Save Plot
saveas(gcf, [outname '_Surface.png']);
end