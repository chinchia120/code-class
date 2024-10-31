function [majoraxis, minoraxis, theta] = Error_Ellipse_Params(var, J, S, sigma0, x_hat, y_hat)

% ===== Initial Value
x = var(1);
y = var(2);

% ===== Calculate Parameters
J = double(subs(J, [x y], [x_hat y_hat]));
Sx = sigma0^2*inv(J'*S*J);
[eigVec, eigVal] = eig(Sx);

if eigVal(1, 1) > eigVal(2, 2)
    majoraxis = sqrt(eigVal(1, 1));
    minoraxis = sqrt(eigVal(2, 2));
    theta = atand(eigVec(2, 1)/eigVec(1, 1));
else
    majoraxis = sqrt(eigVal(2, 2));
    minoraxis = sqrt(eigVal(1, 1));
    theta = atand(eigVec(2, 2)/eigVec(1, 2));
end

end