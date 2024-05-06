function [svxyz,Ek] = svposeph(eph,tot)
%%  Calculate the position of the satellite using ephemeris data
%
%   INPUTS
%   eph = ephemeris information.
%	tot = time at which to evaluate satellite position (in seconds)
%
%   OUTPUTS
%	svxyz(1,1) = ECEF x-coordinate of satellite in meters
%	svxyz(2,1) = ECEF y-coordinate of satellite in meters
%	svxyz(3,1) = ECEF z-coordinate of satellite in meters
%   Ek = Eccentric anomaly
%
if nargin < 2, error('insufficient number of input arguments'),end

TOE      = eph(2);
SQRTSMA  = eph(3);
DELTAN   = eph(4);
M0       = eph(5);
ECCEN    = eph(6);
ARGPERI  = eph(7);
CUS      = eph(8);
CUC      = eph(9);
CRS      = eph(10);
CRC      = eph(11);
CIS      = eph(12);
CIC      = eph(13);
I0       = eph(14);
IDOT     = eph(15);
OMEGA0   = eph(16);
OMEGADOT = eph(17);

    % 地球宇宙重力常數
    mu = 3.986005e14;
    % 地球自轉速率
    OMGedot = 7.2921151467e-5;
    % 計算相對於星曆參考時間TOE之時差
    tk = tot - TOE;
    tk = chk_time(tk);

    A = SQRTSMA^2;
    n_o = sqrt(mu/(A*A*A));
    % 改正之平運動量
    n = n_o + DELTAN;
    % 平近點角
    Mk = M0 + n*tk;

    % 迭代計算偏近點角
    Ek = Mk; sep = 1; oldEk = Ek;
    iter = 0;
    while sep > 1e-13,
        Ek = Mk + ECCEN*sin(Ek);
        sep = abs(Ek - oldEk);
        oldEk = Ek;
        iter = iter + 1;
        if iter > 10, break, end
    end

    % 計算真近點角
    sin_nu_k = ( (sqrt(1-ECCEN*ECCEN))*sin(Ek) )/( 1 - ECCEN*cos(Ek) );
    cos_nu_k = ( cos(Ek) - ECCEN )/( 1 - ECCEN*cos(Ek) );
    nu_k = atan2(sin_nu_k,cos_nu_k);

    % 緯度幅角
    PHIk = nu_k + ARGPERI;

    c2 = cos(2*PHIk);
    s2 = sin(2*PHIk);
    delta_uk = CUS*s2 + CUC*c2;
    delta_rk = CRS*s2 + CRC*c2;
    delta_ik = CIS*s2 + CIC*c2;

    % 改正之緯度幅角
    uk = PHIk + delta_uk;
    % 改正之軌道半徑
    rk = A*(1-ECCEN*cos(Ek)) + delta_rk;
    % 改正之軌道傾角
    ik = I0 + delta_ik + IDOT*tk;

    % 計算軌道平面上之位置
    ip(1) = rk*cos(uk);    % satellite position In orbital Plane
    ip(2) = rk*sin(uk);

    % 改正之升交點赤經
    OMGk = OMEGA0 + (OMEGADOT-OMGedot)*tk - OMGedot*TOE;

    % 計算ECEF衛星坐標
    cosomg = cos(OMGk);
    sinomg = sin(OMGk);
    cosi = cos(ik);
    
    svxyz = [cosomg*ip(1)-cosi*sinomg*ip(2)
             sinomg*ip(1)+cosi*cosomg*ip(2)
                              sin(ik)*ip(2)];
%     ROT = [cosomg  -cosi*sinomg; ...
%            sinomg   cosi*cosomg; ...
%                 0      sin(ik)];
       	
%%%% END OF SVPOSEPH %%%%%
