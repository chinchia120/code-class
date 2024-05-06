% Global constants of the relevant parameters
%
% Earth's rotation rate(See GPS Satellite Surveying,page 75)
% omega = 0.000072921151467 rad/s (JPL uses 0.00007292115 rad/s)
%
% Speed of light
% c = 299792458 m/sec
% 
% Frequency on L1 & L2
% f1 = 1575.42*10^6 Hz
% f2 = 1227.6 *10^6 Hz
%
% Wavelength on L1 & L2
% lamda1 = c/f1 = 0.19 m
% lamda2 = c/f2 = 0.244 m
% 
% Wide-Lane wavelength
% lamdaWL = c/(f1-f2) = 0.682 m
%
% Ionospheric wavelength
% lamdaIono = c/f2-c/f1 = 0.054 m
%
% cf1 = f1^2/(f1^2-f2^2)
% cf2 = f2^2/(f1^2-f2^2)
% cf1f2 = (f1*f2)/(f1^2-f2^2)
%
% If data not available in SP3
% NAJ = 999999.999999
% If data not available in RINEX
% NA = -9999
%
% Ellipsoid semimajor axis
% aell = 6378137
% Ellipsoid flattening
% fell = 1/298.257223563
%
% Satellite mask angle
% maskangle = 15 degrees
%
% Written by  Phakphong Homniam

% Original Mathcad source code by Boonsap Witchayangkoon, 2000

global omega c f1 f2 lamda1 lamda2 lamdaWL lamdaIono cf1 cf2 cf1f2 NAJ NA aell fell deg maskangle
omega = 0.000072921151467;
c = 299792458;
f1 = 1575.42*10^6;
f2 = 1227.6 *10^6;
lamda1 = c/f1;
lamda2 = c/f2;
lamdaWL = c/(f1-f2);
lamdaIono = c/f2-c/f1;
cf1 = f1^2/(f1^2-f2^2);
cf2 = f2^2/(f1^2-f2^2);
cf1f2 = (f1*f2)/(f1^2-f2^2);
NAJ = 999999.999999;
NA = -9999;
aell = 6378137;
fell = 1/298.257223563;
deg = pi/180;
maskangle = 15*deg;

%%%%%%%%%%END%%%%%%%%%%