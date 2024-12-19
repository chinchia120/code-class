function [] = AnalysisData(expData, trueData, outName)
%% ========== Initial Value ========== %%
Data = [];
Error = zeros(length(expData), 5);

%% ========== Data Analysis ========== %%
Data(1, :) = mean(expData(:, 2:11));
Data(2, :) = std(expData(:, 2:11));

%% ========== Save Data Analysis Result ========== %%
array2table(Data)
save([outName '_Data.mat'], 'Data');

%% ========== Error Analysis ========== %%
for i = 1: length(expData)
    Error(i, 1) = expData(i, 2) - trueData(1);
    Error(i, 2) = expData(i, 3) - trueData(2);
    Error(i, 3) = expData(i, 4) - trueData(3);
    Error(i, 4) = sqrt(Error(i, 1)^2 + Error(i, 2)^2);
    Error(i, 5) = sqrt(Error(i, 1)^2 + Error(i, 2)^2 + Error(i, 3)^2);
end

%% ========== Error Analysis ========== %%
% ===== Average Error
ErrorAvg = mean(abs(Error));

% ===== Max Error
[~, idx] = max(abs(Error));
ErrorMax = Error(sub2ind(size(Error), idx, 1:size(Error, 2)));

% ===== Error Standard Deviation
ErrorStd = std(Error);

% ===== Error RMSE
ErrorRMSE(1:3) = rmse(expData(:, 2:4), trueData);
ErrorRMSE(4) = sqrt(ErrorRMSE(1)^2 + ErrorRMSE(2)^2);
ErrorRMSE(5) = sqrt(ErrorRMSE(4)^2 + ErrorRMSE(3)^2);

% ===== Error Table
ErrorTable = [ErrorAvg; ErrorMax; ErrorStd; ErrorRMSE];

%% ========== Save Error Analysis Result ========== %%
save([outName '_Error.mat'], 'Error');
save([outName '_ErrorTable.mat'], 'ErrorTable');

%% ========== Error Figure ========== %%
% ===== E Direction
subplot(3, 1, 1);
plot(expData(:, 1), Error(:, 1));
xlabel('Time (s)');
ylabel('X Error (m)');
grid on;

% ===== N Direction
subplot(3, 1, 2);
plot(expData(:, 1), Error(:, 2));
xlabel('Time (s)');
ylabel('Y Error (m)');
grid on;

% ===== U Direction
subplot(3, 1, 3);
plot(expData(:, 1), Error(:, 3));
xlabel('Time (s)');
ylabel('Z Error (m)');
grid on;

% ===== Figure Config
sgtitle('Error Figure');

% ===== Save Figure
saveas(gcf, [outName '_XYZ.png']);

end