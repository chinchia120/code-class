function llh = xyz2llh(xyz)
%	Convert from ECEF cartesian coordinates to 
%   latitude, longitude and height.  WGS-84
%
%   INPUTS
%	xyz(i,1) = ECEF x-coordinate for station i in meters
%	xyz(i,2) = ECEF y-coordinate for station i in meters
%	xyz(i,3) = ECEF z-coordinate for station i in meters
%
%   OUTPUTS
%	llh(1) = latitude in radians(phi)
%	llh(2) = longitude in radians(lambda)
%	llh(3) = height above ellipsoid in meters(h)
%

npt = size(xyz,1);
for i = 1:npt,
	x = xyz(i,1);
	y = xyz(i,2);
	z = xyz(i,3);
	z2 = z*z;
	r2 = x*x+y*y;
	r = sqrt(r2);

	a = 6378137.0000;	% earth radius in meters
	b = 6356752.3142;	% earth semiminor in meters
    a2 = a*a;
	b2 = b*b;
	e2 = 1 - (b2/a2);
	e =  sqrt(e2);
	ep = e*(a/b);
	E2 = a2 - b2;
	F = 54*b2*z2;
	G = r2 + (1-e2)*z2 - e2*E2;
    G2 = G*G;
	c = (e2*e2*F*r2)/(G*G2);
	s = ( 1 + c + sqrt(c*c + c + c) )^(1/3);
	P = F / (3 * (s+1/s+1)^2 * G2);
	Q = sqrt(1+2*e2*e2*P);
	ro = -(P*e2*r)/(1+Q) + sqrt((a2/2)*(1+1/Q) ...
                                - (P*(1-e2)*z2)/(Q*(1+Q)) - P*r2/2);
	tmp = (r - e2*ro)^2;
	U = sqrt( tmp + z2 );
	V = sqrt( tmp + (1-e2)*z2 );
	zo = (b2*z)/(a*V);

	llh(i,1) = atan( (z + ep*ep*zo)/r );
    llh(i,2) = mod((atan2(y,x)),2*pi);
	llh(i,3) = U*( 1 - b2/(a*V) );
%     llh(i,:) = [lat long height];
end
% end of function xyz2llh
    