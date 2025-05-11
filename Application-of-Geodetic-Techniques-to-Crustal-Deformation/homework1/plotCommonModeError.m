function [] = plotCommonModeError(staE, staN, staU, OutName)
%% ========== Setup ========= %%

%% ========== Read Data ========== %%
dataE = readmatrix(staE, 'FileType', 'text');
dataN = readmatrix(staN, 'FileType', 'text');
dataU = readmatrix(staU, 'FileType', 'text');

%% ========== Plot Figure ========== %%
% ===== E Direction
subplot(3, 1, 1);

scatter(dataE(:, 1), dataE(:, 2), 4);
ylabel('E (mm)');
grid minor;

% ===== N Direction
subplot(3, 1, 2);

scatter(dataN(:, 1), dataN(:, 2), 4);
ylabel('N (mm)');
grid minor;

% ===== U Direction
subplot(3, 1, 3);

scatter(dataU(:, 1), dataU(:, 2), 4);
ylabel('U (mm)');
grid minor;

% ===== Plot Config
sgtitle('Common Mode Error');
main = axes('visible', 'off');
main.XLabel.Visible='on';
xlabel(main, 'Years');

%% ========== save Figure ========== %%
saveas(gcf, OutName, 'png');

end

