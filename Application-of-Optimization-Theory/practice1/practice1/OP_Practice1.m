%% ========== Setup ========== %%
% ===== Setup
clc; clear; close all;

% ===== Output Data
OutputFolder = sprintf('OutputFigure');
if ~exist(OutputFolder, 'dir'); mkdir(OutputFolder); end

%% ========== Question 1 ========== %%
% ===== Initial Value
ub = [10, 10];
lb = [-10, -10];
x0 = [0, 0];

function f = objectiveFcn1(optimInput)
    x = optimInput(1);
    y = optimInput(2);
    f = x^2 + y^2 + 3*x - 4*y + 6;
end

% ===== Solve Solution using Optimization Tool
option1 = optimoptions("fmincon","Display","off");
[solution,objectiveValue] = fmincon(@objectiveFcn1,x0,[],[],[],[],lb,ub,[],option1);

% ===== Plot level sets
plotLevelSets(lb, ub, @objectiveFcn1, [OutputFolder '/LevelSets_1']);

% ===== Plot Solution
plotSolution(lb, ub, @objectiveFcn1, solution, [OutputFolder '/Soution_1']);

%% ========== Question 2 ========== %%