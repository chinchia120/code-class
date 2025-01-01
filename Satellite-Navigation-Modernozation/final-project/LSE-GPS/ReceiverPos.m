function out = ReceiverPos(rcvr_dat, eph_dat)
% out = [RecTime RecPos_Lat RecePos_Lon RecPos_Alt RecClockBias SatNum EDOP NDOP VDOP TDOP]

%% ========== Initial Value ========== %%
init_wgs84_xyz = [-2950000; 5070000; 2470000];
ENUCenter = [-2956517.76926541 5076035.26024164 2476582.34767972];

%% ========== Read Data ========== %%
rcvr = RcvrDataReader(rcvr_dat);
eph = EphDataReader(eph_dat);

%% ========== Check the Satellite Number ========== %%
if length(rcvr.svid) < 4; out = []; return; end 

%% ========== Clock Error Correction ========== %%
% ===== GPS System Time
t = rcvr.rcvr_tow - rcvr.pr / GPSConstant.c;

% ===== Ephemeris Reference Epoch
tk = t - eph.toe;

% ===== Mean Motion
n0 = sqrt(GPSConstant.GM./eph.sqrta.^2.^3);

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
omgk = eph.omg0 + (eph.odot-GPSConstant.wedot).*tk - GPSConstant.wedot.*eph.toe;

% ===== Earth-Fixed Geocentric Satellite Coordinate
xk = xk_o.*cos(omgk) - yk_o.*sin(omgk).*cos(ik);
yk = xk_o.*sin(omgk) + yk_o.*cos(omgk).*cos(ik);
zk = yk_o.*sin(ik);
wgs84_xyz = [xk yk zk];

% ===== Satellite Broadcast Clock Error
d_tr = GPSConstant.F .* eph.e .* eph.sqrta .* sin(Ek);
d_tsv = eph.af0 + eph.af1.*tk + eph.af2.*tk.^2 + d_tr;

%% ========== Tropospheric Delay Correction ========== %%
% ===== Standard Temperature and Pressure
P0 = 1013.25;   % Partial Pressure of Dry Air (mbars)
T0 = 273.15;    % Temperature (K)
e0 = 6;         % Partial Pressure of Water Vapor (mbars)

% ===== Tropospheric Delay - Hopfield Model
tro = 77.6*10^-6*P0*43/(5*T0) + 0.373*e0*12/(5*T0^2);

%% ========== Earth Rotation Correction ========== %%
transmit_time = (rcvr.pr+GPSConstant.c*d_tsv+tro) / GPSConstant.c;

sv_enu_ro = zeros(length(rcvr.svid), 3);
for i = 1: length(sv_enu_ro)
    theta = GPSConstant.wedot * transmit_time(i);
    R = [ cos(theta), sin(theta), 0;
         -sin(theta), cos(theta), 0;
                   0,          0, 1];
    sv_enu_ro(i, :) = R * wgs84_xyz(i, :)';
end
% sv_enu_ro = wgs84_xyz;
%% ========== Calculate Receiver Position ========== %%
syms x y z b

F = sqrt((x-sv_enu_ro(:, 1)).^2 + (y-sv_enu_ro(:, 2)).^2 + (z-sv_enu_ro(:, 3)).^2) + b;

A = jacobian(F, [x; y; z; b]);
L = rcvr.pr + GPSConstant.c*d_tsv + tro;
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

    if max(abs(d)) < 10^-6; break; end
    if it > 50; break; end
end

%% ========== Receiver Time and Position ========== %%
% ===== Receiver Time
EStimated_Range = double(subs(F, [x y z b], xyzb'));
ReceiverTime = mean(t + EStimated_Range/GPSConstant.c - d_tsv - tro/GPSConstant.c);

% ===== Receiver Position - LLA
ReceiverPos = wgsxyz2lla(xyzb(1: 3))';

% ===== Reciver Clock Bias
ReceiverCB = xyzb(4)/GPSConstant.c;

ReceiverInfo = [ReceiverTime ReceiverPos ReceiverCB];

%% ========== DOP ========== %%
ENU = xyz2enu(xyzb(1:3), ENUCenter);
H = double(subs(A, [x y z b], [ENU' xyzb(4)]));
H_ECEF = inv(H'*H);
EDOP = sqrt(H_ECEF(1, 1));
NDOP = sqrt(H_ECEF(2, 2));
VDOP = sqrt(H_ECEF(3, 3));
TDOP = sqrt(H_ECEF(4, 4));

DOP = [EDOP NDOP VDOP TDOP];

%% ========== Return Value ========== %%
out = [ReceiverInfo length(rcvr.svid) DOP];

end