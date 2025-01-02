function out = BaseCoorection(rcvr_dat, eph_dat)
% out = [GPSTime PRN RecPr RecCB SatPos_X SatPos_Y SatPos_Z];
%% ========== Read Data ========== %%
rcvr = RcvrDataReader(rcvr_dat);
eph = EphDataReader(eph_dat);

%% ========== Check the Satellite Number ========== %%
if length(rcvr.svid) < 4; out = []; return; end 

%% ========== Satellite Position ========== %%
out = SatellitePos(rcvr_dat, eph_dat);
t = out(:, 1);
d_tsv = out(:, 2);
wgs84_xyz = out(:, 3:5);

%% ========== Tropospheric Delay Correction ========== %%
% ===== Standard Temperature and Pressure
P0 = 1013.25;   % Partial Pressure of Dry Air (mbars)
T0 = 273.15;    % Temperature (K)
e0 = 6;         % Partial Pressure of Water Vapor (mbars)

% ===== Tropospheric Delay - Hopfield Model
tro = 77.6*10^-6*P0*43/(5*T0) + 0.373*e0*12/(5*T0^2);

%% ========== Earth Rotation Correction ========== %%
% transmit_time = (rcvr.pr+GPSConstant.c*d_tsv+tro) / GPSConstant.c;
% 
% sv_enu_ro = zeros(length(rcvr.svid), 3);
% for i = 1: length(sv_enu_ro)
%     theta = GPSConstant.wedot * transmit_time(i);
%     R = [ cos(theta), sin(theta), 0;
%          -sin(theta), cos(theta), 0;
%                    0,          0, 1];
%     sv_enu_ro(i, :) = R * wgs84_xyz(i, :)';
% end
sv_enu_ro = wgs84_xyz;

%% ========== Calculate Receiver Position ========== %%
% ===== Initial Guess
init_wgs84_xyz = [-2950000; 5070000; 2470000];

% ===== Least Square Estimation
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

% ===== Clock Bias
receiverClockBias = repmat(xyzb(4), length(rcvr.svid), 1);

%% ========== Output Data ========== %%
out = [t rcvr.svid rcvr.pr receiverClockBias wgs84_xyz];

end

