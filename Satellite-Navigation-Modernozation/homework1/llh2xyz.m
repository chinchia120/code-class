function xyz = llh2xyz(llh)
%	Convert from latitude, longitude and height to ECEF cartesian coordinates.
%
%	INPUTS
%	llh(1) = latitude in radians
%	llh(2) = longitude in radians
%	llh(3) = height above ellipsoid in meters
%	
%	OUTPUTS
%	xyz(1) = ECEF x-coordinate in meters
%	xyz(2) = ECEF y-coordinate in meters
%	xyz(3) = ECEF z-coordinate in meters

phi = llh(1);
lambda = llh(2);
h = llh(3);

a = 6378137.0000;
b = 6356752.3142;	
e = sqrt (1-(b/a).^2);

sinphi = sin(phi);
cosphi = cos(phi);
coslam = cos(lambda);
sinlam = sin(lambda);
tan2phi = (tan(phi))^2;
tmp = 1 - e*e;
tmpden = sqrt( 1 + tmp*tan2phi );

x = (a*coslam)/tmpden + h*coslam*cosphi;

y = (a*sinlam)/tmpden + h*sinlam*cosphi;

tmp2 = sqrt(1 - e*e*sinphi*sinphi);
z = (a*tmp*sinphi)/tmp2 + h*sinphi;

xyz(1) = x;
xyz(2) = y;
xyz(3) = z;

end