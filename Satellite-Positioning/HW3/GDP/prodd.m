function L = prodd(d,Fx,NA)

% Calculate LG Denomenator. See eq. (13)
% d is number of data points used in LG
% Fx = tabulated satellite ephemeris & clock, vector of size d
%
% Written by  Phakphong Homniam
% September 13, 2002
% Original Mathcad source code by Boonsap Witchayangkoon, 2000

Fx = Fx(:);

x(1,1) = 1;
L = ones(d,1);
for a = 1:d-1
    x(a+1,1) = x(a,1)+1;
end
for i = 1:d
    if Fx(i,1) ~= NA
        for j = 1:d
            if (j ~= i) & (Fx(j,1) ~= NA)
                L(i,1) = L(i,1)*(x(i,1)-x(j,1));
            end
        end
    end
end

L = L(:);
%%%%%%%%%%END%%%%%%%%%%