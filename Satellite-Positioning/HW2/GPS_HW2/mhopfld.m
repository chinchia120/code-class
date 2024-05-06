function trodel = mhopfld(el,hsta,p,tcel,hum,hp,htkel,hhum)
%   Calculation of tropospheric correction.
%   The correction "trodel" is to be subtracted from
%   pseudo-ranges and carrier phases
%
% ======================================================================
%   ABSTRACT :
%   This is modified Hopfield model discussed by Goad an Goodman
%   in 1974 except it has been augmented to allow station height
%   and  heights  for  the  pressure, temperature, and  humidity
%   measurements to be at any height rather than sea-level.
% ======================================================================
%   PARAMETER  UNIT       I/O  DESCRIPTION
% ----------------------------------------------------------------------
%   el         [degree]    I   elevation of satellite
%   hsta       [km]        I   height of station 
%   p          [mbar]      I   atmospheric pressure at height hp
%   tcel       [celsius]   I   surface temperature at height htkel
%   hum        [%]         I   humidity at height hhum
%   hp         [km]        I   height of pressure measurement
%   htkel      [km]        I   height of temperature measurement
%   hhum       [km]        I   height of humidity measurement
%   trodel     [m]         O   tropospheric path delay
% ======================================================================
%
third = 0.333333333333333;
a_e = 6378.137;         % semi-major axis of earth ellipsoid [km]
b0 = 7.839257e-5;
tlapse = -6.5;          % temperature descent in degree/km
d2r = pi/180;           % degree to radian
sinel = sin(el*d2r);
toff = 273.15;          % offset between Kelvin and Celsius
tkel = tcel + toff;     % transform unit from Kelvin to Celsius
% Compute temperature at height of humidity meas
tkhum = tkel + tlapse*(hhum - htkel);
atkel = 7.5*(tkhum - toff)/(237.3 + tkhum - toff);
% Compute partial pressure of water vapor
% at height of relative humidity reading 
e0 = 0.0611*hum*10^atkel;
% Compute sea-level values of pressure, temperature, humidity
tksea = tkel-tlapse*htkel;
em = -978.77/(2.8704e6*tlapse*1.0e-5);
% Compute temperature at height of relative humidity reading
tkelh = tksea + tlapse*hhum;
e0sea = e0*(tksea/tkelh)^(4*em);
% Compute temperature at height of pressure reading
tkelp = tksea + tlapse*hp;
psea = p*(tksea/tkelp)^em;
% check to see if geometry is crazy
if sinel < 0 | el > 90, 
    trodel = 0;
    return;
end;
cos2 = 1 - sinel*sinel;
tropo = 0;
done = 'FALSE';
% Compute dry parameters
refsea = 77.624e-6/tksea;
htop = 1.1385e-5/refsea;
refsea = refsea*psea;
ref = refsea*((htop - hsta)/htop)^4;
while 1
   % compute slant range to top of troposphere
   rtop = (a_e + htop)^2 - (a_e + hsta)^2*cos2;
   % check to see if geometry is crazy
   if rtop < 0, rtop = 0; end;
   rtop = sqrt(rtop) - (a_e + hsta)*sinel;
   a = -sinel/(htop - hsta);
   b = -b0*cos2/(htop - hsta);
   a2 = a*a;
   b2 = b*b;
   ab = a*b;
   twob = b + b;
   fourb = twob + twob;
   alpha(2) = a + a;
   alpha(3) = a2 + a2 + fourb*third;
   alpha(4) = a*(a2 + fourb - b);
   alpha(5) = 0.2*a2*a2 + 2.4*a2*b + 1.2*b2;
   alpha(6) = twob*alpha(4)*third;
   alpha(7) = b2*(6*a2 + fourb)*1.42857142857143e-1;
   alpha(8) = 0;
   alpha(9) = 0;
   if b2 > 1.0e-35, 
       alpha(8) = 0.5*ab*b2; 
       alpha(9) = (b2*third)^2; 
   end;
   rn(1) = rtop;
   for i = 1:8,
      rn(i+1) = rn(i)*rtop; 
   end;
   dr = rtop;
   for k = 2:9,
       dr = dr + alpha(k)*rn(k);
   end
   tropo = tropo + dr*ref*1000;
   if done == 'TRUE ', trodel = tropo; break; end;
   done = 'TRUE ';
   refsea = (371900.0e-6/tksea - 12.92e-6)/tksea;
   htop = 1.1385e-5*(1255/tksea + 0.05)/refsea;
   ref = refsea*e0sea*((htop - hsta)/htop)^4;
end;
%%%%%%%%% end mhopfld.m  %%%%%%%%%%%%%%%%%%%
