% Quaternion to Direction Cosine Matrix
% by Eun-Hwan Shin, June 27, 2003
% referred to Savage, P.G. (2000). Strapdown Analytics: Part 1, 
%    Strapdown Associates, Inc., Maple Plain, Minnesota, p. 3-46.
%---------
% function C = quat2dcm(q)
%
function C = quat2dcm(q)
C = zeros(3);
C(1,1) = q(1)^2 + q(2)^2 - q(3)^2 - q(4)^2;
C(1,2) = 2*(q(2)*q(3) - q(1)*q(4));
C(1,3) = 2*(q(2)*q(4) + q(1)*q(3));
C(2,1) = 2*(q(2)*q(3) + q(1)*q(4));
C(2,2) = q(1)^2 - q(2)^2 + q(3)^2 - q(4)^2;
C(2,3) = 2*(q(3)*q(4) - q(1)*q(2));
C(3,1) = 2*(q(2)*q(4) - q(1)*q(3));
C(3,2) = 2*(q(3)*q(4) + q(1)*q(2));
C(3,3) = q(1)^2 - q(2)^2 - q(3)^2 + q(4)^2;