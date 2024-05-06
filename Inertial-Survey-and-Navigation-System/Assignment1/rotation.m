%% ========== Setup ========== %%
clc;
clear;
close all;

%% ========== Question 2 ========== %%
roll = -78.683; pitch = 47.165; yaw = -168.699;
rotm2 = eul2rotm(deg2rad([yaw, pitch, roll]), 'ZYX');
quat2 = eul2quat(deg2rad([yaw, pitch, roll]), 'ZYX');

%% Test Q2
% rotm2 = Rz(deg2rad(yaw))*Ry(deg2rad(pitch))*Rx(deg2rad(roll));
% quat2 = Quaternion(rotm2);

%% ========== Question 3 ========== %%
q0 = 0.3062; q1 = 0.5303; q2 = 0.0474; q3 = 0.7891;
rotm3 = quat2rotm([q0, q1, q2, q3]);
eul3  = rad2deg(quat2eul([q0, q1, q2, q3], 'ZYX'));

%% Test Q3
% quat3 = eul2quat(deg2rad([eul3(1), eul3(2), eul3(3)]), 'ZYX');
% rotm3 = eul2rotm(deg2rad([eul3(1), eul3(2), eul3(3)]), 'ZYX');
% quat3 = Quaternion(rotm3);

%% ========== Question 4 ========== %%
syms w p k;
roll = 90-w; pitch = p; yaw = 180-k;
R = Rz(yaw)*Ry(pitch)*Rx(roll);

rz = [-cos(k), -sin(k), 0;
       sin(k), -cos(k), 0;
            0,       0, 1];
ry = Ry(p);
rx = [1,      0,       0;
      0, sin(w), -cos(w);
      0, cos(w),  sin(w)];
r = rz*ry*rx;

%% ========== Rotation Matrix ========== %%
function [R] = Rx(roll)
    R = [1,        0,         0;
         0, cos(roll), -sin(roll);
         0, sin(roll),  cos(roll)];
end

function [R] = Ry(pitch)
    R = [ cos(pitch), 0, sin(pitch);
                   0, 1,          0;
         -sin(pitch), 0, cos(pitch)];
end

function [R] = Rz(yaw)
    R = [cos(yaw), -sin(yaw), 0;
         sin(yaw),  cos(yaw), 0;
                 0,        0, 1];
end

function [Q] = Quaternion(DCM)
    q0 = 1/2*sqrt(1+DCM(1,1)+DCM(2,2)+DCM(3,3));
    Q = [q0;
         1/4/q0*(DCM(3,2)-DCM(2,3));
         1/4/q0*(DCM(1,3)-DCM(3,1));
         1/4/q0*(DCM(2,1)-DCM(1,2))];
end
