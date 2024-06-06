% function to normalize a quaternion vector
% referred to Savage (2000, p. 7-28)
% June 11, 2003, Eun-Hwan Shin
%-----------------
% function q_n = norm_quat(q)

function q_n = norm_quat(q)
e = (q'*q - 1)/2;            %[E.H.Shin, 2005, eq.2.64b, p.36] / the normality error in the quaternion
q_n = (1-e)*q;               %[E.H.Shin, 2005, eq.2.64a, p.36]