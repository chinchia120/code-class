function LLG = LG(d,stdT,Fx,NA)

% Lagrange(LG) Interpolation Polynomial. Eq.(13)
% d is number of data points used in LG
% stdT = standardized time; computed in subroutine X
% Fx = tabulated satellite ephemeris & clock; vector of size d
% Want to Return NA or Input function if empty
%
% Written by  Phakphong Homniam

% Original Mathcad source code by Boonsap Witchayangkoon, 2000

if size(Fx,1) == 1
    LLG = NA;
    return
elseif d < 2
    
    fprintf('Err: Degree of interpolation must more than 2.\n');
    return
elseif size(Fx,1) ~= d
    fprintf('Err: Fx must has the same point as d.\n');
    return
end
numNA = 0;
rowFx = size(Fx,1);
for s = 1:rowFx
    if Fx(s,1) == NA
        numNA = numNA+1;
    end
end
if numNA > ceil(0.3*rowFx)
    fprintf('Too many orbit NA in SP3 data.\n');
    LLG = NA;
    return
end
LLG = zeros(d,1);
nLG = ones(d,1);
dLG = prodd(d,Fx,NA);
x(1,1) = 1;
for a = 1:d-1
    x(a+1,1) = x(a,1)+1;
end
for i = 1:d
    if Fx(i,1) ~= NA
        for j = 1:d
            if Fx(j,1) ~= NA & i ~= j
                nLG(i,1) = nLG(i,1)*(stdT-x(j,1));
            end
        end
        LLG(i,1) = nLG(i,1)/dLG(i,1);
    end
end
LLG = LLG'*Fx;
%%%%%%%%%%END%%%%%%%%%%