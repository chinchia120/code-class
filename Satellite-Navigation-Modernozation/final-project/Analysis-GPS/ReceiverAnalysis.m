function [] = ReceiverAnalysis(expData, refData, OutName)
%% ========== Initial Value ========== %%
% ===== TimeAlignDataXYZ [Time Exp(X) Exp(Y) Exp(Z) Ref(X) Ref(Y) Ref(Z)]
TimeAlignDataXYZ = zeros(length(expData), 7);

% ===== TimeAlignDataENU [Time Exp(E) Exp(N) Exp(U)]
TimeAlignDataENU = zeros(length(expData), 4);

% ===== ErrorList [Time ErrorE ErrorN ErrorU Error2D Error3D]
ErrorList = zeros(length(expData), 6);

% ===== DOP
DOP = expData(:, 7:10);

%% ========== Coordinate Transformation ========== %%
% ===== Setup
expDataXYZ(:, 1) = expData(:, 1);
refDataXYZ(:, 1) = refData(:, 1);

% ===== Experiment Data to ECEF
expDataXYZ(:, 2:4) = wgslla2xyz(expData(:, 2:4));

% ===== Reference Data to ECEF
refDataXYZ(:, 2:4) = wgslla2xyz(refData(:, 2:4));

%% ========== Time Alignment ========== %%
for i = 1: length(expDataXYZ)
    % ===== Experiment Data
    expTime = expDataXYZ(i, 1);
    expXYZ = expDataXYZ(i, 2:4);

    % ===== Reference Data
    refTime = refDataXYZ(:, 1);
    refXYZ = refDataXYZ(:, 2:4);
    
    % ===== Interpolation
    refENUInterp = interp1(refTime, refXYZ, expTime, 'linear', 'extrap');
    
    % ===== Time Alignment
    TimeAlignDataXYZ(i, :) = [expTime expXYZ refENUInterp];
    TimeAlignDataENU(i, :) = [expTime xyz2enu(expXYZ, refENUInterp)'];
end

%% ========== Receiver ENVT-DOP Analysis ========== %%
% ===== Setup
figure('Name', 'ENVT-DOP Analysis');

% ===== EDOP
subplot(4, 1, 1);

plot(expData(:, 1), DOP(:, 1));
xlim([expData(1, 1) expData(end, 1)]);
ylabel('EDOP');
legend(sprintf('Avg = %.4f', mean(DOP(:, 1))));
grid minor;

% ===== NDOP
subplot(4, 1, 2);

plot(expData(:, 1), DOP(:, 2));
xlim([expData(1, 1) expData(end, 1)]);
ylabel('NDOP');
legend(sprintf('Avg = %.4f', mean(DOP(:, 2))));
grid minor;

% ===== VDOP
subplot(4, 1, 3);
plot(expData(:, 1), DOP(:, 3));
xlim([expData(1, 1) expData(end, 1)]);
ylabel('VDOP');
legend(sprintf('Avg = %.4f', mean(DOP(:, 3))));
grid minor;

% ===== TDOP
subplot(4, 1, 4);
plot(expData(:, 1), DOP(:, 4));
xlim([expData(1, 1) expData(end, 1)]);
ylabel('TDOP');
legend(sprintf('Avg = %.4f', mean(DOP(:, 4))));
grid minor;

% ===== Main Config
sgtitle('ENVT-DOP Analysis');
main = axes('visible', 'off');
main.XLabel.Visible='on';
xlabel(main,'GPS Time (s)');

% ===== Save Figure
saveas(gcf, [OutName '_DOP_ENVT.png']);

%% ========== Receiver HPG-DOP Analysis ========== %%
% ===== Setup
figure('Name', 'HPG-DOP Analysis');

% ===== HDOP
subplot(3, 1, 1);
plot(expData(:, 1), sqrt(DOP(:, 1).^2 + DOP(:, 2).^2));
xlim([expData(1, 1) expData(end, 1)]);
ylabel('HDOP');
legend(sprintf('Avg = %.4f', mean(sqrt(DOP(:, 1).^2 + DOP(:, 2).^2))));
grid minor;

% ===== PDOP
subplot(3, 1, 2);
plot(expData(:, 1), sqrt(DOP(:, 1).^2 + DOP(:, 2).^2 + DOP(:, 3).^2));
xlim([expData(1, 1) expData(end, 1)]);
ylabel('PDOP');
legend(sprintf('Avg = %.4f', mean(sqrt(DOP(:, 1).^2 + DOP(:, 2).^2 + DOP(:, 3).^2))));
grid minor;

% ===== GDOP
subplot(3, 1, 3);
plot(expData(:, 1), sqrt(DOP(:, 1).^2 + DOP(:, 2).^2 + DOP(:, 3).^2 + DOP(:, 4).^2));
xlim([expData(1, 1) expData(end, 1)]);
ylabel('GDOP');
legend(sprintf('Avg = %.4f', mean(sqrt(DOP(:, 1).^2 + DOP(:, 2).^2 + DOP(:, 3).^2 + DOP(:, 4).^2))));
grid minor;

% ===== Main Config
sgtitle('HPG-DOP Analysis');
main = axes('visible', 'off');
main.XLabel.Visible='on';
xlabel(main,'GPS Time (s)');

% ===== Save Figure
saveas(gcf, [OutName '_DOP_HPG.png']);

%% ========== Receiver Clock Bias ========== %%
% ===== Setup
figure('Name', 'Receiver Clock Bias');

% ===== Receiver Clock Bias
plot(expData(:, 1), expData(:, 5), 'b', 'LineWidth', 1.5);
hold on;

% ===== Slope of Clock Bias and TIme
coeffs = polyfit(expData(:, 1), expData(:, 5), 1);
regLine = polyval(coeffs, expData(:, 1));
plot(expData(:, 1), regLine, 'r--', 'LineWidth', 1.5);

% ===== Config
xlim([expData(1, 1) expData(end, 1)]);
title('Receiver Clock Bias');
xlabel('GPS Time (s)');
ylabel('Receiver Clock Bias (s)');
legend('Receiver Clock Bias', sprintf('slope = %.12f', coeffs(1)));
grid on;

% ===== Save Figure
saveas(gcf, [OutName '_ClockBias.png']);

%% ========== Satellite Number ========== %%
% ===== Setup
figure('Name', 'Satellite Numbe in View');

% ===== Satellite Number
plot(expData(:, 1), expData(:, 6), 'b', 'LineWidth', 1.5);

% ===== Config
xlim([expData(1, 1) expData(end, 1)]);
ylim([min(expData(:, 6))-1 max(expData(:, 6)+1)]);
title('Satellite Number in View');
xlabel('GPS Time (s)');
ylabel('Satellite Number');
legend(sprintf('avg = %.4f', mean(expData(:, 6))));
grid on;

% ===== Save Figure
saveas(gcf, [OutName '_SatelliteNumber.png']);

%% ========== ENU Position ========== %%
% ===== Setup
figure('Name', 'ENU Position');

% ===== E Direction
subplot(3, 1, 1);
plot(TimeAlignDataENU(:, 1), TimeAlignDataENU(:, 2));
xlim([TimeAlignDataENU(1, 1) TimeAlignDataENU(end, 1)]);
ylabel('E (m)');
legend(sprintf('Std = %.4f (m)', std(TimeAlignDataENU(:, 2))));
grid minor;

% ===== N Direction
subplot(3, 1, 2);
plot(TimeAlignDataENU(:, 1), TimeAlignDataENU(:, 3));
xlim([TimeAlignDataENU(1, 1) TimeAlignDataENU(end, 1)]);
ylabel('N (m)');
legend(sprintf('Std = %.4f (m)', std(TimeAlignDataENU(:, 3))));
grid minor;

% ===== U Direction
subplot(3, 1, 3);
plot(TimeAlignDataENU(:, 1), TimeAlignDataENU(:, 4));
xlim([TimeAlignDataENU(1, 1) TimeAlignDataENU(end, 1)]);
ylabel('U (m)');
legend(sprintf('Std = %.4f (m)', std(TimeAlignDataENU(:, 4))));
grid minor;

% ===== Main Config
sgtitle('ENU Position');
main = axes('visible', 'off');
main.XLabel.Visible='on';
xlabel(main,'GPS Time (s)');

% ===== Save Figure
saveas(gcf, [OutName '_Position_ENU.png']);

%% ========== Geodetic Position ========== %%
% ===== Setup
figure('Name', 'Geodetic Position');

% ===== Horizontal 
subplot(2, 1, 1);
pos1 = get(gca, 'Position');
set(gca, 'Position', [pos1(1) pos1(2)*0.8 pos1(3) pos1(4)*1.4]);

% ===== Reference Data
refDataAlignLLA = refData(refData(:, 1) >= expData(1, 1) & refData(:, 1) <= expData(end, 1), :);
geoplot(refDataAlignLLA(:, 2), refDataAlignLLA(:, 3), Marker='.', Color='r');
hold on;

% ===== Experiment Data
geoplot(expData(:, 2), expData(:, 3), Marker='.', Color='b');
hold off;

% ===== Geoplot Config
geobasemap satellite;
title('Geodetic Position');
legend('Reference Data', 'Experiment Data');

% ===== Altitude
subplot(2, 1, 2);
pos2 = get(gca, 'Position');
set(gca, 'Position', [pos2(1) pos2(2) pos2(3) pos2(4)*0.6]);

% ===== Reference Data
plot(refData(:, 1), refData(:, 4), 'r', 'LineWidth', 2);
hold on;

% ===== Experiment Data
plot(expData(:, 1), expData(:, 4), 'b', 'LineWidth', 2);
hold off;

% ===== Plot Config
xlabel('GPS Time (s)');
ylabel('Altitude (m)');
xlim([expData(1, 1) expData(end, 1)]);
legend('Reference Data', 'Experiment Data');
grid on;

% ===== Save Figure
saveas(gcf, [OutName '_Position_3D.png']);

%% ========== Error Computation ========== %%
for i = 1: length(TimeAlignDataXYZ)
    ErrorList(i, 1) = TimeAlignDataXYZ(i, 1);
    ErrorList(i, 2) = TimeAlignDataXYZ(i, 2) - TimeAlignDataXYZ(i, 5);
    ErrorList(i, 3) = TimeAlignDataXYZ(i, 3) - TimeAlignDataXYZ(i, 6);
    ErrorList(i, 4) = TimeAlignDataXYZ(i, 4) - TimeAlignDataXYZ(i, 7);
    ErrorList(i, 5) = sqrt(ErrorList(i, 2)^2 + ErrorList(i, 3)^2);
    ErrorList(i, 6) = sqrt(ErrorList(i, 5)^2 + ErrorList(i, 4)^2);
end

%% ========== Error Analysis ========== %%
% ===== Error Avg
ErrorAvg = mean(abs(ErrorList(:, 2:6)));

% ===== Error Max
tmp = ErrorList(:, 2:6);
[~, idx] = max(abs(tmp));
ErrorMax = tmp(sub2ind(size(tmp), idx,1:5));

% ===== Error Std
ErrorStd = [std(ErrorList(:, 2:6))];

% ===== Error RMSE
ErrorRMSE(1:3) = rmse(TimeAlignDataXYZ(:, 2:4), TimeAlignDataXYZ(:, 5:7));
ErrorRMSE(4) = sqrt(ErrorRMSE(1)^2 + ErrorRMSE(2)^2);
ErrorRMSE(5) = sqrt(ErrorRMSE(4)^2 + ErrorRMSE(3)^2);

%% ========== Error Table ========== %%
fprintf('%%%% ============================= Position Accuracy ============================= %%%%\n');
fprintf('    (m)\t     E\t\t     N\t\t     U\t\t    2D\t\t    3D\n');
fprintf('    Avg\t%8.4f\t%8.4f\t%8.4f\t%8.4f\t%8.4f\n', ErrorAvg(:));
fprintf('    Max\t%8.4f\t%8.4f\t%8.4f\t%8.4f\t%8.4f\n', ErrorMax(:));
fprintf('    Std\t%8.4f\t%8.4f\t%8.4f\t%8.4f\t%8.4f\n', ErrorStd(:));
fprintf('   RMSE\t%8.4f\t%8.4f\t%8.4f\t%8.4f\t%8.4f\n', ErrorRMSE(:));

%% ========== ENU Error ========== %%
% ===== Setup
figure('Name', 'ENU Position Error');

% ===== E Error
subplot(3, 1, 1);

plot(ErrorList(:, 1), ErrorList(:, 2));
xlim([ErrorList(1, 1) ErrorList(end, 1)]);
ylabel('E (m)');
legend(sprintf('Avg = %.4f (m)', ErrorAvg(1)));
grid minor;

% ===== N Error
subplot(3, 1, 2);

plot(ErrorList(:, 1), ErrorList(:, 3));
xlim([ErrorList(1, 1) ErrorList(end, 1)]);
ylabel('N (m)');
legend(sprintf('Avg = %.4f (m)', ErrorAvg(2)));
grid minor;

% ===== U Error
subplot(3, 1, 3);

plot(ErrorList(:, 1), ErrorList(:, 4));
xlim([ErrorList(1, 1) ErrorList(end, 1)]);
ylabel('U (m)');
legend(sprintf('Avg = %.4f (m)', ErrorAvg(3)));
grid minor;

% ===== Main Config
sgtitle('Position Error');
main = axes('visible', 'off');
main.XLabel.Visible='on';
xlabel(main,'GPS Time (s)');

% ===== Save Figure
saveas(gcf, [OutName '_ErrorFigure_ENU.png']);

end