function [] = plotStrain(Station, Strain, OutName)
%% ========== Setup ========= %%
% ===== Initial Value
scale = 0.001;

%% ========== Plot Principal Strain Rate ========= %%
% ===== Setup
figure('Principal Strain Rate');

% ===== Plot Station
scatter(Station(:, 1), Station(:, 2), 40, '^', 'filled');
hold on;

% ===== Plot Strain
for i = 1: length(Strain)
    x1 = [Strain(i, 1)-0.5*Strain(i, 3)*sind(Strain(i, 5))*scale Strain(i, 1)+0.5*Strain(i, 3)*sind(Strain(i, 5))*scale];
    y1 = [Strain(i, 2)-0.5*Strain(i, 3)*cosd(Strain(i, 5))*scale Strain(i, 2)+0.5*Strain(i, 3)*cosd(Strain(i, 5))*scale];
    plot(x1, y1, 'LineWidth', 2, 'Color', 'k');
    hold on;

    x2 = [Strain(i, 1)-0.5*Strain(i, 4)*sind(Strain(i, 5)+90)*scale Strain(i, 1)+0.5*Strain(i, 4)*sind(Strain(i, 5)+90)*scale];
    y2 = [Strain(i, 2)-0.5*Strain(i, 4)*cosd(Strain(i, 5)+90)*scale Strain(i, 2)+0.5*Strain(i, 4)*cosd(Strain(i, 5)+90)*scale];
    plot(x2, y2, 'LineWidth', 1, 'Color', 'k');
    hold on;
end

% ===== Plot Config
title('Principal Strain Rate');
xlabel('Latitude');
ylabel('Longitude');
xlim([min(Station(:, 1))-0.15 max(Station(:, 1))+0.15]);
ylim([min(Station(:, 2))-0.15 max(Station(:, 2))+0.15]);
legend('Station', 'Strain');
grid minor;

% ========== save Figure ========== %%
saveas(gcf, OutName, 'png');

end