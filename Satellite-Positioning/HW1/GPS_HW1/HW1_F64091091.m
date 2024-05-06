clear all;
clc;

%% ------------- 載入觀測檔及導航檔 --------------- %%
disp(' Loading Data ... ');
load('CK01_out.mat');                                                           % 輸入檔名

%% ------------------ 初始化設定 ------------------- %%
c = 299792458;
usrxyz = [-2956584.492, 5075878.999, 2476667.613];                              % 自行輸入已知點座標(X,Y,X)
ant_h = 1.700;                                                                  % 自行輸入天線高(m)
usrplh = xyz2llh(usrxyz);                                                       % 由(X,Y,Z)轉至(Lat,Lon,ht)
usrplh(3) = usrplh(3) + ant_h;                                                  % 將已知點座標移至天線相位中心
usrxyz = llh2xyz(usrplh);                                                       % 由(Lat,Lon,ht)轉至(X,Y,Z)

%% ----------------- 單點定位 ---------------------- %%
disp(' Calculating Position... ');
aEpoch = size(La{1, 1}.NSAT, 2);
for i = 1: aEpoch                                                               % i=1:最後一個epoch(即為觀測筆數總數)
    delta = [1e-6 1e-6 1e-6 1e-6];                                              % 未知數增量初始值
    estusr = [usrxyz 0];                                                        % 已知點座標與接收機時鐘誤差起始值
    maxiter = 10;                                                               % 最大迭代次數
    iter = 0;
    clear A y    
    while ((iter < maxiter) && (norm(delta) > 1e-6)),
        for N = 1: La{1, 1}.NSAT(i),                                            % La{1,1}.NSAT(i)為第i個時刻的衛星顆數
            prn = La{1, 1}.IDMAT(i, N+2);                                       % 衛星編號
            svxyzmat(N, :) = La{1, 1}.SVMAT(N, :, i)                            % 衛星的地心地固(ECEF)座標
            Pr  = La{1, 1}.CODE(N, 1, i) + satclkcorr(prn, i);                  % 衛星時錶誤差改正: Pr=P-cdt
            dxyz = svxyzmat(N, :) - estusr(1: 3);                               % 測站至衛星之ECEF座標向量(dx,dy,dz)
            rho0  = norm(dxyz);                                                 % 測站至衛星的距離
            cxyz = dxyz./rho0;                                                  % 測站至衛星的單位向量
            A(N, :) = [-cxyz, -1];                                              % 產生設計矩陣A
            y(N, 1) = Pr - (rho0 - estusr(4));                                  % 產生觀測量向量y=Pr-(rho0-cdT)
        end 
        delta = inv(A.'*A)*A.'*y;                                               % Least-squares計算未知參數改正量
        estusr = estusr + delta;                                                % 更新未知參數(測站座標與接收機時鐘誤差)   
        iter = iter + 1;
    end
    Q = inv(A'*A);                                                              % 計算N^-1矩陣
    GDOP(i) = sqrt(Q(1, 1) + Q(2, 2) + Q(3, 3) + Q(4, 4));
    PDOP(i) = sqrt(Q(1, 1) + Q(2, 2) + Q(3, 3));
    TDOP(i) = sqrt(Q(4, 4));
    tllh = xyz2llh(estusr(1: 3));                                               % 已知點座標由(X,Y,Z)轉至(Lat,Lon,ht)
    R = [-sin(tllh(2)), cos(tllh(2)), 0; 
         -sin(tllh(1))*cos(tllh(2)), -sin(tllh(1))*sin(tllh(2)), cos(tllh(1)); 
         cos(tllh(1))*cos(tllh(2)), cos(tllh(1))*sin(tllh(2)), sin(tllh(1))];   % 產生轉換矩陣R
    QENU = R*Q(1: 3, 1: 3)*R.';
    HDOP(i) = sqrt(QENU(1, 1) + QENU(2, 2));
    VDOP(i) = sqrt(QENU(3, 3));
    enuerr(i,:) = xyz2enu(estusr(1: 3)-usrxyz, usrplh);                         % 計算定位誤差並轉至地平座標系
end

%% ---------- 定位誤差評估 : 均方根誤差(RMSE) ------ %%
de = norm(enuerr(:, 1));                                                        % E方向定位誤差
dn = norm(enuerr(:, 2));                                                        % N方向定位誤差
dh = norm(enuerr(:, 3));                                                        % Height方向定位誤差
%===E====%
meanE = sum(enuerr(:, 1))/i;
RESE = enuerr(:, 1) - meanE;
standardE = ((RESE'*RESE)/(i-1))^0.5;
rmse = sqrt(de*de/i);
%===N====%
meanN = sum(enuerr(:, 2))/i;
RESN = enuerr(:, 2)-meanN;
standardN = ((RESN'*RESN)/(i-1))^0.5;
rmsn = sqrt(dn*dn/i);
%===Height====%
meanH = sum(enuerr(:, 3))/i;
RESH = enuerr(:, 3)-meanH;
standardH = ((RESH'*RESH)/(i-1))^0.5;
rmsu = sqrt(dh*dh/i);

%% --------------- Output txt --------------- %%
file = fopen('CK01_output.txt', 'w');
fprintf(file, 'meanE = %9.6f, standardE =%9.6f, rmse = %9.6f\n', meanE, standardE, rmse);
fprintf(file, 'meanN = %9.6f, standardN =%9.6f, rmsn = %9.6f\n', meanN, standardN, rmsn);
fprintf(file, 'meanH = %9.6f, standardH =%9.6f, rmsu = %9.6f\n', meanH, standardH, rmsu);
fprintf(file, 'GDOP_avg = %5.4f\n', mean(GDOP));
fprintf(file, 'PDOP_avg = %5.4f\n', mean(PDOP));
fprintf(file, 'TDOP_avg = %5.4f\n', mean(TDOP));
fprintf(file, 'HDOP_avg = %5.4f\n', mean(HDOP));
fprintf(file, 'VDOP_avg = %5.4f\n', mean(VDOP));

%% ------------------ 繪圖 ------------------ %%
%繪(E,N)方向誤差圖 
figure
subplot(2, 2, 1)
plot(enuerr(:, 1),enuerr(:, 2),'*'), grid
axis square ; axis equal
axis([-20 20 -20 20])
title('GPS Point Positioning Error')
ylabel('north error (m)')
xlabel('east error (m)')
grid on
%繪(Height,時間)誤差圖
subplot(2, 2, 2)
plot(1: aEpoch, enuerr(:, 3), '*'), grid
axis square
axis([0 aEpoch -30 30])
title('GPS Point Positioning Error')
ylabel('height error (m)')
xlabel('epoch')
grid on
%繪(E,時間)方向誤差圖
subplot(2, 2, 3)
plot(1: aEpoch, enuerr(:, 1), '*'), grid
axis square
axis([0 aEpoch -30 30])
title('GPS Point Positioning Error')
ylabel('east error (m)')
xlabel('epoch')
grid on
%繪(N,時間)方向誤差圖
subplot(2, 2, 4)
plot(1: aEpoch, enuerr(:, 2), '*'), grid
axis square
axis([0 aEpoch -30 30])
title('GPS Point Positioning Error')
ylabel('north error (m)')
xlabel('epoch')
grid on
%GDOP繪圖
figure
subplot(2, 3, 1)
plot(GDOP)
axis([0 aEpoch 0 10])
title('GDOP')
xlabel('epoch')
grid on
%PDOP繪圖
subplot(2, 3, 2)
plot(PDOP)
axis([0 aEpoch 0 10])
title('PDOP')
xlabel('epoch')
grid on
%TDOP繪圖
subplot(2, 3, 3)
plot(TDOP)
axis([0 aEpoch 0 10])
title('TDOP')
xlabel('epoch')
grid on
%HDOP繪圖
subplot(2, 3, 4)
plot(HDOP)
axis([0 aEpoch 0 10])
title('HDOP')
xlabel('epoch')
grid on
%VDOP繪圖
subplot(2, 3, 5)
plot(VDOP)
axis([0 aEpoch 0 10])
title('VDOP')
xlabel('epoch')
grid on
%% ----------------- end --------------------- %%
