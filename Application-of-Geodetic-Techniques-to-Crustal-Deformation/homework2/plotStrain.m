function [] = plotStrain(Station, Strain, OutName)
%% ========== Setup ========= %%
% ===== Initial Value
Scale = 0.001;

diffV = abs(Station(1,2)-Station(2,2));

x_start = max(Station(:, 1));
y_start = min(Station(:, 2)) - diffV*0.75;

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
line([x_start, x_start+100*Scale], [y_start, y_start], 'Color', 'r', 'LineWidth', 2);
text(max(Station(:, 1)), min(Station(:, 2))-diffV*0.5, '100.0 mm');
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