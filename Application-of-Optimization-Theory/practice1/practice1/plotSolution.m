function plotSolution(lb, ub, objFcn, sol, OutName)
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

%% ========== Plot Solution ========== %%
plot(sol(1), sol(2), 'r*', 'MarkerSize', 10); 

%% ========== Plot Config ========== %%
colorbar;
xlabel('x');
ylabel('y');
title('Solution of Objective Function');
legend('Level Sets', 'Optimal Point');
grid on;

%% ========== Save Figure ========== %%
saveas(gcf, OutName, 'png');

end