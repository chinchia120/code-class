function [] = scatter_plot(x, y, outName)
%% ========== Initial Value ========== %%
figure;

%% ========== Scatter Plot ========== %%
scatter(x, y, '.');

%% ========== Scatter Config ========== %%
title('Estimation of x in Each Epoch');
xlim([x(1) x(end)]);
xlabel('Epoch');
ylabel('Estimated Value');
legend('Estimated Data');
grid minor;

%% ========== Save Figure ========== %%
saveas(gcf, [outName '.png']);

end