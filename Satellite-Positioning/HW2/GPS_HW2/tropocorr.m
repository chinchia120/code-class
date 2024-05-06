function tropodel = tropocorr(el)
%TROPOCORR	Compute tropospheric correction for
%           the dry component using the Hopfield model
%
%	tropodel = tropocorr(svxyz,usrxyz)
%
%   INPUTS
%   el = elevation of satellite (degree)
%
%   OUTPUTS
%	tropodel = estimate of tropospheric error (meters)

%	Copyright (c) 2002 by GPSoft
%

tropodel = 2.47/(sin(el*pi/180)+0.0121);