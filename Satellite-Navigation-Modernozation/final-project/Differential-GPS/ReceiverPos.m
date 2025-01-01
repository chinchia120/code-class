function out = ReceiverPos(rcvr_dat, eph_dat, pr_cor)
% out = [RecTime RecPos_Lat RecePos_Lon RecPos_Alt RecClockBias SatNum EDOP NDOP VDOP TDOP]
%% ========== Read Data ========== %%
rcvr = RcvrDataReader(rcvr_dat);
eph = EphDataReader(eph_dat);

%% ========== Check the Satellite Number ========== %%
if length(rcvr.svid) < 4; out = []; return; end 

%% ========== Satellite Position ========== %%
out = SatellitePos(rcvr_dat, eph_dat);
t = out(:, 1);
d_tsv = out(:, 4);
wgs84_xyz = out(:, 5:7);

%% ========== Correction Time ========== %%
PrCor = [];
for i = 1:size(pr_cor, 1)
    tmp = pr_cor{i};
    if fix(mean(tmp(:, 1))) == fix(mean(t(:, 1)))
        PrCor = tmp;
        break; 
    end
end

%% ========== Tropospheric Delay Correction ========== %%
% ===== Standard Temperature and Pressure
P0 = 1013.25;   % Partial Pressure of Dry Air (mbars)
T0 = 273.15;    % Temperature (K)
e0 = 6;         % Partial Pressure of Water Vapor (mbars)

% ===== Tropospheric Delay - Hopfield Model
tro = 77.6*10^-6*P0*43/(5*T0) + 0.373*e0*12/(5*T0^2);

%% ========== Pseudorange Correction ========== %%
for i = 1: length(rcvr.svid)
    flag = 0;
    for j = 1: length(PrCor)
        if rcvr.svid(i) == PrCor(j, 2)
            rcvr.pr(i) = rcvr.pr(i) + PrCor(j, 3) - GPSConstant.c*d_tsv(i);
            flag = 1;
            break;
        end
    end

    if flag == 0
        rcvr.pr(i) = rcvr.pr(i) + GPSConstant.c*d_tsv(i) + tro;
    end
end

%% ========== Earth Rotation Correction ========== %%
% transmit_time = rcvr.pr / GPSConstant.c;
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
L = rcvr.pr;
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
    if it > 10
        out = [];
        return; 
    end
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
H = double(subs(A, [x y z b], xyzb'));
H_ECEF = inv(H'*H);
EDOP = sqrt(H_ECEF(1, 1));
NDOP = sqrt(H_ECEF(2, 2));
VDOP = sqrt(H_ECEF(3, 3));
TDOP = sqrt(H_ECEF(4, 4));

DOP = [EDOP NDOP VDOP TDOP];

%% ========== Return Value ========== %%
out = [ReceiverInfo length(rcvr.svid) DOP];

end