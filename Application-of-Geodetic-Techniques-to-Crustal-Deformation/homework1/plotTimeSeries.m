function [] = plotTimeSeries(staE, staN, staU, station, OutName)
%% ========== Setup ========= %%
clf;

%% ========== Read Data ========== %%
dataE = readmatrix(staE, 'FileType', 'text');
dataN = readmatrix(staN, 'FileType', 'text');
dataU = readmatrix(staU, 'FileType', 'text');

%% ========== Plot Figure ========== %%
% ===== E Direction
subplot(3, 1, 1);

plot(dataE(:, 1), dataE(:, 2));
ylabel('E (mm)');
grid minor;

% ===== N Direction
subplot(3, 1, 2);

plot(dataN(:, 1), dataN(:, 2));
ylabel('N (mm)');
grid minor;

% ===== U Direction
subplot(3, 1, 3);

plot(dataU(:, 1), dataU(:, 2));
ylabel('U (mm)');
grid minor;

% ===== Plot Config
sgtitle(sprintf('Time Series of %s', station));
main = axes('visible', 'off');
main.XLabel.Visible='on';
xlabel(main, 'Years');

%% ========== save Figure ========== %%
saveas(gcf, OutName, 'png');

end

