function [sphe] = xyz2sphe(pos)

% ===== Initial Value
x = pos(1);
y = pos(2);
z = pos(3);
    
% ===== Calculate Acceleration
a = atand(y / x);
d = atand(z / sqrt(x^2+y^2));

% ===== Result of Spherical Coordinate
sphe = [a d];
    
end