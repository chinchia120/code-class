function [] = plotStrain(Station, Strain, OutName)
%% ========== Setup ========= %%
% ===== Initial Value
Scale = 0.001;

diffH = abs(Station(1,1)-Station(8,1));
diffV = abs(Station(1,2)-Station(2,2));

%% ========== Plot Principal Strain Rate ========= %%
% ===== Setup
figure('Name', 'Principal Strain Rate');

% ===== Plot Station
scatter(Station(:, 1), Station(:, 2), 60, '^', 'filled', 'r');
hold on;

% ===== Plot Strain
for i = 1: length(Strain)
    vx = sin(deg2rad(Strain(i, 5)));
    vy = cos(deg2rad(Strain(i, 5)));

    x1 = [Strain(i, 1)-0.5*Strain(i, 3)*vx*Scale Strain(i, 1)+0.5*Strain(i, 3)*vx*Scale];
    y1 = [Strain(i, 2)-0.5*Strain(i, 3)*vy*Scale Strain(i, 2)+0.5*Strain(i, 3)*vy*Scale];
    plot(x1, y1, 'LineWidth', 2, 'Color', 'k');
    hold on;

    x2 = [Strain(i, 1)-0.5*Strain(i, 4)*-vy*Scale Strain(i, 1)+0.5*Strain(i, 4)*-vy*Scale];
    y2 = [Strain(i, 2)-0.5*Strain(i, 4)*vx*Scale Strain(i, 2)+0.5*Strain(i, 4)*vx*Scale];
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
title('Principal Strain Rate');
xlabel('Longitude');
ylabel('Latitude');
xlim([min(Station(:, 1))-0.15 max(Station(:, 1))+0.15]);
ylim([min(Station(:, 2))-0.15 max(Station(:, 2))+0.15]);
legend('Station', 'Cont.', 'Ext.');
grid minor;

% ========== save Figure ========== %%
saveas(gcf, OutName, 'png');

end