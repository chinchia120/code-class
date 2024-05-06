function [trodel] = saast(el,tcel,p,h)
% -----------------------------------------------------------------------------
%
% Correction of the tropospheric refraction following the model of 
% Saastamoinen Model (Simplified)
%
% How: [tro_p] = tropo_sa(zen,tcel,p,h);
% Input:   el    [degree]    Elevation angle of the satellite,
%                            corrected by aberration (earth rotation)
%          tcel [Celsius]    Temperature at the station
%          p       [mbar]    Absolute Atmospheric Pressure
%          h          [%]    Relative Humidity
%
% Output:  trodel     [m]    Tropospheric path delay(correction)
%                            between receiver and satellite
%
% -----------------------------------------------------------------------------
%
% Calculate cosine(ele)
d2r = pi/180;
sin_el = sin(el*d2r);

% Transform the unit of temperature t from Kelvin to Celsius
tkel = tcel + 273.15;

% Partial pressure of water vapour
e = h*exp(-37.2465 + 0.213166*tkel - 0.000256908*tkel^2);

% Zenithal Delay
trodel_z = 0.002277*(p + (1255/kel + 0.05)*e);

% Mapping to actual path delay by zenith angle
trodel = trodel_z/sin_el;

% end