function [] = AnalysisTime(Data, outName)
%% ========== Setup ========== %%
clf;

%% ========== E Direction ========== %%
subplot(4, 1, 1);
plot(Data(:, 1), Data(:, 2), 'b');

% ===== Figure Config
ylabel('E (m)');
grid on;

%% ========== N Direction ========== %%
subplot(4, 1, 2);
plot(Data(:, 1), Data(:, 3), 'b');

% ===== Figure Config
ylabel('N (m)');
grid on;

%% ========== U Direction ========== %%
subplot(4, 1, 3);
plot(Data(:, 1), Data(:, 4), 'b');

% ===== Figure Config
ylabel('U (m)');
grid on;

%% ========== Clock Bias ========== %%
subplot(4, 1, 4);
plot(Data(:, 1), Data(:, 5), 'b');

% ===== Figure Config
ylabel('Clock Bias (s)');
grid on;

%% ========== Main Figure Config ========== %%
sgtitle('Multiple Epoch');
main = axes('visible', 'off');
main.XLabel.Visible='on';
xlabel(main,'Time (s)');

%% ========== Save Figure ========== %%
saveas(gcf, [outName '.png']);

end