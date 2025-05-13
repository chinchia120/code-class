function [] = plotDisplacement(cor, dis, OutName)
%% ========== Setup ========= %%
% ===== Initial Value
sec = zeros(49, 3);
cos = zeros(49, 3);

scaleSecH = 0.002;
scaleSecV = 0.05;
scaleCosH = 0.001;
scaleCosV = 0.01;

%% ========== Read Coordinate Data ========== %%
coordinates = readmatrix(cor, 'FileType', 'text');
coordinates = coordinates(:, 1:2);

diffV = abs(coordinates(1,2)-coordinates(2,2));
x_start = max(coordinates(:, 1));
y_start = min(coordinates(:, 2)) - diffV * 0.75;

%% ========== Read Displacement Data ========== %%
disfile = fopen(dis);
i = 0;
while ~feof(disfile)
    i = i+1;
    distmp = fgetl(disfile);
    disspt = strsplit(distmp, ' ');

    if mod(i, 10) == 4
        sec(int32(i/10)+1, 1) = str2double(disspt(4));
    elseif mod(i, 10) == 5
        sec(int32(i/10), 2) = str2double(disspt(4));
    elseif mod(i, 10) == 6
        sec(int32(i/10), 3) = str2double(disspt(4));
    elseif mod(i, 10) == 9
        cos(int32(i/10), 1) = str2double(disspt(4));
    elseif mod(i, 10) == 0 && i >= 10
        cos(int32(i/10), 2) = str2double(disspt(4));
    elseif mod(i, 10) == 1 && i >= 10
        cos(int32(i/10), 3) = str2double(disspt(4));
    end
end
fclose(disfile);

%% ========== Plot Secular Motion Horizontal ========== %%
% ===== Setup
figure;

% ===== Plot Station
scatter(coordinates(:, 1), coordinates(:, 2), 60, '^', 'filled', 'r');
for i = 1:49 
    text(coordinates(i, 1)-0.03, coordinates(i, 2)-0.02, sprintf('CK%02d', i));
end
hold on;

% ===== Plot Secular Motion Horizontal
error = quiver(coordinates(:, 1), coordinates(:, 2), sec(:, 1)*scaleSecH, sec(:, 2)*scaleSecH, 0, 'k', 'LineWidth', 2);
error.ShowArrowHead = 'on';
hold on;

% ===== Plot Scale
line([x_start, x_start+50*scaleSecH], [y_start, y_start], 'Color', 'k', 'LineWidth', 2);
text(max(coordinates(:, 1)), min(coordinates(:, 2))-diffV*0.5, '50.0 mm');
hold off;

% ===== Plot Config
title('Secular Motion in Horizontal');
xlabel('Longitude');
ylabel('Latitude');
xlim([min(coordinates(:, 1))-0.15 max(coordinates(:, 1))+0.15]);
ylim([min(coordinates(:, 2))-0.15 max(coordinates(:, 2))+0.15]);
legend('Station', 'Secular Motion (mm/yr)');
grid minor;

% ========== save Figure ========== %%
saveas(gcf, [OutName 'SecH'], 'png');

%% ========== Plot Secular Motion Vertical ========== %%
% ===== Setup
figure;

% ===== Plot Station
scatter(coordinates(:, 1), coordinates(:, 2), 60, '^', 'filled', 'r');
for i = 1:49 
    text(coordinates(i, 1)-0.03, coordinates(i, 2)-0.02, sprintf('CK%02d', i));
end
hold on;

% ===== Plot Secular Motion Verticle
error = quiver(coordinates(:, 1), coordinates(:, 2), sec(:, 3)*0, sec(:, 3)*scaleSecV, 0, 'k', 'LineWidth', 2);
error.ShowArrowHead = 'on';
hold on;

% ===== Plot Scale
line([x_start, x_start+2*scaleSecV], [y_start, y_start], 'Color', 'k', 'LineWidth', 2);
text(max(coordinates(:, 1)), min(coordinates(:, 2))-diffV*0.5, '2.0 mm');
hold off;

% ===== Plot Config
title('Secular Motion in Vertical');
xlabel('Longitude');
ylabel('Latitude');
xlim([min(coordinates(:, 1))-0.15 max(coordinates(:, 1))+0.15]);
ylim([min(coordinates(:, 2))-0.15 max(coordinates(:, 2))+0.15]);
legend('Station', 'Secular Motion (mm/yr)');
grid minor;

% ========== save Figure ========== %%
saveas(gcf, [OutName 'SecV'], 'png');

%% ========== Plot Coseismic Displacements Horizontal ========== %%
% ===== Setup
figure;

% ===== Plot Station
scatter(coordinates(:, 1), coordinates(:, 2), 60, '^', 'filled', 'r');
for i = 1:49 
    text(coordinates(i, 1)-0.03, coordinates(i, 2)-0.02, sprintf('CK%02d', i));
end
hold on;

% ===== Plot Coseismic Displacements Horizontal
error = quiver(coordinates(:, 1), coordinates(:, 2), cos(:, 1)*scaleCosH, cos(:, 2)*scaleCosH, 0, 'k', 'LineWidth', 2);
error.ShowArrowHead = 'on';
hold on;

% ===== Plot Scale
line([x_start, x_start+100*scaleCosH], [y_start, y_start], 'Color', 'k', 'LineWidth', 2);
text(max(coordinates(:, 1)), min(coordinates(:, 2))-diffV*0.5, '100.0 mm');
hold off;

% ===== Plot Config
title('Coseismic Displacements in Horizontal');
xlabel('Longitude');
ylabel('Latitude');
xlim([min(coordinates(:, 1))-0.15 max(coordinates(:, 1))+0.15]);
ylim([min(coordinates(:, 2))-0.15 max(coordinates(:, 2))+0.15]);
legend('Station', 'Coseismic Displacements (mm)');
grid minor;

% ========== save Figure ========== %%
saveas(gcf, [OutName 'CosH'], 'png');

%% ========== Plot Coseismic Displacements Vertical ========== %%
% ===== Setup
figure;

% ===== Plot Station
scatter(coordinates(:, 1), coordinates(:, 2), 60, '^', 'filled', 'r');
for i = 1:49 
    text(coordinates(i, 1)-0.03, coordinates(i, 2)-0.02, sprintf('CK%02d', i));
end
hold on;

% ===== Plot Coseismic Displacements Verticle
error = quiver(coordinates(:, 1), coordinates(:, 2), cos(:, 3)*0, cos(:, 3)*scaleCosV, 0, 'k', 'LineWidth', 2);
error.ShowArrowHead = 'on';
hold on;

% ===== Plot Scale
line([x_start, x_start+10*scaleCosV], [y_start, y_start], 'Color', 'k', 'LineWidth', 2);
text(max(coordinates(:, 1)), min(coordinates(:, 2))-diffV*0.5, '10.0 mm');
hold off;

% ===== Plot Config
title('Coseismic Displacements in Vertical');
xlabel('Longitude');
ylabel('Latitude');
xlim([min(coordinates(:, 1))-0.15 max(coordinates(:, 1))+0.15]);
ylim([min(coordinates(:, 2))-0.15 max(coordinates(:, 2))+0.15]);
legend('Station', 'Coseismic Displacements (mm)');
grid minor;

% ========== save Figure ========== %%
saveas(gcf, [OutName 'CosV'], 'png');

end