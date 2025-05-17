function [xy]=ll2xy(llh,ll_org)

% llh      - [latitude(1,nsta);longitude(1,nsta)]; nsta: number of stations
% ll_org   - [latitude,longitude] of origin point
% xy       - [x(nsta,1) y(nsta,2)]

latdt=111.325;
londt=cos((llh(1,:)'+ll_org(1,1))/2*pi/180)*latdt;
x=(llh(2,:)'-ll_org(1,2)).*londt;
y=(llh(1,:)'-ll_org(1,1))*latdt;
xy=[x y];
