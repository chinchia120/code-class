function [majoraxis, minoraxis, error_ellipse_theta] = Error_Ellipse_Params(var, J, x_hat, y_hat, S)

% ===== Initial Value
x = var(1);
y = var(2);

% ===== Calculate Parameters
Sx = double(subs(J*S*J', [x y], [x_hat y_hat]));
[eigVec, eigVal] = eig(Sx);
error_ellipse_theta = [atand(eigVec(1, 1)/eigVec(1, 2)) atand(eigVec(2, 1)/eigVec(2, 2))];
majoraxis = sqrt(eigVal(2, 2));
minoraxis = sqrt(eigVal(1, 1));

end

