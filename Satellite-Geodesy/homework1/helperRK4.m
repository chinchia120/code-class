function [pos] = helperRK4(pos, h, type)

% ===== Type 1: RK4 with Keplerian Motion
if type == 1
    k1 = helperKeplerian(pos);
    k2 = helperKeplerian(pos+h*k1/2);
    k3 = helperKeplerian(pos+h*k2/2);
    k4 = helperKeplerian(pos+h*k3);
end

% ===== Type 2: RK4 with Keplerian Motion and J2 Effect
if type == 2
    k1 = helperJ2(pos);
    k2 = helperJ2(pos+h*k1/2);
    k3 = helperJ2(pos+h*k2/2);
    k4 = helperJ2(pos+h*k3);
end

% ===== Result of RK4 Approximation
pos = pos + h/6*(k1 + 2*k2 + 2*k3 + k4);

end