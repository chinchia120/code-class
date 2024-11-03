function [a] = helperAcceleration(x, y, z)

% ===== Initial Value
J2 = 1082.63 * 10^-6;
GM = 3.986005 * 10^14;      % m^3/s^2
ae = 6378137;               % m

r = sqrt(x^2 + y^2 + z^2);

% ===== Calculate Acceleration
ax = GM*x/r^3 * (1 - J2 * 3/2 * (ae/r)^2 * (5*z^2/r^2 - 1));
ay = y/x * ax;
az = -GM*z/r^3 * (1 + J2 * 3/2 * (ae/r)^2 * (3 - 5*z^2/r^2));

a = [ax; ay; az];

end