%% ========== Setup ========== %%
% ===== Setup
clc; clear; close all;

% ===== Initial value
c = 299792458; % the speed of light

%% ========== Question 1 ========== %%
% ===== Q1-(a)
dT = (1000-1050)/(2*c);
true_range_PL1 = 550+c*dT;
true_range_PL2 = 500+c*dT;

clearvars dT true_range_PL1 true_range_PL2;
% ===== Q1-(b)
dT = (1000-1800)/(2*c)
true_range_PL1 = 400+c*dT
true_range_PL2 = 1400+c*dT

clearvars dT true_range_PL1 true_range_PL2;

%% ========== Question 2 ========== %%
% ===== Q2-(a)
min = 1 * 56/50;
max = 2 * 56/50;
pos_min = 56 - max
pos_max = 56 + max


