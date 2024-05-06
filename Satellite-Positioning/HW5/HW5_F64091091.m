clc;
clear all;
close all;

%% ---------- initial value ---------- %%
usrxyz = [-2956584.492, 5075878.999, 2476667.613];
usrplh = xyz2llh(usrxyz);

%% ---------- import file ---------- %%
filename = "CK01.csv";
fid = fopen(filename);

%% ---------- check data ---------- %%
cnt = 1;
while ~feof(fid)
    tmp = fgetl(fid);
    tmp = (strsplit(tmp, ','));
    obs(cnt, :) = [deg2rad(str2double(tmp(1: 2))), str2double(tmp(3))];
    cnt = cnt + 1;
end
obs = obs( 2: size(obs, 1), : );

%% ---------- calculate error ---------- %%
for i = 1: size(obs, 1)
    xyz = llh2xyz(obs(i, :));
    enuerr(i, :) = xyz2enu(xyz-usrxyz, usrplh)*100; 
end

%% ---------- make plot ---------- %%
title_ = ['Precise Point Positioning'];
figure(1);
subplot(2, 2, 1);
plot(enuerr(:, 1), enuerr(:, 2), '*'), grid;
axis('square');
axis('equal');
axis([-10, 10, -10, 10]);
title(title_);
ylabel('dn (cm)');
xlabel('de (cm)');

subplot(2, 2, 2);
plot(1: i, enuerr(:, 3), '*'), grid;
axis([1, i, -40, 40]);
title(title_);
ylabel('du (cm)');
xlabel('epochs');

subplot(2, 2, 3);
plot(1: i, enuerr(:, 1), '*'), grid;
axis([1, i, -10, 10]);
title(title_);
ylabel('de (cm)');
xlabel('epochs');

subplot(2, 2, 4);
plot(1: i, enuerr(:, 2), '*'), grid;
axis([1, i, -10, 10]);
title(title_);
ylabel('dn (cm)');
xlabel('epochs');

%% ---------- save plot ---------- %%
saveas(gcf, 'Precise_Point_Positioning_Error.png');

%% ----- calculate precision and RMS ----- %%
de = norm(enuerr(:, 1));
meanE = sum(enuerr(:, 1))/i;
RESE = enuerr(:, 1)-meanE;
standardE = ((RESE'*RESE)/(i-1))^0.5;
rmse = sqrt(de*de/i);

dn = norm(enuerr(:, 2)); 
meanN = sum(enuerr(:, 2))/i;
RESN = enuerr(:, 2)-meanN;
standardN = ((RESN'*RESN)/(i-1))^0.5;
rmsn = sqrt(dn*dn/i);

dh = norm(enuerr(:, 3));
meanH = sum(enuerr(:, 3))/i;
RESH = enuerr(:, 3)-meanH;
standardH = ((RESH'*RESH)/(i-1))^0.5;
rmsu = sqrt(dh*dh/i);

%% ----- output txt ----- %%
file = fopen('CK01_output.txt', 'w');
fprintf(file, '%%%% ----- Differential Positioning of Carrier Phase Summary ----- %%%%\n\n');
fprintf(file, 'meanE = %10.6f(cm), standardE = %9.6f(cm), rmse = %10.6f(cm)\n', meanE, standardE, rmse);
fprintf(file, 'meanN = %10.6f(cm), standardN = %9.6f(cm), rmsn = %10.6f(cm)\n', meanN, standardN, rmsn);
fprintf(file, 'meanH = %10.6f(cm), standardH = %9.6f(cm), rmsu = %10.6f(cm)\n\n', meanH, standardH, rmsu);
fprintf(file, '2D error = %6.6f(cm), 3D error = %6.6f(cm)\n', sqrt(rmse^2+rmsn^2), sqrt(rmse^2+rmsn^2+rmsu^2));
