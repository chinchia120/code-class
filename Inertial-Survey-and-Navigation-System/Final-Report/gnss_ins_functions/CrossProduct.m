%
% Cross product of two vectors (c = a x b)
% by Eun-Hwan Shin, 2001
% function c = CrossProduct(a, b)
%
function c = CrossProduct(a, b)
c = zeros(3,1);
c(1) = a(2)*b(3) - b(2)*a(3);
c(2) = b(1)*a(3) - a(1)*b(3);
c(3) = a(1)*b(2) - b(1)*a(2);

