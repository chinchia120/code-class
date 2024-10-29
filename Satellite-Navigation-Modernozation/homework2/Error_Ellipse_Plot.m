function [] = Error_Ellipse_Plot(majoraxis, minoraxis, center, error_theta, outName)

% ===== Initial Value
theta = linspace(0, 2*pi, 200);
x = center(1);
y = center(2);

% ===== Center
plot(x, y, 'o', Color='blue');
text(x+majoraxis*0.1, y+minoraxis*0.1, sprintf('[%.4f, %.4f]', x, y), 'fontweight', 'bold');
hold on;

% ===== Error Ellipse
xyRotated = [majoraxis*sin(theta); minoraxis*cos(theta)]'*RotationMatrix_2D(error_theta);
plot(xyRotated(:, 1)+x, xyRotated(:, 2)+y, 'Blue');

% ===== x-axis
x_axis = linspace(-majoraxis*1.2, majoraxis*1.2, 200);
y_axis = zeros(1, 200);
xRotated = [x_axis; y_axis]'*RotationMatrix_2D(error_theta);
plot(xRotated(:, 1)+x, xRotated(:, 2)+y, 'red');
hold on;

% ===== y-axis
x_axis = zeros(1, 200);
y_axis = linspace(-minoraxis*1.5, minoraxis*1.5, 200);
yRotated = [x_axis; y_axis]'*RotationMatrix_2D(error_theta);
plot(yRotated(:, 1)+x, yRotated(:, 2)+y, 'red');
hold on;

% ===== Plot Config
title('Error Ellipse');
xlabel("x (m)");
ylabel("y (m)");
legend('Solution', 'Error Ellipse', 'x-axis', 'y-axis');
text(x-majoraxis, y+minoraxis*2, sprintf(' majoraxis = %.4f (m)\n minoraxis = %.4f (m)\n theta = %.2d (deg)', majoraxis, minoraxis, error_theta));
axis('equal');
hold off;

% ===== Save Figure
saveas(gcf, [outName '.fig']);
saveas(gcf, [outName '.png']);

end

