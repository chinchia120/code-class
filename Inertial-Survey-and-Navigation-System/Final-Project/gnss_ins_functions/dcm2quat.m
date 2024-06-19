% Direction Cosine Matrix to Quaternion
% by Eun-Hwan Shin, June 27, 2003
% referred to Savage, P.G. (2000). Strapdown Analytics: Part 1, 
%    Strapdown Associates, Inc., Maple Plain, Minnesota, p. 3-46.
%---------
% function q = dcm2quat(C)
%
function q = dcm2quat(C)
Tr = trace(C);
Pq = zeros(4,1);
Pq(1) = 1 + Tr;
Pq(2) = 1 + 2*C(1,1) - Tr;
Pq(3) = 1 + 2*C(2,2) - Tr;
Pq(4) = 1 + 2*C(3,3) - Tr;

max_id = 1;
for i=2:4,
    if Pq(i) > Pq(max_id)
        max_id = i;
    end
end

q = zeros(4,1);
switch max_id
case 1
    q(1) = 0.5 * sqrt(Pq(1)); 
    q(2) = (C(3,2) - C(2,3))/4/q(1);
    q(3) = (C(1,3) - C(3,1))/4/q(1);
    q(4) = (C(2,1) - C(1,2))/4/q(1);
case 2
    q(2) = 0.5 * sqrt(Pq(2));
    q(1) = (C(3,2) - C(2,3))/4/q(2);
    q(3) = (C(2,1) + C(1,2))/4/q(2);
    q(4) = (C(1,3) + C(3,1))/4/q(2);
case 3
    q(3) = 0.5 * sqrt(Pq(3));
    q(1) = (C(1,3) - C(3,1))/4/q(3);
    q(2) = (C(2,1) + C(1,2))/4/q(3);
    q(4) = (C(3,2) + C(2,3))/4/q(3);
case 4
    q(4) = 0.5 * sqrt(Pq(4));
    q(1) = (C(2,1) - C(1,2))/4/q(4);
    q(2) = (C(1,3) + C(3,1))/4/q(4);
    q(3) = (C(3,2) + C(2,3))/4/q(4);
end
    
if q(1) < 0
    q = -q;
end