function [ieph,ic] = find_eph2(eph,prn,time)
%FIND_EPH  Finds the proper column in ephemeris array

ic = 1;
dtmin = eph(2,ic)-time;
for t = 2:size(eph,2),
   dt = eph(2,t)-time;
   if dt < 0,
      if abs(dt) < abs(dtmin),
         ic = t;
         dtmin = dt;
      end
   end
end
ieph = eph(:,ic);
%%%%%%%%%%%%  find_eph.m  %%%%%%%%%%%%%%%%%
