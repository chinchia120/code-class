function plotLevelSetsConstrain(lb, ub, objFcn, A, b, OutName)
%% ========== Setup ========== %%
figure; clf;

%% ========== Meshgrid ========== %%
[X, Y] = meshgrid(lb(1):0.1:ub(1), lb(2):0.1:ub(2));
    
%% ========== Objective Function ========== %%
Z = zeros(size(X));
for i = 1:size(X,1)
    for j = 1:size(X,2)
        Z(i,j) = objFcn([X(i,j), Y(i,j)]);
    end
end
    
%% ========== Plot Level Set ========== %%
contour(X, Y, Z, 100);
hold on;
    
%% ========== Plot Constrain ========== %%
x = 0:0.1:2;
y = (b - A(1)*x)/A(2);  % x + 2y <= 2
plot(x, y, 'r-', 'LineWidth', 2);
fill([0, 0, 2, 0], [0, 1, 0, 0], 'r', 'FaceAlpha', 0.2);

%% ========== Plot Config ========== %%
colorbar;
xlabel('x');
ylabel('y');
title('Level Sets with Constrain of Objective Function');
legend('Level Sets', 'Constraint: x + 2y ≤ 2', 'Feasible Region');
grid on;
hold off;
    
%% ========== Save Figure ========== %%
saveas(gcf, OutName, 'png');

end