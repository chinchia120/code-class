function [] = AnalysisXYZ(expData, trueData, outName)
%% ========== Setup ========== %%
clf;

%% ========== Horizontal Figure ========== %%
subplot(2, 1, 1);

% ===== Experiment Position
scatter(expData(:, 2), expData(:, 3), 'b', '.');
hold on;

% ===== True Position
scatter(trueData(1), trueData(2), 'r', '*');
hold off;

% ===== Figure Config
title('Horizontal');
xlabel('X (m)');
ylabel('Y (m)');
legend('Experiment Data', 'Ground Truth');
grid on;

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
ylabel('Z (m)');
legend('Experiment Data', 'Ground Truth');
grid on;

%% ========== Save Figure ========== %%
saveas(gcf, [outName '.png']);
end

