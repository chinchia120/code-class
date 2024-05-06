%  作業一主程式：gpsdemo1.m     
%  ------------------ 有關 gpsdemo2 的說明 ----------------------------- %
%  使用電碼觀測量進行單點定位，並改正電離層及對流層誤差。
%  適用於RINEX 2.10版之導航檔及觀測檔。
%  --------------------------------------------------------------------- %
clear all
% close all

%% ---------- 全域變數 --------------------------- %%
% 大寫字母的變數儲存載入的資料
global SQRTSMA
global SVID_MAT TOWSEC C1 P1 P2
global MARKER_XYZ ANTDELTA OBSINT

%% ---------- 載入觀測檔及導航檔 ------------------ %%
disp(' Loading Data ... ')
% loadrinexn('sv050810.06n')
% load sv050810ob
loadrinexn('sv062900.06n')
load sv062900ob

%% ---------- 無電離層線性組合係數 ---------------- %%
f1 = 154*10.23e6;
f2 = 120*10.23e6;
ff1 = f1*f1;
ff2 = f2*f2;
a1 = ff1/(ff1-ff2);
a2 = -ff2/(ff1-ff2);

%% ---------- 初始化設定 ------------------------- %%
c = 299792458;
maskangle = 15;
usrxyz = MARKER_XYZ;  % 測站坐標真值
usrplh = xyz2llh(usrxyz);
[sv1,num1] = size(C1);
[sv2,num2] = size(P2);
nums = min(num1,num2);

epoch = 0; non = 0;
%% ---------- 單點定位 --------------------------- %%
disp(' Calculating Position... ')
for i = 1:nums,
%     if i < 340 || i > 360,continue,end
    clear svid prvec svxyzmat
    tow = TOWSEC(i);                 % Time-of-reception in GPS second-of-week
    svid = find(SVID_MAT(:,i)==1);  % Get Satellite identification number at epoch i
    k = 0;
    for j = 1:length(svid),         % Loop over all satellites being tracked during this epoch
        if SQRTSMA(svid(j)) < 1,
            error('Ephemeris not available for all satellites being tracked')
        end
        % skip over obviously bad measurements
%         if C1(svid(j),i) == 0 || P2(svid(j),i) == 0 || svid(j)==17, continue, end
        if C1(svid(j),i) == 0 || P2(svid(j),i) == 0, continue, end
% R3 = a1*C1(svid(j),i) + a2*P2(svid(j),i);      % New ionosphere-free pseudorange
% tot_est = tow - R3/c;                          % Estimate the time-of-transmission
        tot_est = tow - C1(svid(j),i)/c;               % Estimate the time-of-transmission
        [svxyz,E] = svposeph(svid(j),tot_est);         % Calculate the position of the satellite
        [sv_clk(svid(j)),grpdel] = svclkcorr(svid(j),tot_est,E);    % Calculate the satellite clock correction
        svenu = xyz2enu(svxyz'-usrxyz,usrplh);         % Convert the satellite position to east-north-up coordinates
        el = (180/pi)*atan(svenu(3)/norm(svenu(1:2)));
        if el >= maskangle,
            k = k + 1;
            R3 = a1*C1(svid(j),i) + a2*P2(svid(j),i);  % New ionosphere-free pseudorange
            cR3 = R3 + sv_clk(svid(j));                % Pseudorange corrected for satellite clock
            tropd = mhopfld(el,0.06,1013,20,50,0,0,0); % Calculate the tropospheric correction
% %             cL1 = C1(svid(j),i) + sv_clk(svid(j));   % Code on L1 pseudorange
% %             cL2 = P2(svid(j),i) + sv_clk(svid(j));   % Code on L2 pseudorange
% %             dualcorr = ( (1227.6^2)/(1575.42^2 - 1227.6^2) )*(cL1 - cL2);  % The dual-freq iono correction
% %             tropd = tropocorr(el);               % Calculate the tropospheric correction
%             prvec(k) = cL1 + dualcorr - tropd;   % Adjust the pseudorange for the iono and tropo corrections
            prvec(k) = cR3 - tropd;              % Adjust the pseudorange for tropo corrections
            svxyzr = erotcorr(svxyz,prvec(k));   % Adjust satellite position for earth rotation correction
            svxyzmat(k,:) = svxyzr';
            svvis(svid(j),i) = 1;
        end
    end
    if length(prvec) < 4,    % Must be at least 4 observations every epoch
        non = non + 1;
    else
        epoch = epoch + 1;   % Counter for epochs being processed
%         estusr = olspos(prvec,svxyzmat);    % Ordinary least-squares position solution
beta = [1 1 1 1];
estusr = [MARKER_XYZ 1];
maxiter=10;
iter=0;
clear A y
while ((iter < maxiter) && (norm(beta) > 1e-6)),
    for N = 1:length(prvec),
        dxyz = svxyzmat(N,:) - estusr(1:3);
   	    pr0 = norm(dxyz);
        cxyz = dxyz./pr0;
        A(N,:) = [-cxyz 1];
	    y(N,1) = prvec(N) - pr0 - estusr(4);
    end,
    beta = A\y;
    estusr = estusr + beta';
    iter = iter + 1;
end
Q = inv(A'*A);
GDOP(epoch) = sqrt( trace(Q) );
PDOP(epoch) = sqrt( trace(Q(1:3,1:3)) );
TDOP(epoch) = sqrt( Q(4,4) );
        enuerr(epoch,:) = xyz2enu(estusr(1:3)-usrxyz,usrplh);
        rx_clk_err(epoch) = estusr(4);
        tws(epoch) = tow;  % Time of week in second
    end
end
error = find(abs(enuerr(:,3))>10 | enuerr(:,3)==0);
r = length(error);

%% ---------- 定位精度評估 : 均方根誤差(RMSE) ------ %%
de = norm(enuerr(:,1));
dn = norm(enuerr(:,2));
dh = norm(enuerr(:,3));
rms2d = sqrt( (de*de + dn*dn)/epoch )
rmsd = sqrt( dh*dh/epoch )
%% ---------- 繪圖 -------------------------------- %%
figure(3)
plot(enuerr(:,1),enuerr(:,2),'*'),grid
axis('square');axis('equal')
axis([-5 5 -5 5])
% axis([-6 6 -6 6])
title('GPS Ion-free & Trop-corr Point Positioning Error')
%title('GPS Ion-free Point Positioning Error')
%title('GPS Trop-corr Point Positioning Error')
ylabel('north error (m)')
xlabel('east error (m)')
figure(4)
subplot(311)
plot([1:epoch],GDOP,'r')
ylabel(' GDOP ')
%axis([1 800 -3 3])
subplot(312)
plot([1:epoch],PDOP,'g')
ylabel(' PDOP ')
%axis([1 800 -3 3])
subplot(313)
plot([1:epoch],TDOP,'b')
ylabel(' TDOP ')
xlabel('epochs')
% figure(4)
% subplot(311)
% plot([1:epoch],enuerr(:,1),'-')
% ylabel('east error ')
% % axis([1 800 -3 3])
% subplot(312)
% plot([1:epoch],enuerr(:,2),'-')
% ylabel('north error ')
% % axis([1 800 -3 3])
% subplot(313)
% plot([1:epoch],enuerr(:,3),'-')
% ylabel('height error ')
% xlabel('epochs')
%% ----------------- end --------------------- %%
