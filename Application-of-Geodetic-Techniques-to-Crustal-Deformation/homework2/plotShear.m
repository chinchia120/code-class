function [] = plotShear(Station, Shear, OutName)
%% ========== Setup ========= %%
% ===== Initial Value
Scale = 0.0005;

diffH = abs(Station(1,1)-Station(8,1));
diffV = abs(Station(1,2)-Station(2,2));

%% ========== Plot Shear Strain Rate ========= %%
% ===== Setup
figure('Name', 'Shear Strain Rate');

% ===== Plot Station
scatter(Station(:, 1), Station(:, 2), 60, '^', 'filled', 'r');
hold on;

% ===== Plot Strain
for i = 1: length(Shear)
    vx = sind(Shear(i, 5));
    vy = cosd(Shear(i, 5));

    x1 = [Shear(i, 1)-0.5*Shear(i, 4)*vx*Scale Shear(i, 1)+0.5*Shear(i, 4)*vx*Scale];
    y1 = [Shear(i, 2)-0.5*Shear(i, 4)*vy*Scale Shear(i, 2)+0.5*Shear(i, 4)*vy*Scale];
    plot(x1, y1, 'LineWidth', 2, 'Color', 'k');
    hold on;

    x2 = [Shear(i, 1)-0.5*Shear(i, 4)*-vy*Scale Shear(i, 1)+0.5*Shear(i, 4)*-vy*Scale];
    y2 = [Shear(i, 2)-0.5*Shear(i, 4)*vx*Scale Shear(i, 2)+0.5*Shear(i, 4)*vx*Scale];
    plot(x2, y2, 'LineWidth', 2, 'Color', 'b');
    hold on;
end

% ===== Plot Scale
scale = quiver(max(Station(:, 1)), min(Station(:, 2))-diffV*0.75, diffH*0.75, 0, 0);
scale.ShowArrowHead = 'on';
scale.MaxHeadSize = 2;
text(max(Station(:, 1)), min(Station(:, 2))-diffV*0.5, sprintf('%.2f mm', diffH*0.75/Scale));
hold off;

% ===== Plot Config
title('Shear Strain Rate');
xlabel('Longitude');
ylabel('Latitude');
xlim([min(Station(:, 1))-0.15 max(Station(:, 1))+0.15]);
ylim([min(Station(:, 2))-0.15 max(Station(:, 2))+0.15]);
legend('Station', 'Left Lateral', 'Right Lateral');
grid minor;

% ========== save Figure ========== %%
saveas(gcf, OutName, 'png');

end