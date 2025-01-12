%% ========== Setup ========== %%
% ===== Setup
clc; clear; close all;

% ===== Creat Output Folder
OutputFolder = sprintf('OutputFigure');
if ~exist(OutputFolder, 'dir'); mkdir(OutputFolder); end

% ===== Initial Value
UTCTime = struct2array(load('GPSTime.mat'));
CKSV_Bro = struct2array(load('CKSV_broadcast_20230101.mat'));
CKSV_Fin = struct2array(load('CKSV_final_20230101.mat'));
PRN = 8;

%% ========== Convert Time ========== %%
TimeEpoch = UTCTime(:, 4)*3600 + UTCTime(:, 5)*60 + UTCTime(:, 6);

%% ========== Broadcast Ephemeris ========== %%
PRN_pos_ECEF_bro = [CKSV_Bro(PRN, 1, :) CKSV_Bro(PRN, 2, :) CKSV_Bro(PRN, 3, :)];
PRN_pos_ECEF_bro = [TimeEpoch reshape(PRN_pos_ECEF_bro, [size(PRN_pos_ECEF_bro, 2), size(PRN_pos_ECEF_bro, 3)])'];

%% ========== Precise Ephemeris ========== %%
PRN_pos_ECEF_pre = [CKSV_Fin(PRN, 1, :) CKSV_Fin(PRN, 2, :) CKSV_Fin(PRN, 3, :)];
PRN_pos_ECEF_pre = [TimeEpoch reshape(PRN_pos_ECEF_pre, [size(PRN_pos_ECEF_pre, 2), size(PRN_pos_ECEF_pre, 3)])'];

%% ========== ECEF - X Direction ========== %%
% ===== Config
figure;

% ===== Broadcast Ephemeris
subplot(2, 1, 1);

plot(PRN_pos_ECEF_bro(:, 1), PRN_pos_ECEF_bro(:, 2), 'Color', 'b');

ylabel('X (m)');
xlim([PRN_pos_ECEF_bro(1, 1) PRN_pos_ECEF_bro(end, 1)]);
legend('Broadcast Ephemeris');
grid minor;

% ===== Precise Ephemeris
subplot(2, 1, 2);

plot(PRN_pos_ECEF_pre(:, 1), PRN_pos_ECEF_pre(:, 2), 'Color', 'r');

ylabel('X (m)');
xlim([PRN_pos_ECEF_pre(1, 1) PRN_pos_ECEF_pre(end, 1)]);
legend('Precise Ephemeris');
grid minor;

% ===== Main Config
sgtitle(sprintf('PRN %d ECEF X Direction', PRN));
main = axes('visible', 'off');
main.XLabel.Visible='on';
xlabel(main,'Time Epoch (s)');

% ===== Save Figure
saveas(gcf, [OutputFolder sprintf('/PRN%d_ECEF_X.png', PRN)]);

%% ========== ECEF - Y Direction ========== %%
% ===== Config
figure;

% ===== Broadcast Ephemeris
subplot(2, 1, 1);

plot(PRN_pos_ECEF_bro(:, 1), PRN_pos_ECEF_bro(:, 3), 'Color', 'b');

ylabel('Y (m)');
xlim([PRN_pos_ECEF_bro(1, 1) PRN_pos_ECEF_bro(end, 1)]);
legend('Broadcast Ephemeris');
grid minor;

% ===== Precise Ephemeris
subplot(2, 1, 2);

plot(PRN_pos_ECEF_pre(:, 1), PRN_pos_ECEF_pre(:, 3), 'Color', 'r');

ylabel('Y (m)');
xlim([PRN_pos_ECEF_pre(1, 1) PRN_pos_ECEF_pre(end, 1)]);
legend('Precise Ephemeris');
grid minor;

% ===== Main Config
sgtitle(sprintf('PRN %d ECEF Y Direction', PRN));
main = axes('visible', 'off');
main.XLabel.Visible='on';
xlabel(main,'Time Epoch (s)');

% ===== Save Figure
saveas(gcf, [OutputFolder sprintf('/PRN%d_ECEF_Y.png', PRN)]);

%% ========== ECEF - Z Direction ========== %%
% ===== Config
figure;

% ===== Broadcast Ephemeris
subplot(2, 1, 1);

plot(PRN_pos_ECEF_bro(:, 1), PRN_pos_ECEF_bro(:, 4), 'Color', 'b');

ylabel('Z (m)');
xlim([PRN_pos_ECEF_bro(1, 1) PRN_pos_ECEF_bro(end, 1)]);
legend('Broadcast Ephemeris');
grid minor;

% ===== Precise Ephemeris
subplot(2, 1, 2);

plot(PRN_pos_ECEF_pre(:, 1), PRN_pos_ECEF_pre(:, 4), 'Color', 'r');

ylabel('Z (m)');
xlim([PRN_pos_ECEF_pre(1, 1) PRN_pos_ECEF_pre(end, 1)]);
legend('Precise Ephemeris');
grid minor;

% ===== Main Config
sgtitle(sprintf('PRN %d ECEF Z Direction', PRN));
main = axes('visible', 'off');
main.XLabel.Visible='on';
xlabel(main,'Time Epoch (s)');

% ===== Save Figure
saveas(gcf, [OutputFolder sprintf('/PRN%d_ECEF_Z.png', PRN)]);

%% ========== Ephemeris Difference ========== %%
% ===== Config
figure;

% ===== Difference
diff = [PRN_pos_ECEF_bro(:, 1) PRN_pos_ECEF_bro(:, 2)-PRN_pos_ECEF_pre(:, 2) PRN_pos_ECEF_bro(:, 3)-PRN_pos_ECEF_pre(:, 3) PRN_pos_ECEF_bro(:, 4)-PRN_pos_ECEF_pre(:, 4)];

% ===== ECEF - X Direction
subplot(3, 1, 1);

plot(diff(:, 1), diff(:, 2));

ylabel('X (m)');
xlim([diff(1, 1) diff(end, 1)]);

DiffX = diff(diff(:, 2)~=0, 2);
legend(sprintf('avg = %.4f (m)', mean(abs(DiffX))));
grid minor;

% ===== ECEF - Y Direction
subplot(3, 1, 2);

plot(diff(:, 1), diff(:, 3));

ylabel('Y (m)');
xlim([diff(1, 1) diff(end, 1)]);

DiffY = diff(diff(:, 3)~=0, 3);
legend(sprintf('avg = %.4f (m)', mean(abs(DiffY))));
grid minor;

% ===== ECEF - Z Direction
subplot(3, 1, 3);

plot(diff(:, 1), diff(:, 4));

ylabel('Z (m)');
xlim([diff(1, 1) diff(end, 1)]);

DiffZ = diff(diff(:, 4)~=0, 4);
legend(sprintf('avg = %.4f (m)', mean(abs(DiffZ))));
grid minor;

% ===== Main Config
sgtitle(sprintf('PRN %d Ephemeris Difference', PRN));
main = axes('visible', 'off');
main.XLabel.Visible='on';
xlabel(main,'Time Epoch (s)');

% ===== Save Figure
saveas(gcf, [OutputFolder sprintf('/PRN%d_Diff.png', PRN)]);