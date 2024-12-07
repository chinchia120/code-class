%% ========== Setup ========== %%
% ===== Setup
clc; clear; close all;

% ===== Creat Output Folder
OutputFolder = sprintf('OutputFigure');
if ~exist(OutputFolder, 'dir'); mkdir(OutputFolder); end

% ===== Initial Value
c = 299792458;              % the speed of light (m/s)
wedot = 7.2921151467 * 10^-5;   % earth rotation rate
GM = 3.986005 * 10^14;      % gravitation constant
F = -4.442807633 * 10^-10;  % relativistic correction term constant
init_wgs84_xyz = [-2950000; 5070000; 2470000];

%% ========== Problem ========== %%
% ===== Read Data
rcvr = RcvrDataReader('DataFile_hw4/rcvr.dat');
eph = EphDataReader('DataFile_hw4/eph.dat');

% ===== GPS System Time
t = rcvr.rcvr_tow - rcvr.pr / c;

% ===== Ephemeris Reference Epoch
tk = t - eph.toe;

% ===== Mean Motion
n0 = sqrt(GM./eph.sqrta.^2.^3);

% ===== Corrected Mean Motion
n = n0 + eph.dn;

% ===== Mean Anomaly
Mk = eph.m0 + n.*tk;

% ===== Kepler's Equation of Eccentric Anomaly
Ek = Mk;
d_Ek = 100;
while min(abs(d_Ek)) > 10^-12
    tmp = Ek;
    Ek = Ek + ((Mk-Ek+eph.e.*sin(Ek)) ./ (1-eph.e.*cos(Ek)));

    d_Ek = Ek-tmp;
end

% ===== True Anomaly
vk = 2 * atan(sqrt((1+eph.e)./(1-eph.e)) ./ (1-eph.e.*cos(Ek)));

% ===== Argument of Latitude
Phi = vk + eph.w;

% ===== Argument of Latitude Correction
d_uk = eph.cuc.*cos(2*Phi) + eph.cus.*sin(2*Phi);
uk = Phi + d_uk;

% ===== Radius Correction
d_rk = eph.crc.*cos(2*Phi) + eph.crs.*sin(2*Phi);
rk = eph.sqrta.^2 .* (1- eph.e.*cos(Ek)) + d_rk;

% ===== Inclination Correction
d_ik= eph.cic.*cos(2*Phi) + eph.cis.*sin(2*Phi);
ik=eph.i0 + eph.idot.*tk + d_ik;

% ===== Position in Orbital Plane
Xk_o = rk .* cos(uk);
Yk_o = rk .* sin(uk);

% ===== Corrected Longitude of Ascending Node
omgk = eph.omg0 + (eph.odot-wedot).*tk - wedot.*eph.toe;

% ===== Earth-Fixed Geocentric Satellite Coordinate
Xk = Xk_o.*cos(omgk) - Yk_o.*sin(omgk).*cos(ik);
Yk = Xk_o.*sin(omgk) + Yk_o.*cos(omgk).*cos(ik);
Zk = Yk_o.*sin(ik);

% ===== Satellite Broadcast Clock Error
d_tr = F .* eph.e .* eph.sqrta .* sin(Ek);
d_tsv = eph.af0 + eph.af1.*tk + eph.af2.*tk.^2 + d_tr;

% ===== Initial Position
init_lla = wgsxyz2lla(init_wgs84_xyz);