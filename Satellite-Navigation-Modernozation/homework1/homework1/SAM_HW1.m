%% ========== Setup ========== %%
% ===== Setup
clc; clear; close all;

%% ========== Question 1 ========== %%
% ===== Initial value
c = 299792458; % the speed of light (m/s)

% ===== Q1-(a)
dT = (1000-1050)/(2*c);
true_range_PL1 = 550+c*dT;
true_range_PL2 = 500+c*dT;

% ===== Q1-(b)
dT = (1000-1800)/(2*c);
true_range_PL1 = 400+c*dT;
true_range_PL2 = 1400+c*dT;

%% ========== Question 2 ========== %%
% ===== Q2-(a)
min = 1 * 56/50;
max = 2 * 56/50;
pos_avg = 56;
pos_min = 56 - max;
pos_max = 56 + max;

% ===== Q2-(b)
v_r = 3; % velocity of bus (km/min) 
t_r = 21; % travel time (min)
S_ax = v_r * t_r;

% ===== Q2-(c)
b_avg = pos_avg/v_r - t_r;
b_min = pos_min/v_r - t_r;
b_max = pos_max/v_r - t_r;

% ===== Q2-(d)
v_b = 2.5;
t_b = 25;
S_bx = v_b * t_b;

b = (120-S_ax-S_bx)/(v_r+v_b);

%% ========== Question 3 ========== %%
% ===== Initial value
rwy30Start = [-2694685.473; 
              -4293642.366; 
               3857878.924];

rwy30End = [-2694892.460;
            -4293083.225;
             3858353.437];

% ===== Q3-(a)
rwy30Start_llh_rad = xyz2llh(rwy30Start);
rwy30Start_ll_deg = [rad2deg(rwy30Start_llh_rad(1: 2))];
rwy30Start_h_m = rwy30Start_llh_rad(3);

% ===== Q3-(b)
rwy30Start_ll_dms = [degrees2dms(rwy30Start_ll_deg)];

% ===== Q3-(c)
N = -33;
h = rwy30Start_h_m;
H = h - N; % meter

FAA_ft = 3; % feet
FAA_m = convlength(FAA_ft, 'ft', 'm');

diff_H_FAA = H - FAA_m;

% ===== Q3-(d)
enu = xyz2enu(rwy30End, rwy30Start);

% ===== Q3-(e)
l_m = sqrt(enu(1)^2 + enu(2)^2 + enu(3)^2);
l_ft = convlength(l_m, 'm', 'ft');

% ===== Q3-(f)
heading = atan2d(enu(1), enu(2)) + 360;
heading_true = 315;
diff_heading = heading_true - heading;

% ===== Q3-(g)
gradiant_rad = atan(enu(3) / sqrt(enu(1)^2+enu(2)^2));
gradiant_deg = rad2deg(gradiant_rad);