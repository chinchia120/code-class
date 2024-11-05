function [a] = helperKeplerian(pos)

% ===== Initial Value
x = pos(1);
y = pos(2);
z = pos(3);
GM = 3.986005 * 10^14;      % m^3/s^2

r = sqrt(x^2 + y^2 + z^2);

% ===== Calculate Acceleration
ax = -GM*x/r^3;
ay = y/x * ax;
az = -GM*z/r^3;

% ===== Result of Keplerian Motion
a = [pos(4: 6) ax ay az];

end

