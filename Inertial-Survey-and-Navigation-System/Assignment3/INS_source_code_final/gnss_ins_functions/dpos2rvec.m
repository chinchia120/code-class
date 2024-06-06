% Position error to rotation vector conversion
% by Eun-Hwan Shin, Feb. 2004.
%---------------
% function d_theta = dpos2rvec(lat, delta_lat, delta_lon)
function rv = dpos2rvec(lat, delta_lat, delta_lon)
rv = [ delta_lon * cos(lat);                % [E.H.Shin, 2005, eq.2.31 p.25]
            -delta_lat;
            -delta_lon * sin(lat)];