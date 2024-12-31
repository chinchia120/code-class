function [] = ReceiverAnalysis(expDataLLA, refDataLLA, OutputFolder)
%% ========== Initial Value ========== %%
% ===== TimeAlignDataENU [Time Exp(E) Exp(N) Exp(U) Ref(E) Ref(N) Ref(U)]
TimeAlignDataENU = zeros(length(expDataLLA), 7);

% ===== ErrorList [Time ErrorE ErrorN ErrorU Error2D Error3D]
ErrorList = zeros(length(expDataLLA), 6);

%% ========== Coordinate Transformation ========== %%
% ===== Experiment Data to ECEF
expDataXYZ(:, 1) = expDataLLA(:, 1);
expDataXYZ(:, 2:4) = wgslla2xyz(expDataLLA(:, 2:4));

% ===== Reference Data to ECEF
refDataXYZ(:, 1) = refDataLLA(:, 1);
refDataXYZ(:, 2:4) = wgslla2xyz(refDataLLA(:, 2:4));

%% ========== Time Alignment ========== %%
for i = 1: length(expDataXYZ)
    % ===== Experiment Data
    expTime = expDataXYZ(i, 1);
    expENU = expDataXYZ(i, 2:4);

    % ===== Reference Data
    refTime = refDataXYZ(:, 1);
    refENU = refDataXYZ(:, 2:4);
    
    % ===== Interpolation
    refENUInterp = interp1(refTime, refENU, expTime, 'linear', 'extrap');
    
    % ===== Time Alignment
    TimeAlignDataENU(i, :) = [expTime expENU refENUInterp];
    
end

%% ========== Error Computation ========== %%
for i = 1: length(TimeAlignDataENU)
    ErrorList(i, 1) = TimeAlignDataENU(i, 1);
    ErrorList(i, 2) = TimeAlignDataENU(i, 2) - TimeAlignDataENU(i, 5);
    ErrorList(i, 3) = TimeAlignDataENU(i, 3) - TimeAlignDataENU(i, 6);
    ErrorList(i, 4) = TimeAlignDataENU(i, 4) - TimeAlignDataENU(i, 7);
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
ErrorRMSE(1:3) = rmse(TimeAlignDataENU(:, 2:4), TimeAlignDataENU(:, 5:7));
ErrorRMSE(4) = sqrt(ErrorRMSE(1)^2 + ErrorRMSE(2)^2);
ErrorRMSE(5) = sqrt(ErrorRMSE(4)^2 + ErrorRMSE(3)^2);

%% ========== Error Table ========== %%
fprintf('%%%% ============================= Position Accuracy ============================= %%%%\n');
fprintf('    (m)\t     E\t\t     N\t\t     U\t\t    2D\t\t    3D\n');
fprintf('    Avg\t%8.4f\t%8.4f\t%8.4f\t%8.4f\t%8.4f\n', ErrorAvg(:));
fprintf('    Max\t%8.4f\t%8.4f\t%8.4f\t%8.4f\t%8.4f\n', ErrorMax(:));
fprintf('    Std\t%8.4f\t%8.4f\t%8.4f\t%8.4f\t%8.4f\n', ErrorStd(:));
fprintf('   RMSE\t%8.4f\t%8.4f\t%8.4f\t%8.4f\t%8.4f\n', ErrorRMSE(:));

%% ========== Save Analysis Data ========== %%
% save([OutName '_ErrorList.mat'], 'ErrorList');

%% ========== ENU Error ========== %%
% ===== Setup
figure;

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
% saveas(gcf, [OutName '_ErrorFigure_ENU.fig']);

%% ========== Geodetic Position ========== %%
% ===== Setup
figure;

% ===== Horizontal 
subplot(2, 1, 1);
pos1 = get(gca, 'Position');
set(gca, 'Position', [pos1(1) pos1(2)*0.8 pos1(3) pos1(4)*1.4]);

% ===== Reference Data
refDataAlignLLA = refDataLLA(refDataLLA(:, 1) >= expDataLLA(1, 1) & refDataLLA(:, 1) <= expDataLLA(end, 1), :);
geoplot(refDataAlignLLA(:, 2), refDataAlignLLA(:, 3), Marker='.', Color='r');
hold on;

% ===== Experiment Data
geoplot(expDataLLA(:, 2), expDataLLA(:, 3), Marker='.', Color='b');
hold off;

% ===== Geoplot Config
geobasemap topographic;
title('Geodetic Position');
legend('Reference Data', 'Experiment Data');

% ===== Altitude
subplot(2, 1, 2);
pos2 = get(gca, 'Position');
set(gca, 'Position', [pos2(1) pos2(2) pos2(3) pos2(4)*0.6]);

% ===== Reference Data
plot(refDataLLA(:, 1), refDataLLA(:, 4), 'r', 'LineWidth', 2);
hold on;

% ===== Experiment Data
plot(expDataLLA(:, 1), expDataLLA(:, 4), 'b', 'LineWidth', 2);
hold off;

% ===== Plot Config
xlabel('GPS Time (s)');
ylabel('Altitude (m)');
xlim([expDataLLA(1, 1) expDataLLA(end, 1)]);
legend('Reference Data', 'Experiment Data');
grid on;

% ===== Save Figure
% saveas(gcf, [OutName '_ErrorFigure_3D.fig']);

end