function [] = Geometry_rr(c1, c2, r1, r2, outName)

% ===== Initial Value
theta = linspace(0, 2*pi, 200);

% ===== Central A
plot(c1(1), c1(2), 'o', Color='blue');
text(c1(1)*1.1, c1(2)*1.1, sprintf('[%.1f, %.1f]', c1(1), c1(2)), 'fontweight', 'bold');
hold on;

% ===== Central B
plot(c2(1), c2(2), 'o', Color='red');
text(c2(1)*1.1, c2(2)*1.1, sprintf('[%.1f, %.1f]', c2(1), c2(2)), 'fontweight', 'bold');
hold on;

% ===== Circle A
x1 = r1*cos(theta) + c1(1);
y1 = r1*sin(theta) + c1(2);
plot(x1, y1, 'blue');
hold on;

% ===== Circle B
x2 = r2*cos(theta) + c2(1);
y2 = r2*sin(theta) + c2(2);
plot(x2, y2, 'red');
hold on;

% ===== Intersection
[xout, yout] = circcirc(c1(1), c1(2), r1, c2(1), c2(2), r2);
text(xout(1)*1.1, yout(1)*1.1, sprintf('[%.4f, %.4f]', xout(1), yout(1)), 'fontweight', 'bold');
text(xout(2)*1.1, yout(2)*1.1, sprintf('[%.4f, %.4f]', xout(2), yout(2)), 'fontweight', 'bold');
plot(xout, yout, '*', Color='black');
hold off;

% ===== Plot Config
title('Geometry');
xlabel("x (m)");
ylabel("y (m)");
legend('Beacon A', 'Beacon B', 'Range A', 'Range B', 'Solution');
grid minor;
axis('equal');

% ===== Save Figure
saveas(gcf, [outName '.fig']);
saveas(gcf, [outName '.png']);

end

