function [clkcorr_m,grpdel] = svclkcorr(eph,tot,Ek)
%	Compute satellite clock correction
%
%   INPUTS
%   eph = ephemeris information.
%	tot = GPS time-of-transmission in seconds
%   Ek = eccentric anomaly of the satellite in radians
%
%   OUTPUTS
%	clkcorr_m = satellite clock correction expressed in meters
%   grpdel = group delay of the satellite expressed in meters
%
%   NOTE: The group delay term, TGD, is NOT incorporated into
%         the clock correction term.  The single-frequency user
%         must implement this externally to this routine.  Dual
%         frequency users do not need to apply TGD.  See sections
%         20.3.3.3.3 through 20.3.3.3.3.3 of ICD-GPS-200 for 
%         more details
%

if nargin < 3, error('insufficient number of input arguments'),end

TOE     = eph(2);
SQRTSMA = eph(3);
ECCEN   = eph(6);
AF0     = eph(18);
AF1     = eph(19);
AF2     = eph(20);
TGD     = eph(24);

c = 299792458;
tk = tot - TOE;
tk = chk_time(tk);

F = -4.442807633e-10;
deltatr = F*ECCEN*SQRTSMA*sin(Ek);  

deltatsvL1 = AF0 + AF1*tk + AF2*tk*tk + deltatr;
clkcorr_m = deltatsvL1*c;
grpdel = TGD;

%%% end of svclkcorr %%%