function [] = plotShear(Station, Shear, OutName)
%% ========== Setup ========= %%
% ===== Initial Value
scale = 0.001;

%% ========== Plot Principal Strain Rate ========= %%
% ===== Setup
figure;

% ===== Plot Station
scatter(Station(:, 1), Station(:, 2), 40, '^', 'filled');
hold on;

% ===== Plot Strain
for i = 1: length(Shear)
    x1 = [Shear(i, 1)-0.5*Shear(i, 3)*sin(Shear(i, 5))*scale Shear(i, 1)+0.5*Shear(i, 3)*sin(Shear(i, 5))*scale];
    y1 = [Shear(i, 2)-0.5*Shear(i, 3)*cos(Shear(i, 5))*scale Shear(i, 2)+0.5*Shear(i, 3)*cos(Shear(i, 5))*scale];
    plot(x1, y1, 'LineWidth', 2, 'Color', 'k');
    hold on;

    x2 = [Shear(i, 1)-0.5*Shear(i, 4)*sin(Shear(i, 5)+pi/2)*scale Shear(i, 1)+0.5*Shear(i, 4)*sin(Shear(i, 5)+pi/2)*scale];
    y2 = [Shear(i, 2)-0.5*Shear(i, 4)*cos(Shear(i, 5)+pi/2)*scale Shear(i, 2)+0.5*Shear(i, 4)*cos(Shear(i, 5)+pi/2)*scale];
    plot(x2, y2, 'LineWidth', 1, 'Color', 'k');
    hold on;
end

% ===== Plot Config
title('Shear Strain Rate');
xlabel('Latitude');
ylabel('Longitude');
xlim([min(Station(:, 1))-0.15 max(Station(:, 1))+0.15]);
ylim([min(Station(:, 2))-0.15 max(Station(:, 2))+0.15]);
legend('Station', 'Shear');
grid minor;

% ========== save Figure ========== %%
saveas(gcf, OutName, 'png');

end

