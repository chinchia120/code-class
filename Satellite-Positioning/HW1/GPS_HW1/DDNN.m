%  use major sat. PRN 2 & sub- sat. PRN 6 10 26 29
%  without cycle slip for station sv05 & sv06
clear all
close all
% 
global SQRTSMA         % SQRT(Semi-major axis of orbit)
global SVID_MAT TOWSEC C1 P1 P2 PHASE1 PHASE2
global MARKER_XYZ ANTDELTA
%
% Using reference station Navigation data only
disp(' Loading Data ... ')
loadrinexn('sv050810.06n')
%
%% ----- Load Reference Station Observation data ------ %%
load sv050810ob
refxyz = MARKER_XYZ;           % Given coordinate for sv405
C1_I = C1; P2_I = P2;          % sv405 pseudo-range
L1_I = PHASE1; L2_I = PHASE2;  % sv405 carrier phase
TIME_I = TOWSEC;
PRN_I = SVID_MAT;
%
%% ------- Load User Station Observation data --------- %%
load sv060810ob
usrxyz = MARKER_XYZ;           % Given coordinate for sv406 
C1_J = C1; P2_J = P2;          % sv406 pseudo-range
L1_J = PHASE1; L2_J = PHASE2;  % sv406 carrier phase
TIME_J = TOWSEC;
PRN_J = SVID_MAT;
%
%% ---- Coefficient of linear combination ---- %%
c = 299792458;
f1 = 1575.42*1e6;
f2 = 1227.6*1e6;
lam1 = c/f1;
lam2 = c/f2;
lam5 = c/(f1-f2);
% rat = 154/120;
% g2 = (-2*f1/c + f2/c*(1 + rat*rat))/(1 - rat*rat);
% g1 = (f2-f1)/c - g2;
% g3 = 1;
% g4 = -1;
%
%% -------------- Initialize ----------------- %%
disp(' only ONE satellite be permitted ');
major = input(' Reference satellite PRN number : ');
disp(' 3 or MORE satellites be permitted , Input ex : [6 7 10] ');
temp = input(' Differencing satellite PRN number vector : ');
[r,s] = size(temp);
if r > s, sub = temp'; else, sub = temp; end
if length(sub) < 3, error('must select at least 3 satellites'), end
ns = length(sub) + 1;              % numbers of satellite
sats = [major,sub];                % satellites PRN number
% Get total epoch of C/A-code for two station
epo_ref = size(C1_I,2);
epo_usr = size(C1_J,2);
% % mddnw(1:nod) = 0;
epoch = 1; inc1 = 0; inc2 = 0;
while 1
    %% m = epoch of reference ; n = epoch of user
    m = epoch + inc1; n = epoch + inc2;
    if (m > epo_ref) | (n > epo_usr),break,end
    % Case 1 : ( Time of reception for reference at epech m ) = ( Time of reception for user at epech n )
    if abs(TIME_I(m)-TIME_J(n)) < 0.01,
       time = TIME_I(m);                    % Time of reception given in GPS time-of-week in seconds
       k = 0;
       for u = 1:ns,
           prn = sats(u);
           if (SQRTSMA(prn) < 1),
               error('Ephemeris not available for all satellites being tracked')
           end
           clear range svxyz svxyzr sv_clk
           tot_est = time - (C1_I(prn,m))/c;   % Estimate the time-of-transmission
           [svxyz,E] = svposeph(prn,tot_est);     % Calculate the position of the satellite
           [sv_clk(prn),grpdel] = svclkcorr(prn,tot_est,E);  % Calculate satellite clock correction
           range(u) = C1_I(prn,m) + sv_clk(prn);  % Pseudo-range corrected for satellite clock
           svxyzr = erotcorr(svxyz,range(u));     % Adjust satellite position for earth rotation correction
           svpos(u,:,epoch) = svxyzr';
           nw_I(prn,1) = g1*C1_I(prn,m) + g2*P2_I(prn,m) ... 
                       + g3*L1_I(prn,m) + g4*L2_I(prn,m);
           nw_J(prn,1) = g1*C1_J(prn,n) + g2*P2_J(prn,n) ... 
                       + g3*L1_J(prn,n) + g4*L2_J(prn,n);
           if (u > 1),
               k = k + 1;
               ddnw(k,epoch) = (nw_I(major,1) - nw_I(prn,1) ...
                              - nw_J(major,1) + nw_J(prn,1));
%                  if ddnw(prn,epoch) ~= 0, all(prn,1) = 1;end
% %                mddnw(u) = mddnw(u)*(epoch-1)/epoch + ddnw(u,epoch)/epoch;
%     	   rik = norm(svpos(1,:,epoch) - refxyz);
%     	   ril = norm(svpos(u,:,epoch) - refxyz);
%     	   rjk = norm(svpos(1,:,epoch) - usrxyz);
%     	   rjl = norm(svpos(u,:,epoch) - usrxyz);
               ddL1(k,epoch) = L1_I(major,m) - L1_I(prn,m) ...
                             - L1_J(major,n) + L1_J(prn,n);
               ddL2(k,epoch) = L2_I(major,m) - L2_I(prn,m) ...
                             - L2_J(major,n) + L2_J(prn,n);
               ddLw(k,epoch) = lam5*(ddL1(k,epoch) - ddL2(k,epoch));
%            ddn1(k,epoch) = ddL1(k,epoch) - (rik - ril + rjk - rjl)/lam1;
%            ddn2(k,epoch) = ddL2(k,epoch) - (rik - ril + rjk - rjl)/lam2;
           end
       end
       timeofsamples(epoch) = time;         % Time for the epoch being processed
       epoch = epoch + 1;                   % Counter for epochs being processed
   elseif (TIME_1(m)-TIME_2(n)) > 0,        % Case 2
           inc2 = inc2 + 1;
   elseif (TIME_1(m)-TIME_2(n)) < 0,        % Case 3
           inc1 = inc1 + 1; 
   end
end
epoch = epoch - 1;
% for u = 1:nod,
%     mddn1(u) = (mean(ddn1(u,:)));
%     mddn2(u) = (mean(ddn2(u,:)));
%     mddnw(u) = (mean(ddn1(u,:))-mean(ddn2(u,:)));
% end
% for u = 1:nod,
%     mddnw(u) = round(mean(ddnw(u,:)));
% end
% for r = 1:epoch,
%     clear newo
%     newo = ddLw(:,r) - lam5*mddnw(:);
%     clear ddr1 ddr2
%     ddr1 = lam1*(ddL1(2:ns,r) - mddn1(:));
%     ddr2 = lam2*(ddL2(2:ns,r) - mddn2(:));
%     if length([ddr1;ddr2]) < 3;                % Numbers of observation need at least 3 every epoch
%     if length(newo) < 3;                        % Numbers of observation need at least 3 every epoch
%         enuerr(r,:) = NaN;
%     else
%         estusr = ols3x(newo,svpos(:,:,r),refxyz,usrxyz);
%         dr = [1 1 1];
%         estusr = usrxyz;
%         maxiter = 10;
%         tolerate = 1e-3;
%         iter = 0;
%         while ((iter < maxiter) & (norm(dr) > tolerate)),
%         clear A y
%             for u = 1:ns-1,
%    	            rik = norm(svref(r,:) - refxyz);
%    	            ril = norm(svdif(u,:,r) - refxyz);
%    	            rk0 = norm(svref(r,:) - estusr);
%    	            rl0 = norm(svdif(u,:,r) - estusr);
%                 dl = svdif(u,:,r) - estusr;
%                 dk = svref(r,:) - estusr;
%                 A(u,:) = [-(dl./rl0-dk./rk0)];
% %                 A(u+ns-1,:) = [-(dl./rl0-dk./rk0)];
%                 y(u,1) = newo(u) - (rik - ril - rk0 + rl0);
% %                 y(u,1) = ddr1(u) - (rik - ril - rk0 + rl0);
% %                 y(u+ns-1,1) = ddr2(u) - (rik - ril - rk0 + rl0);
%             end
%             dr = A\y;
%             estusr = estusr + dr';
%             iter = iter + 1;
%         end
%         enuerr(r,:) = ( xyz2enu(estusr,usrxyz) )';
%         rerr(r) = norm(enuerr(r,:));
%     end
% end
%% ---- Quality Evaluation : Root Mean Squre Error ---- %%
% de = norm(enuerr(:,1));                     % East   tracking error
% dn = norm(enuerr(:,2));                     % North  tracking error
% dh = norm(enuerr(:,3));                     % Height tracking error
% rms2d = sqrt( (de*de + dn*dn)/epoch )       % RMSE for plane
% rmsd = sqrt( dh*dh/epoch )                  % RMSE for height
% stdr = std(rerr(:))                         % Standard deviation
%% ---------- Remove no data epoch ----------- %%
% svn = find(all == 1);
% nfig = max(size(svn));
% for i = 1:epoch,
%     for j = 1:nfig,
%         ddn(j,i) = ddnw(svn(j),i);
%         if ddnw(svn(j),i) == 0, ddn(j,i) = NaN; end
%     end
% end
%% ----------------- plot -------------------- %%
% figure(1);
% plot(enuerr(:,1),enuerr(:,2),'*'),grid
% axis('square');axis('equal')
% axis([-1 1 -1 1])
% title(' Wide-lane phase-range for differential GPS Positioning Error')
% ylabel('north error (m)')
% xlabel('east error (m)')
% figure(2);
% subplot(2,2,1)
% plot(1:epoch,ddn(1,:),'-');
% ylabel('DD N1- N2 (cycles)')
% %xlabel(' epoch ')
% subplot(2,2,2)
% plot(1:epoch,ddn(2,:),'-');
% ylabel('DD N1- N2 (cycles)')
% subplot(2,2,3)
% plot(1:epoch,ddn(3,:),'-');
% ylabel('DD N1- N2 (cycles)')
% subplot(2,2,4)
% plot(1:epoch,ddn(4,:),'-');
% ylabel('DD N1- N2 (cycles)')
% figure(3);
% subplot(2,2,1)
% plot(1:epoch,ddn(5,:),'-');
% ylabel('DD N1- N2 (cycles)')
% subplot(2,2,2)
% plot(1:epoch,ddn(6,:),'-');
% ylabel('DD N1- N2 (cycles)')
% subplot(2,2,3)
% plot(1:epoch,ddn(7,:),'-');
% ylabel('DD N1- N2 (cycles)')
% subplot(2,2,4)
% plot(1:epoch,ddn(8,:),'-');
% ylabel('DD N1- N2 (cycles)')
% figure(4);
% subplot(2,2,1)
% plot(1:epoch,ddn(9,:),'-');
% ylabel('DD N1- N2 (cycles)')
% subplot(2,2,2)
% plot(1:epoch,ddn(10,:),'-');
% ylabel('DD N1- N2 (cycles)')
% subplot(2,2,3)
% plot(1:epoch,ddn(11,:),'-');
% ylabel('DD N1- N2 (cycles)')
%% ----------------- end --------------------- %%
