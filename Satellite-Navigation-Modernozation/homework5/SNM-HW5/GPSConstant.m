classdef GPSConstant   
    properties (Constant)
        c = 299792458;                  % the speed of light (m/s)
        wedot = 7.2921151467 * 10^-5;   % earth rotation rate
        GM = 3.986005 * 10^14;          % gravitation constant
        F = -4.442807633 * 10^-10;      % relativistic correction term constant
    end
end