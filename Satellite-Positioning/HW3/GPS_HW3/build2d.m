function [ddmeas,ddprns,ndd]= build2d(maxsat,iprns,rmeas,ele,lsort,cutoff)
%
%   [ddmeas,ddprns,ndd] = build2d(maxsat,iprns,rmeas,ele,lsort,cutoff)
% ======================================================================
%   PURPOSE :
%   Build double differences of measurements
% ======================================================================
%   PARAMETER   I/O   DESCRIPTION
% ----------------------------------------------------------------------
%   maxsat       I   - max. number of satellites of two station(array size)
%   iprns        I   - PRN number array  (maxsat,2).
%   rmeas        I   - measurement array (maxsat,2).
%                      the same order as iprns.
%   ele          I   - the elevation angle array (max_prn). [degree]
%   lsort        I   - T or F to sort DD measurement.
%                      optional argument with default value = 'F'.
%                      according to elevation angle.
%   cutoff       I   - maskangle of station. [degree]
%                      optional argument with default value = 5.
%   ddmeas       O   - double difference(DD) measurement array (maxsat).
%   ddprns       O   - PRN number for DD measurement array.
%                      ddprns(1) points to major sat
%   ndd          O   - the number of DD measurement (less than maxsat).
% ======================================================================
%   NOTE :
%   This routine builds all the time the difference between the
%   reference satellite and the others
% ======================================================================
%
if nargin < 6, cutoff = 5; end
if nargin < 5, lsort = 'F'; end
if nargin < 4, error('insufficient number of input arguments'), end
%
% ---------- constant ---------- %
big = 1e10;
ch = 80;                         % Numbers of channel
% --------- initialize --------- %
dmeas = big*ones(ch,2);
elesats = zeros(maxsat,1);
% ----- select measurement ----- %
for j = 1:2,
    for i = 1:maxsat,
        prn = iprns(i,j);
        if (prn < 1), continue,end
        if (prn > ch), error('insufficient number of channel'),end
        if (ele(prn) < cutoff), continue,end
        % Found ok measurement, put into working array
        dmeas(prn,j) = rmeas(i,j);
    end
end

ifirst = 0;
ndd = -1;     % Ignore reference sat. first
% Counter for number of DD measurement first
for prn = 1:ch,
    if (dmeas(prn,1) ~= big) && (dmeas(prn,2) ~= big),
        if (ifirst == 0), ifirst = prn; end
        last = prn;
        ndd = ndd + 1;
    else
        dmeas(prn,1) = big;
        dmeas(prn,2) = big;
    end
end
if (ndd <= 0), error('Synergy failed due to deficient measurement'),end

% [maxele,maxprn] = max(ele);       %% 找最高衛星的仰角值及編號
% maxid = find(iprns(:,1)==maxprn); %% 找最大仰角值的位置
% major = iprns(maxid,1)
major = iprns(1,1);
label = 0;
if (dmeas(major,1) ~= big) && (dmeas(major,2) ~= big),
   r1 = dmeas(major,1);
   r2 = dmeas(major,2);
   ddprns(1) = major;
   elesats(1) = ele(major);
   if (major == ifirst), label = 1;end
else
   r1 = dmeas(ifirst,1);
   r2 = dmeas(ifirst,2);
   ddprns(1) = ifirst;
   elesats(1) = ele(ifirst);
   label = 1;
end

ndd = 0;
for prn = (ifirst+label):last,
    if (dmeas(prn,1) == big), continue,end
    if (prn == major), continue,end
    ndd = ndd + 1;
    ddprns(ndd+1) = prn;
    for i = 1:maxsat,
        if iprns(i,1) == prn,
            elesats(ndd) = ele(prn);
            continue,
        end
    end
    % building D.D. measurement
    ddmeas(ndd) = r1 - dmeas(prn,1) - r2 + dmeas(prn,2);
end
