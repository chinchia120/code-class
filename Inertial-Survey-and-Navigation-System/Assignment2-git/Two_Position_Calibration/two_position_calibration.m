%% Data Loader
format longG;
clc;
clear all;
close all;

theta = [0 180];
% we  = rad2deg(7.2921150*10^-5)`;  % deg/sec
we  = 7.2921150*10^-5;
g   = -9.7890191;                 % m/s^2

filepath = uigetdir('*.*',"Choose the GPS folder ");
filelist = dir(fullfile(filepath,'*.txt'));
filenum = length(filelist);
filelist = string({filelist.name});

for i = 1:filenum
    GPSdata = readmatrix(strcat(filepath,"\", filelist(i)),'NumHeaderLines',1);
    GPSdata = GPSdata(:,2);
    GPS(i).position = GPSdata;
    phi(i)= mean(rmoutliers(GPS(i).position(:),'mean'));
end

filepath = uigetdir('*.*',"Choose the IMU folder ");
filelist = dir(fullfile(filepath,'*.txt'));
filenum = length(filelist);
filelist = string({filelist.name});

for i = 1:filenum
    IMUdata = readmatrix(strcat(filepath,"\", filelist(i)),'NumHeaderLines',1);
    IMUdata = IMUdata(:,1:7);
    IMU(i).position = IMUdata;
end

%% 1 Case
for i = 1:2   % 1 = UP, 2 = DOWN
    gyro_case1x(i) = mean(rmoutliers(IMU(i).position(:,2),'mean'));
    gyro_case1y(i) = mean(rmoutliers(IMU(i).position(:,3),'mean'));
    gyro_case1z(i) = mean(rmoutliers(IMU(i).position(:,4),'mean'));
  
    acc_case1x(i) = mean(rmoutliers(IMU(i).position(:,5),'mean'));
    acc_case1y(i) = mean(rmoutliers(IMU(i).position(:,6),'mean'));
    acc_case1z(i) = mean(rmoutliers(IMU(i).position(:,7),'mean'));
end

%% Figure for check the position correct
figure;
subplot(1,2,1);hold on;grid on
plot(gyro_case1x);plot(gyro_case1y);plot(gyro_case1z);
ylabel('[deg/s]');xlabel('position');
legend('x','y','z');
for i=1:size(theta,2)
    text(i,0,string(theta(i)))
end
title('Gyro case1: Z axis upward and downward')

subplot(1,2,2);hold on;grid on
plot(acc_case1x);plot(acc_case1y);plot(acc_case1z);
ylabel('[m/s^2]');xlabel('position');
legend('x','y','z');
for i=1:size(theta,2)
    text(i,0,string(theta(i)))
end
title('Acc case1: Z axis upward and downward')
sgtitle('test value');

%% gyro
% gyr_A = [-we*sind(phi(1)) 1; 
%          -we*sind(phi(2))*(-1) 1];
gyr_A = [-we*sin(phi(1)) 1; 
         -we*sin(phi(2))*(-1) 1];

gyr_L = [gyro_case1z'];

gyr_Parameter = inv(gyr_A'*gyr_A)*gyr_A'*gyr_L;
% gyr_V = gyr_A*gyr_Parameter-gyr_L;

gyr_Parameter
gyr_bias = gyr_Parameter(2)
gyr_scale = gyr_Parameter(1)-1

%% acc
acc_A = [g 1; 
         -g 1];
acc_L = [acc_case1z'];

acc_Parameter = inv(acc_A'*acc_A)*acc_A'*acc_L;
% acc_V = acc_A*acc_Parameter-acc_L;

acc_Parameter 
acc_bias = acc_Parameter(2)
acc_scale = acc_Parameter(1)-1

%% plot
gyr_A_p = ones(93285,1)*gyr_A(1,1);
acc_A_p = ones(93285,1)*acc_A(2,1);
gyr_A_n = ones(93285,1)*gyr_A(2,1);
acc_A_n = ones(93285,1)*acc_A(1,1);

figure;
plot(IMUdata(1:93285,1), gyr_A_p, 'LineWidth',2);
hold on
plot(IMUdata(1:93285,1), IMU(1).position(1:93285,4), 'LineWidth',2);
plot(IMUdata(1:93285,1), IMU(2).position(1:93285,4), 'LineWidth',2);
plot(IMUdata(1:93285,1), gyr_A_n, 'LineWidth',2);
plot(IMUdata(1:93285,1), gyr_A_n*(gyr_scale+1)+gyr_bias, 'LineWidth',2);
title('gyro vs time')
legend('gyr_A positive', 'gyr original 1', 'gyr original 2', 'gyr_A negative', 'gyr_A * scale + bias')
xlabel('time(s)')
ylabel('gyro value')

figure;
plot(IMUdata(1:93285,1), acc_A_p, 'LineWidth',2);
hold on
plot(IMUdata(1:93285,1), IMU(2).position(1:93285,7), 'LineWidth',2);
plot(IMUdata(1:93285,1), acc_A_p*(acc_scale+1)+acc_bias, 'LineWidth',2);
title('accelerometer vs time (positive)')
legend('acc_A positive', 'acc original 2', 'acc_A * scale + bias')
xlabel('time(s)')
ylabel('acce value')

figure;
plot(IMUdata(1:93285,1), IMU(1).position(1:93285,7), 'LineWidth',2);
hold on
plot(IMUdata(1:93285,1), acc_A_n, 'LineWidth',2);
plot(IMUdata(1:93285,1), acc_A_n*(acc_scale+1)+acc_bias, 'LineWidth',2);
title('accelerometer vs time (negative)')
legend('acc original 1', 'acc_A negative', 'acc_A * scale + bias')
xlabel('time(s)')
ylabel('acce value')
