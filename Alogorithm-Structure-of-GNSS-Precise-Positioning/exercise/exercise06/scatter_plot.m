function [] = scatter_plot(x, y)
scatter(x, y, 'filled');
title('estimation of x in each epoch');
xlabel("epoch");
ylabel("estimated value");
grid on;

end

