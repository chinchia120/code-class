function [] = AnalysisLLA(expData, trueData, outName)
%% ========== Setup ========== %%
clf;

%% ========== Horizontal Figure ========== %%
subplot(2, 1, 1);

% ===== Experiment Position
geoscatter(expData(:, 2), expData(:, 3), Marker='.', Color='b');
hold on;

% ===== True Position
geoplot(trueData(1), trueData(2), Marker='*', Color='r');
hold off;

% ===== Figure Config
geobasemap topographic;
title('Horizontal');
legend('Experiment Data', 'Ground Truth');

%% ========== Altitude Figure ========== %%
subplot(2, 1, 2);

% ===== Experiment Position
plot(expData(:, 1), expData(:, 4), 'b');
hold on;

% ===== True Position
plot(expData(:, 1), ones(size(expData, 1))*trueData(3), 'r');
hold off;

% ===== Figure Config
title('Altitude');
xlabel('Time (s)');
ylabel('Alt (m)');
legend('Experiment Data', 'Ground Truth');
grid on;

%% ========== Save Figure ========== %%
saveas(gcf, [outName '.fig']);
saveas(gcf, [outName '.png']);

end