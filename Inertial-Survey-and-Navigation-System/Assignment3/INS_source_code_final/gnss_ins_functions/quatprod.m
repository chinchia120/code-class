% Product of Quaternions: q1 = q * p
% by Eun-Hwan Shin, July 2003.
% -----
% function q1 = quatprod(q, p)

function q1 = quatprod(q, p)
qs = q(1);
qv = [q(2) q(3) q(4)]';
ps = p(1);
pv = [p(2) p(3) p(4)]';
q1 = [ qs*ps-qv'*pv; qs*pv+ps*qv+CrossProduct(qv,pv)];

if q1(1) < 0
    q1 = -q1;
end
