% Compute the quaternion (q_ne) representing 
% the attitude of the navigation frame
% Eun Hwan Shin, Jan 2004.
%-----------------------------------------------------
% function q_ne = pos2quat(lat, lon)
function q_ne = pos2quat(lat, lon)
s1 = sin(lon/2);
c1 = cos(lon/2);
s2 = sin(-pi/4-lat/2);
c2 = cos(-pi/4-lat/2);

q_ne = [c1 * c2; -s1 * s2; c1 * s2; c2 * s1];