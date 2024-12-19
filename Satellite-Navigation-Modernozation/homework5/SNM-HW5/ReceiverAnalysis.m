function [] = ReceiverAnalysis(ReceiverData, TruePos, OutputFolder)
%% ========== Read Receiver Data ========== %%
receiver = ReceiverDataReader(ReceiverData);

%% ========== Initial Value ========== %%
if isempty(TruePos)
    TruePos = mean(receiver.Data(:, 2:7));
end

%% ========== Data Analysis ========== %%
AnalysisData(receiver.Data(:, 1:11), TruePos(1:3), [OutputFolder '_Analysis']);

%% ========== Analysis XYZ ========== %%
AnalysisENU([receiver.Data(:, 1:4)], TruePos(1:3), [OutputFolder '_XYZ']);

%% ========== Analysis ENU ========== %%
AnalysisENU([receiver.Data(:, 1) receiver.Data(:, 5:7)], [0 0 0], [OutputFolder '_ENU']);

%% ========== Analysis LLA ========== %%
AnalysisLLA([receiver.Data(:, 1) receiver.Data(:, 8:10)], TruePos(4:6), [OutputFolder '_LLA']);

%% ========== Analysis Time Versus ENUB ========== %%
AnalysisTime([receiver.Data(:, 1) receiver.Data(:, 5:7) receiver.Data(:, 11)], [OutputFolder '_Time']);

end