% Compute latitude and longitude from the quaternion (q_ne)
% representing the attitude of the navigation frame
% Eun-Hwan Shin, Jan 2004.
%----------------------------------------------------
% function [lat, lon] = quat2pos(q_ne)
function [lat, lon] = quat2pos(q_ne)

% Through DCM
%C_ne = quat2dcm(q_ne);
%[lat, lon] = dcm2pos(C_ne);

% Direct computation
lat = -2*atan(q_ne(3)/q_ne(1))-pi/2;
lon = 2*atan2(q_ne(4), q_ne(1));