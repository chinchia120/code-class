clc;
clear all; 
close all;
%% ----- make new folder ----- %%
[status, msg, msgID] = mkdir('picture');

%% ----- import data ----- %%
load('CN11toCK01.mat');                                                % 自行輸入Input檔名
refxyz = [-2956512.954, 5076009.984, 2476577.501];                     % 自行輸入參考站已知座標值(X,Y,Z)
usrxyz = [-2956584.492, 5075878.999, 2476667.613];                     % 自行輸入待測站已知座標值(X,Y,Z)(評估定位誤差用)
ref_ant_h = 0.000;                                                     % 自行輸入參考站天線高
usr_ant_h = 1.700;                                                     % 自行輸入待測站天線高

refplh = xyz2llh(refxyz);
refplh(3) = refplh(3) + ref_ant_h;
refxyz = llh2xyz(refplh);
usrplh = xyz2llh(usrxyz);
usrplh(3) = usrplh(3) + usr_ant_h;
usrxyz = llh2xyz(usrplh);

%% ----- differential positioning ----- %%
disp(' Performing Differential Positioning ... ');
for ep = 1: size(La{1,1}.NSAT(:))
   if La{1, 1}.NSAT(ep) >= 4
       n = La{1,1}.NSAT(ep);                                           % n=衛星顆數
       for u = 1: n
           prn = La{1,1}.IDMAT(ep,u+2);
           svenu = xyz2enu(La{1, 1}.SVMAT(u, :, ep)-usrxyz, usrplh);
           el(prn) = (180/pi)*atan(svenu(3)/norm(svenu(1:2)));
           obs(u,:) = [La{1,1}.CODE(u, 1, ep), La{1, 1}.CODE(u, 2, ep)];
           svids(u,:) = [prn,prn];
       end             
       [ddPR, ddprns] = build2d(n, svids, obs, el);                    % ddPR=二次差分電碼觀測量Pkl_12(向量)
       clear svmat drho newo;
       for v = 1: length(ddprns)
           prn = ddprns(v);
           if v == 1
               rhok1 = norm(La{1, 1}.SVMAT(v, :, ep) - refxyz);        % 主要衛星與參考站的距離
               svmat(1, :) = La{1, 1}.SVMAT(v, :, ep);
           else
               rhol1 = norm(La{1, 1}.SVMAT(v, :, ep) - refxyz);        % 次要衛星與參考站的距離
               drho(v-1) = rhok1 - rhol1;                              % 以上兩種距離之差值(向量)
               svmat(v, :) = La{1, 1}.SVMAT(v, :, ep);
           end
       end
       
       if length(ddPR) >= 3
           estusr = usrxyz;
           m = length(ddPR);                                           % m=二次差分電碼觀測量的個數
           svref = svmat(1, :);                                        % 主要衛星座標
           svdif = svmat(2: end, :);                                   % 次要衛星座標
           maxiter = 10;
           iter = 0;
           clear A P y;      
           D = [ones(m, 1), -1*diag(ones(1, m)), -1*ones(m, 1), diag(ones(1, m))];
           P = inv(D*D');                                              % 計算權矩陣P(m by m) (注意需要經過誤差傳播)
           while (iter < maxiter && (iter == 0 || norm(x) > 1e-3))
                for u = 1:m  
                    dk0 = svref(1, :) - estusr;                        % 待測站起始值至主要衛星之向量
                    dl0 = svdif(u, :) - estusr;                        % 待測站起始值至次要衛星之向量             
                    rhok0 = norm(dk0);                                 % 待測站起始值至主要衛星的距離
                    rhol0 = norm(dl0);                                 % 待測站起始值至次要衛星的距離
                    O = ddPR(u) - drho(u);                             % O=Okl_12
                    y(u,1) = O - (-rhok0+rhol0);                       % 加入一個元素至觀測量向量y
                    A(u,:) = [dk0/rhok0 - dl0/rhol0];                  % 加入一列元素至設計矩陣A  
                end
                x = inv(A'*P*A)*A'*P*y;                                % Least-squares計算待測站起始值的改正量
                estusr = estusr + x';                                  % 更新待測站座標   
                iter = iter + 1;
           end
       end
       enuerr(ep, :) = xyz2enu(estusr(1: 3)-usrxyz, usrplh);           % 計算定位誤差並轉至地平座標系統
   end
end

%% ----- calculate precision and RMS ----- %%
de = norm(enuerr(:, 1));                                               % E方向定位誤差
dn = norm(enuerr(:, 2));                                               % N方向定位誤差                
dh = norm(enuerr(:, 3));                                               % Height方向定位誤差          
meanE = sum(enuerr(:, 1))/ep;
RESE = enuerr(:, 1)-meanE;
standardE = ((RESE'*RESE)/(ep-1))^0.5;
rmse = sqrt(de*de/ep);

meanN = sum(enuerr(:, 2))/ep;
RESN = enuerr(:, 2)-meanN;
standardN = ((RESN'*RESN)/(ep-1))^0.5;
rmsn = sqrt(dn*dn/ep);

meanH = sum(enuerr(:, 3))/ep;
RESH = enuerr(:, 3)-meanH;
standardH = ((RESH'*RESH)/(ep-1))^0.5;
rmsu = sqrt(dh*dh/ep);

%% ----- output txt ----- %%
file = fopen('CN11toCK01_output.txt', 'w');
fprintf(file, '%%%% ----- Differential Positioning Summary ----- %%%%\n\n');
fprintf(file, 'meanE = %6.6f, standardE = %6.6f, rmse = %6.6f\n', meanE, standardE, rmse);
fprintf(file, 'meanN = %6.6f, standardN = %6.6f, rmsn = %6.6f\n', meanN, standardN, rmsn);
fprintf(file, 'meanH = %6.6f, standardH = %6.6f, rmsu = %6.6f\n\n', meanH, standardH, rmsu);

fprintf(file, '2D error = %6.6f(m), 3D error = %6.6f(m)\n', sqrt(rmse^2+rmsn^2), sqrt(rmse^2+rmsn^2+rmsu^2));

%% ----- make plot ----- %%
figure(1);
subplot(2, 2, 1);
plot(enuerr(:, 1), enuerr(:, 2), '*'), grid;
axis('square');
axis('equal');
axis([-2 2 -2 2]);
title(' DGPS Positioning Error ');
ylabel('dn (m)');
xlabel('de (m)');

subplot(2, 2, 2);
plot(1: ep, enuerr(:, 3), '*'), grid;
axis([1 ep -5 5]);
title(' DGPS Positioning Error');
ylabel('du (m)');
xlabel('epochs');

subplot(2, 2, 3);
plot(1: ep, enuerr(:, 1), '*'), grid;
axis([1 ep -2 2]);
title(' DGPS Positioning Error');
ylabel('de (m)');
xlabel('epochs');

subplot(2, 2, 4);
plot(1: ep, enuerr(:, 2), '*'), grid;
axis([1 ep -2 2 ]);
title(' DGPS Positioning Error');
ylabel('dn (m)');
xlabel('epochs');

%% ----- save plot ----- %%
saveas(gcf, './picture//DGPS_Positioning_Error.png');

disp(' End of Differential Positioning ... ');