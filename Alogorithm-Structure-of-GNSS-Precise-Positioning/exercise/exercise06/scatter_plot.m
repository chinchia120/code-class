function [] = scatter_plot(x, y, outName)

% ===== Scatter Plot
scatter(x, y, 'filled');

% ===== Scatter Config
title('estimation of x in each epoch');
xlabel("epoch");
ylabel("estimated value");
grid on;

% ===== Save Figure
saveas(gcf, [outName '.fig']);
saveas(gcf, [outName '.png']);

end

