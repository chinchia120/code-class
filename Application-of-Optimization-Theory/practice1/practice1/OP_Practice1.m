%% ========== Setup ========== %%
% ===== Setup
clc; clear; close all;

% ===== Output Data
OutputFolder = sprintf('OutputFigure');
if ~exist(OutputFolder, 'dir'); mkdir(OutputFolder); end

%% ========== Question 1 ========== %%
% ===== Initial Value
ub1 = [10, 10];
lb1 = [-10, -10];
x01 = [0, 0];

function f = objectiveFcn1(optimInput)
    x = optimInput(1);
    y = optimInput(2);
    f = x^2 + y^2 + 3*x - 4*y + 6;
end

% ===== Solve Solution using Optimization Tool
option1 = optimoptions("fmincon","Display","off");
[solution1,objectiveValue1] = fmincon(@objectiveFcn1,x01,[],[],[],[],lb1,ub1,[],option1);

% ===== Plot level sets
plotLevelSets(lb1, ub1, @objectiveFcn1, [OutputFolder '/LevelSets_1']);

% ===== Plot Solution
plotSolution(lb1, ub1, @objectiveFcn1, solution1, [OutputFolder '/Soution_1']);

%% ========== Question 2 ========== %%
% ===== Initial Value
ub2 = [5, 5];
lb2 = [0, 0];
x02 = [0, 0];

% Define constraints
A = [1, 2];
b = 2;

function f = objectiveFcn2(optimInput)
    x = optimInput(1);
    y = optimInput(2);
    f = (x-1)^2 + (y-2)^2;
end

% ===== Solve Solution using Optimization Tool
option2 = optimoptions("fmincon","Display","off");
[solution2,objectiveValue2] = fmincon(@objectiveFcn2,x02,A,b,[],[],lb2,ub2,[],option2);

% ===== Plot level sets
plotLevelSets(lb2, ub2, @objectiveFcn2, [OutputFolder '/LevelSets_2']);

% ===== Plot level sets with feasible region
plotLevelSetsConstrain(lb2, ub2, @objectiveFcn2, A, b, [OutputFolder '/LevelSetsCon_2']);

% ===== Plot Solution with feasible region
plotSolutionConstrain(lb2, ub2, @objectiveFcn2, solution2, A, b, [OutputFolder '/Solution_2']);