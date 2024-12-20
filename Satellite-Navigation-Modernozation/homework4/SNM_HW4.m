%% ========== Setup ========== %%
% ===== Setup
clc; clear; close all;
format long;

% ===== Reference IS-GPS-200M
% https://www.gps.gov/technical/icwg/IS-GPS-200M.pdf

% ===== Initial Value
c = 299792458;              % the speed of light (m/s)
wedot = 7.2921151467 * 10^-5;   % earth rotation rate
GM = 3.986005 * 10^14;      % gravitation constant
F = -4.442807633 * 10^-10;  % relativistic correction term constant
init_wgs84_xyz = [-2950000; 5070000; 2470000];

% ===== Read Data
rcvr = RcvrDataReader('DataFile_hw4/rcvr.dat');
eph = EphDataReader('DataFile_hw4/eph.dat');

%% ========== Clock Error Correction ========== %%
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
    % Ek = Mk + eph.e.*sin(Ek);

    d_Ek = Ek-tmp;
end

% ===== True Anomaly
vk = 2 * atan(sqrt((1+eph.e)./(1-eph.e)) .* tan(Ek./2));

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
xk_o = rk .* cos(uk);
yk_o = rk .* sin(uk);

% ===== Corrected Longitude of Ascending Node
omgk = eph.omg0 + (eph.odot-wedot).*tk - wedot.*eph.toe;

% ===== Earth-Fixed Geocentric Satellite Coordinate
xk = xk_o.*cos(omgk) - yk_o.*sin(omgk).*cos(ik);
yk = xk_o.*sin(omgk) + yk_o.*cos(omgk).*cos(ik);
zk = yk_o.*sin(ik);
wgs84_xyz = [xk yk zk];

% ===== Satellite Broadcast Clock Error
d_tr = F .* eph.e .* eph.sqrta .* sin(Ek);
d_tsv = eph.af0 + eph.af1.*tk + eph.af2.*tk.^2 + d_tr;

%% ========== Tropospheric Delay Correction ========== %%
% ===== Initial Position
init_lla = wgsxyz2lla(init_wgs84_xyz);

% ===== Calculate the Vector of Satellite to Receiver in ENU
sv_enu = zeros(length(rcvr.svid), 3);
for i = 1: length(sv_enu)
    sv_enu(i, :) = wgsxyz2enu(wgs84_xyz(i)-init_wgs84_xyz, init_lla(1), init_lla(2), init_lla(3));
end

% ===== Elevation Angle
elevation_angle = atan2(sv_enu(:, 3), norm(sv_enu(:, 1:2)));

% ===== Zenith Angle
z = pi - elevation_angle;

% ===== Standard Temperature and Pressure
P0 = 1013.25; % Partial Pressure of Dry Air (mbars)
T0 = 273.15; % Temperature (K)
e0 = 6; % Partial Pressure of Water Vapor (mbars)

% ===== Tropospheric Delay - Saastamoinen Model
tro = 0.002277 ./ cos(z) .* (P0+((1255/T0)+0.05)*e0-tand(z).^2);

% ===== Tropospheric Delay - Hopfield Model
tro = 77.6*10^-6*P0*43/(5*T0) + 0.373*e0*12/(5*T0^2);

%% ========== Earth Rotation Correction ========== %%
transmit_time = (rcvr.pr+c*d_tsv+tro) / c;

sv_enu_ro = zeros(length(rcvr.svid), 3);
for i = 1: length(sv_enu_ro)
    theta = wedot * transmit_time(i);
    R = [ cos(theta), sin(theta), 0;
         -sin(theta), cos(theta), 0;
                   0,          0, 1];
    sv_enu_ro(i, :) = R * wgs84_xyz(i, :)';
end

%% ========== Satellite Position ========== %%
Satellite_xyz.PRN = rcvr.svid;
Satellite_xyz.X = sv_enu_ro(:, 1);
Satellite_xyz.Y = sv_enu_ro(:, 2);
Satellite_xyz.Z = sv_enu_ro(:, 3);
SatellitePos = struct2table(Satellite_xyz)

%% ========== Calculate Receiver Position ========== %%
syms x y z b

F = sqrt((x-sv_enu_ro(:, 1)).^2 + (y-sv_enu_ro(:, 2)).^2 + (z-sv_enu_ro(:, 3)).^2) + b;

A = jacobian(F, [x; y; z; b]);
L = rcvr.pr + c*d_tsv + tro;
X = F;

it = 1;
while 1
    if it == 1; xyzb = [init_wgs84_xyz; 0]; end
    
    X_ = double(subs(X, [x y z b], xyzb'));
    
    W = L - X_;
    A_ = double(subs(A, [x y z b], xyzb'));
    d = (A_'*A_)\A_'*W;

    xyzb = xyzb + d;

    it = it + 1;

    if max(abs(W)) < 10^-6; break; end
    if it > 50; break; end
end

%% ========== Receiver Position ========== %%
% ===== Receiver Position - XYZ
ReceiverPos_xyz.X = xyzb(1);
ReceiverPos_xyz.Y = xyzb(2);
ReceiverPos_xyz.Z = xyzb(3);
ReceiverPos_xyz.b_m = xyzb(4);
ReceiverPos_xyz.b_s = xyzb(4)/c;
ReceiverPos_xyz = struct2table(ReceiverPos_xyz)

% ===== Receiver Position - LLA
receiver_lla = wgsxyz2lla(xyzb(1: 3));
ReceiverPos_lla.Lat = receiver_lla(1);
ReceiverPos_lla.Lon = receiver_lla(2);
ReceiverPos_lla.Alt = receiver_lla(3);
ReceiverPos_lla = struct2table(ReceiverPos_lla)

%% ========== Receiver Time ========== %%
EStimated_Range = double(subs(F, [x y z b], xyzb'));
ReceiverTime.Time = t + EStimated_Range/c - d_tsv - tro/c;
ReceiverTime = struct2table(ReceiverTime)