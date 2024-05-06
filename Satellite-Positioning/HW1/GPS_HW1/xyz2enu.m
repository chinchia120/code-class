function enu = xyz2enu(dxyz,plh)
%XYZ2ENU dX, dY, dZ (Cartesian) to dE, dN, dU (East, North, Up). 
%        Converts delta quantities dX, dY and dZ (Cartesian) into
%        dE, dN, dU (East, North, Up):
%
%           enu = xyz2neu(dxyz,plh)
%
%        plh is a vector wtih Lattitude and Longitude of the point.

%        H. van der Marel, LGR, 07-05-95
%        (c) Geodetic Computing Centre, TU Delft

[m,n]=size(dxyz);
if n~=3 & m==3, dxyz=dxyz'; end
[m,n]=size(plh);
if n~=3 & m==3, plh=plh'; end
[m1,n1]=size(dxyz);
[m2,n2]=size(plh);
% if m1~=m2, disp(['error XYZ2ENU']);, end

enu = [                -sin(plh(:,2)).*dxyz(:,1) +                cos(plh(:,2)).*dxyz(:,2)                           ...
        -sin(plh(:,1)).*cos(plh(:,2)).*dxyz(:,1) - sin(plh(:,1)).*sin(plh(:,2)).*dxyz(:,2) + cos(plh(:,1)).*dxyz(:,3) ...
         cos(plh(:,1)).*cos(plh(:,2)).*dxyz(:,1) + cos(plh(:,1)).*sin(plh(:,2)).*dxyz(:,2) + sin(plh(:,1)).*dxyz(:,3) ];
if n~=3 & m==3, enu=enu';plh=plh';, end
    


