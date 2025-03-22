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

% ===== Plot level sets with feasible region
plotLevelSetsWithFeasible(lb2, ub2, @objectiveFcn2, A, b, [OutputFolder '/LevelSets_2']);

% ===== Plot Solution with feasible region
plotSolutionWithFeasible(lb2, ub2, @objectiveFcn2, solution2, A, b, [OutputFolder '/Solution_2']);

function plotLevelSetsWithFeasible(lb, ub, objFcn, A, b, savePath)
    % Create level sets plot
    figure;
    [X, Y] = meshgrid(lb(1):0.1:ub(1), lb(2):0.1:ub(2));
    
    % Calculate Z values using the objective function
    Z = zeros(size(X));
    for i = 1:size(X,1)
        for j = 1:size(X,2)
            Z(i,j) = objFcn([X(i,j), Y(i,j)]);
        end
    end
    
    % Create contour plot with labels
    contour(X, Y, Z, 100);
    colorbar;
    hold on;
    
    % Plot feasible region
    x = 0:0.1:5;
    y = (b - A(1)*x)/A(2);  % x + 2y <= 2
    plot(x, y, 'r-', 'LineWidth', 2);  % Constraint line
    fill([0, 0, 2, 0], [0, 1, 0, 0], 'r', 'FaceAlpha', 0.2);  % Feasible region
    
    xlabel('x');
    ylabel('y');
    title('Level Sets with Feasible Region');
    grid on;
    legend('Level Sets', 'Constraint: x + 2y ≤ 2', 'Feasible Region');
    hold off;
    
    % Save figure
    saveas(gcf, savePath);
end

function plotSolutionWithFeasible(lb, ub, objFcn, solution, A, b, savePath)
    % Create level sets plot
    figure;
    [X, Y] = meshgrid(lb(1):0.1:ub(1), lb(2):0.1:ub(2));
    
    % Calculate Z values using the objective function
    Z = zeros(size(X));
    for i = 1:size(X,1)
        for j = 1:size(X,2)
            Z(i,j) = objFcn([X(i,j), Y(i,j)]);
        end
    end
    
    % Create contour plot with labels
    [C, h] = contour(X, Y, Z, 100);
    clabel(C, h, 'FontSize', 8);
    colorbar;
    hold on;
    
    % Plot feasible region
    x = 0:0.1:5;
    y = (b - A(1)*x)/A(2);  % x + 2y <= 2
    plot(x, y, 'r-', 'LineWidth', 2);  % Constraint line
    fill([0, 0, 2, 0], [0, 1, 0, 0], 'r', 'FaceAlpha', 0.2);  % Feasible region
    
    % Plot optimal solution
    plot(solution(1), solution(2), 'k*', 'MarkerSize', 10);
    
    xlabel('x');
    ylabel('y');
    title('Optimal Solution with Feasible Region');
    grid on;
    legend('Level Sets', 'Constraint: x + 2y ≤ 2', 'Feasible Region', 'Optimal Solution', 'Location', 'best');
    hold off;
    
    % Save figure
    saveas(gcf, savePath);
end