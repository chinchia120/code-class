function xyz = wgslla2xyz(lla)

[k, ~] = size(lla);

A_EARTH = 6378137;
flattening = 1/298.257223563;
NAV_E2 = (2-flattening)*flattening; % also e^2
deg2rad = pi/180;

xyz = zeros(k, 3); % Initialize output matrix

for i = 1:k
    wlat = lla(i, 1);
    wlon = lla(i, 2);
    walt = lla(i, 3);

    slat = sin(wlat*deg2rad);
    clat = cos(wlat*deg2rad);
    r_n = A_EARTH/sqrt(1 - NAV_E2*slat*slat);
    xyz(i, :) = [ (r_n + walt)*clat*cos(wlon*deg2rad),  
                  (r_n + walt)*clat*sin(wlon*deg2rad),  
                  (r_n*(1 - NAV_E2) + walt)*slat ];

    if wlat < -90.0 || wlat > +90.0 || wlon < -180.0 || wlon > +360.0
        error('WGS lat or WGS lon out of range');
    end
end

end