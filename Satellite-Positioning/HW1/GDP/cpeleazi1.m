function [elev,azim,rotmat] = cpeleazi1 (xyzsat,xyzstation,plhstation)
%CPELEAZI1: Compute elevation/azimuth of satellites/pseudolites
%
% Syntax :
%    [elev,azim,rotmat] = cpeleazi1 (xyzsat,xyzstation,plhstation)
%
% Input :
%    xyzsat(i,1:3) - X,Y,Z-coordinate (WGS'84) for satellite i
%    xyzstation    - WGS'84 coordinates for station (x,y,z)
%    plhstation    - WGS'84 coordinates for station (phi,lambda,height)
%
% Output :
%    azim       - azimuth for satellite (i)
%    elev       - elevation for satellite (i)
%    rotmat     - Rotation-matrix from WGS'84/XYZ to WGS'84/PLH
% 

% ---------------------------
% --- Initialize matrices ---
% ---------------------------

azim = zeros(size(xyzsat,1),1);
elev = zeros(size(xyzsat,1),1);

% -------------------------------------------------
% --- Compute azimuths/elevations, if requested ---
% -------------------------------------------------
dx = xyzsat(:,1) - xyzstation(1);
dy = xyzsat(:,2) - xyzstation(2);
dz = xyzsat(:,3) - xyzstation(3);

cosplh1 = cos(plhstation(1));
sinplh1 = sin(plhstation(1));
cosplh2 = cos(plhstation(2));
sinplh2 = sin(plhstation(2));

rotmat(1,1) = - sinplh1 * cosplh2;
rotmat(1,2) = - sinplh1 * sinplh2;
rotmat(1,3) =   cosplh1          ;
rotmat(2,1) = -           sinplh2;
rotmat(2,2) =             cosplh2;
rotmat(2,3) =   0d0;
rotmat(3,1) = - cosplh1 * cosplh2;
rotmat(3,2) = - cosplh1 * sinplh2;
rotmat(3,3) = - sinplh1          ;

%   dneh  = rotmat * [dx dy dz]';
%   dist = sqrt(dneh(1,:).^2 + dneh(2,:).^2 + dneh(3,:).^2);
%   azim = mod(180/pi*(atan2(dneh(2,:),dneh(1,:))),360);
%   elev = (asin(-dneh(3,:)./dist))*180/pi;  

for i = 1:length(dx),
    if any(xyzsat(i,:)),
        dneh = rotmat * [dx(i);dy(i);dz(i)];
        dist = sqrt(dneh(1)*dneh(1)+dneh(2)*dneh(2)+dneh(3)*dneh(3));
        azim(i) = mod(180/pi*(atan2(dneh(2),dneh(1))),360);
        elev(i) = (asin(-dneh(3)/dist))*180/pi;
    end
end

% --------------------------------
% --- End of function cpaziele ---
% --------------------------------
