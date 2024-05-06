clear;
clc;
%% ------------- make new folder ------------- %%
%[status, msg, msgID] = mkdir('picture');

%% ---------------- load data ---------------- %%
disp(' Loading Data ... ');
load('CK01_out.mat');                                                       % 自行輸入Input檔名

%% -------------- initial value -------------- %%
c = 299792458;
f1 = 154*10.23e6;
f2 = 120*10.23e6;

%% --- ionosphere free linear combination ---- %%
a1 = 1 / (1-(f2^2)/(f1^2));
a2 = 1 - a1;

%% -------------- initial value -------------- %%
usrxyz = [-2956584.492, 5075878.999, 2476667.613];                          % 自行輸入點位已知座標(X,Y,Z)(評估定位誤差用)
ant_h = 1.700;                                                              % 自行輸入天線高(m)
usrplh = xyz2llh(usrxyz);                                                   % 將(X,Y,Z)轉為(lat,lon,ht)=(緯度、經度、橢球高)
usrplh(3) = usrplh(3) + ant_h;                                              % 將點位座標轉至天線相位中心座標
usrxyz = llh2xyz(usrplh);                                                   % 再將(lat,lon,ht)轉為(X,Y,Z)

%% ------------ point positioning ------------ %%
disp(' Calculating Position... ');

aEpoch = size(La{1,1}.NSAT, 2);
for i = 1: aEpoch                                                           % for i=1:最後一個epoch(即為觀測筆數之總數)
    delta = [1e-6 1e-6 1e-6 1e-6];                                          % 未知數增量初始值
    estusr = [usrxyz 0];                                                    % 已知點座標與接收機時鐘誤差之起始值
    maxiter = 10;                                                           % 最大迭代次數
    iter = 0;
    clear A y;    
    if La{1,1}.NSAT(i) >= 4                                                 % 衛星顆數需大於或等於4顆才執行下面的迴圈
        while ((iter < maxiter) && (norm(delta) > 1e-6))             
            for N = 1: La{1,1}.NSAT(i)                                      % La{1,1}.NSAT(i)為第i個時刻的衛星顆數
                prn = La{1,1}.IDMAT(i, N+2);                                % 衛星PRN編號
                svxyzmat(N, :) = La{1,1}.SVMAT(N, :, i);                    % 衛星的地心地固(ECEF)座標(dx,dy,dz)
                svenu = xyz2enu(svxyzmat(N, :)-usrxyz, usrplh);             % 計算衛星相對測站的地平座標(de,dn,du)
                el = (180/pi) * atan(svenu(3)/norm(svenu(1: 2)));           % 計算衛星相對於測站的仰角
                Pr1 = La{1, 1}.CODE(N, 1, i) + satclkcorr(prn, i);          % 衛星時錶誤差改正: Pr1=P1-cdt
                Pr2 = La{1, 2}.CODE(N, 1, i) + satclkcorr(prn, i);          % 衛星時錶誤差改正: Pr2=P2-cdt

%% ---------- ionospheric modelling ---------- %%
                %Pr3 = a1*Pr1 + a2*Pr2;                                     % 獲得無電離層線性組合(ion-free)電碼觀測量

%% ---------- tropospheric effects ----------- %%
                tropd = mhopfld(el, usrplh(3)/1000, 1015.4, 24.4, 50, 40.8/1000, 40.8/1000, 40.8/1000);                                         
                Pr = Pr1 - tropd;                                           % 獲得改正對流層延遲後的電碼觀測量
                               
                % el     [degree]     觀測時刻的衛星仰角
                % hsta   [km]         測站高程
                % p      [mbar]       大氣壓力
                % tcel   [celsius]    溫度
                % hum    [%]          濕度
                % hp     [km]         量測壓力處的高程
                % htkel  [km]         量測溫度處的高程
                % hhum   [km]         量測濕度處的高程   

                dxyz = svxyzmat(N,:) - estusr(1:3);                         % 測站至衛星之ECEF座標向量(dx,dy,dz)
                rho0 = norm(dxyz);                                          % 測站至衛星的距離
                cxyz = dxyz./rho0;                                          % 測站至衛星的單位向量

%% --- designed matrix and observed matrix --- %%
                A(N, :) = [-cxyz, -1];                                      % 產生設計矩陣A
                y(N, 1) = Pr - (rho0 - estusr(4));                          % 產生觀測量向量: y=Pr-(rho0-cdT)

            end

%% --------- calculate and iteration --------- %%
                delta = inv(A.'*A)*A.'*y;                                   % Least-squares計算未知參數的改正量
                estusr = estusr + delta;                                    % 更新未知參數(測站座標與接收機時鐘誤差)
                iter = iter + 1;
        end    

      Q = inv(A'*A);                                                        % 計算N^-1矩陣(法矩陣之逆矩陣)

%% - calculate GDOP, PDOP, TDOP, HDOP, VDOP -- %%
      GDOP(i) = sqrt(Q(1, 1) + Q(2, 2) + Q(3, 3) + Q(4, 4));
      PDOP(i) = sqrt(Q(1, 1) + Q(2, 2) + Q(3, 3));
      TDOP(i) = sqrt(Q(4, 4));
      tllh = xyz2llh(usrxyz);                                               % 將點位已知座標由(X,Y,Z)轉至(Lat,Lon,ht)
      R = [-sin(tllh(2)), cos(tllh(2)), 0; 
           -sin(tllh(1))*cos(tllh(2)), -sin(tllh(1))*sin(tllh(2)), cos(tllh(1)); 
            cos(tllh(1))*cos(tllh(2)), cos(tllh(1))*sin(tllh(2)), sin(tllh(1))];                                                             
      QENU = R*Q(1: 3, 1: 3)*R.';
      HDOP(i) = sqrt(QENU(1, 1) + QENU(2, 2));
      VDOP(i) = sqrt(QENU(3, 3));

    enuerr(i,:) = xyz2enu(estusr(1:3)-usrxyz,usrplh);                       % 計算定位誤差並轉至地平座標系統
    rx_clk_err(i,1)= estusr(4);                                             % 將接收機時鐘誤差存入rx_clk_err(i,1)
    end
end

%% ------- calculate precision and RMS ------- %%
de = norm(enuerr(:,1));                                                     % E方向定位誤差
dn = norm(enuerr(:,2));                                                     % N方向定位誤差
dh = norm(enuerr(:,3));                                                     % Height方向定位誤差

%% -------------------- E -------------------- %%
meanE = sum(enuerr(:,1))/i;
RESE = enuerr(:,1)-meanE;
standardE = ((RESE'*RESE)/(i-1))^0.5;
rmse = sqrt( de*de/i);

%% -------------------- N -------------------- %%
meanN = sum(enuerr(:,2))/i;
RESN = enuerr(:,2)-meanN;
standardN = ((RESN'*RESN)/(i-1))^0.5;
rmsn = sqrt( dn*dn/i);

%% ------------------ Height ------------------ %%
meanH = sum(enuerr(:,3))/i;
RESH = enuerr(:,3)-meanH;
standardH = ((RESH'*RESH)/(i-1))^0.5;
rmsu = sqrt( dh*dh/i);

%% ---------------- output txt ---------------- %%
file = fopen('CK01_output_tropospheric.txt', 'w');
fprintf(file, 'meanE = %9.6f, standardE =%9.6f, rmse = %9.6f\n', meanE, standardE, rmse);
fprintf(file, 'meanN = %9.6f, standardN =%9.6f, rmsn = %9.6f\n', meanN, standardN, rmsn);
fprintf(file, 'meanH = %9.6f, standardH =%9.6f, rmsu = %9.6f\n\n', meanH, standardH, rmsu);

fprintf(file, 'GDOP_avg = %5.4f\n', mean(GDOP));
fprintf(file, 'PDOP_avg = %5.4f\n', mean(PDOP));
fprintf(file, 'TDOP_avg = %5.4f\n', mean(TDOP));
fprintf(file, 'HDOP_avg = %5.4f\n', mean(HDOP));
fprintf(file, 'VDOP_avg = %5.4f\n\n', mean(VDOP));

fprintf(file, '2D error = %9.6f, 3D error = %9.6f\n', sqrt(rmse^2+rmsn^2), sqrt(rmse^2+rmsn^2+rmsu^2));
fprintf(file, 'UERE_H = %9.6f, UERE_EN = %9.6f, UERE_ENH = %9.6f\n', sqrt(rmsu^2)/mean(VDOP), sqrt(rmse^2+rmsn^2)/mean(HDOP), sqrt(rmse^2+rmsn^2+rmsu^2)/mean(GDOP));

%% --------------- output plot ---------------- %%

%% ------------- (E, N) direction ------------- %%
figure
subplot(2,2,1)
plot(enuerr(:,1),enuerr(:,2),'*'),grid
axis square ; axis equal
axis([-20 20 -20 20])
title('GPS Point Positioning Error')
ylabel('north error (m)')
xlabel('east error (m)')
grid on

%% --------- (Height, Time) direction --------- %%
subplot(2,2,2)
plot(1:aEpoch,enuerr(:,3),'*'),grid
axis square
axis([0 aEpoch -30 30])
title('GPS Point Positioning Error')
ylabel('height error (m)')
xlabel('epoch')
grid on

%% ------------ (E, Time) direction ----------- %%
subplot(2,2,3)
plot(1:aEpoch,enuerr(:,1),'*'),grid
axis square
axis([0 aEpoch -30 30])
title('GPS Point Positioning Error')
ylabel('east error (m)')
xlabel('epoch')
grid on

%% ------------ (N, Time) direction ----------- %%
subplot(2,2,4)
plot(1:aEpoch,enuerr(:,2),'*'),grid
axis square
axis([0 aEpoch -30 30])
title('GPS Point Positioning Error')
ylabel('north error (m)')
xlabel('epoch')
grid on

%% ----------------- save plot ---------------- %%
saveas(gcf, './picture//positioning_error_tropospheric.png');

%% ----------------- GDOP plot ---------------- %%
figure
subplot(2,3,1)
plot(GDOP)
axis([0 aEpoch 0 10])
title('GDOP')
xlabel('epoch')
grid on

%% ----------------- PDOP plot ---------------- %%
subplot(2,3,2)
plot(PDOP)
axis([0 aEpoch 0 10])
title('PDOP')
xlabel('epoch')
grid on

%% ----------------- TDOP plot ---------------- %%
subplot(2,3,3)
plot(TDOP)
axis([0 aEpoch 0 10])
title('TDOP')
xlabel('epoch')
grid on

%% ----------------- HDOP plot ---------------- %%
subplot(2,3,4)
plot(HDOP)
axis([0 aEpoch 0 10])
title('HDOP')
xlabel('epoch')
grid on

%% ----------------- VDOP plot ---------------- %%
subplot(2,3,5)
plot(VDOP)
axis([0 aEpoch 0 10])
title('VDOP')
xlabel('epoch')
grid on

%% ----------------- save plot ---------------- %%
saveas(gcf, './picture//DOP_tropospheric.png');