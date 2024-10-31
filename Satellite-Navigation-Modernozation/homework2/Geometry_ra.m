function [] = Geometry_ra(c, r, a, s, outName)

% ===== Initial Value
theta = linspace(0, 2*pi, 200);

% ===== Central A
plot(c(1), c(2), 'o', Color='blue');
text(c(1)*1.1, c(2)*0.8, sprintf('[%.1f, %.1f]', c(1), c(2)), 'fontweight', 'bold');
hold on;

% ===== Circle A
x1 = r*cos(theta) + c(1);
y1 = r*sin(theta) + c(2);
plot(x1, y1, 'blue', 'LineWidth', 2);
hold on;

% ===== Central Solution
plot(s(1), s(2), '*', Color='green', LineWidth=2);
text(s(1)*0.9, s(2)*1.1, sprintf('[%.4f, %.4f]', s(1), s(2)), 'fontweight', 'bold');
hold on;

% ===== Bearing
plot([c(1) c(1)+30*cosd(a)], [c(2) c(2)+30*sind(a)], '-', 'Color', 'black', 'LineWidth', 1);
hold off;

% ===== Plot Config
title('Geometry');
xlabel("x (m)");
ylabel("y (m)");
legend('Beacon', 'Range', 'Solution', 'Bearing');
grid minor;
axis('equal');

% ===== Save Figure
saveas(gcf, [outName '.fig']);
saveas(gcf, [outName '.png']);

end

