function [] = Geometry_aa(c1, c2, a1, a2, s, outName)

% ===== Central A
plot(c1(1), c1(2), 'o', Color='blue');
text(c1(1)*1.05, c1(2)*0.8, sprintf('[%.1f, %.1f]', c1(1), c1(2)), 'fontweight', 'bold');
hold on;

% ===== Central B
plot(c2(1), c2(2), 'o', Color='red');
text(c2(1)*1.1, c2(2)*1.1, sprintf('[%.1f, %.1f]', c2(1), c2(2)), 'fontweight', 'bold');
hold on;

% ===== Central Solution
plot(s(1), s(2), '*', Color='green', LineWidth=2);
text(s(1)*0.95, s(2)*1.1, sprintf('[%.4f, %.4f]', s(1), s(2)), 'fontweight', 'bold');
hold on;

% ===== Bearing
plot([c1(1) c1(1)+30*cosd(a1)], [c1(2) c1(2)+30*sind(a1)], '-', 'Color', 'black', 'LineWidth', 1);
plot([c2(1) c2(1)+30*cosd(a2)], [c2(2) c2(2)+30*sind(a2)], '-', 'Color', 'black', 'LineWidth', 1);
hold off;

% ===== Plot Config
title('Geometry');
xlabel("x (m)");
ylabel("y (m)");
legend('Beacon A', 'Beacon B', 'Solution', 'Bearing');
grid minor;
axis('equal');

% ===== Save Figure
saveas(gcf, [outName '.fig']);
saveas(gcf, [outName '.png']);

end

