%% Inertial Sensor Noise Analysis Using Allan Variance
clc; clear; close all;

[file,path] = uigetfile('*.txt','Select IMU data');
disp(string([path,file]));
data = readmatrix(strcat(path, file));

fs = 50;       % IMU frequency 
maxNumM = 1000;  % sampling density
t0 = 1/fs;
scfB = sqrt(2*log(2)/pi);

%% Gyro
for g=2:4
    [tau(:,g-1),adev(:,g-1),N(g-1),B(g-1)] = AllanVar(t0,data(:,g),maxNumM);
    lineN(:,g-1) = N(g-1) ./ sqrt(tau(:,g-1));
    lineB(:,g-1) = B(g-1) * scfB * ones(size(tau(:,g-1)));
end

% disp(['Angle Random Walk ((rad/s)/sqrt(Hz)) :   ', num2str(N(1:3))]);
% disp(['Gyro Bias Instability (rad/s) :   ', num2str(B(1:3))]);
disp(['Angle Random Walk (deg/sqrt(h)) :   ', num2str(N(1:3)*60)]);
disp(['Gyro Bias Instability (deg/h) :   ', num2str(B(1:3)*3600)]);

figure,
loglog(tau(:,1), adev(:,1), tau(:,1), lineB(:,1), ':', tau(:,1), lineN(:,1), ':',...
    tau(:,2), adev(:,2), tau(:,2), lineB(:,2), ':', tau(:,2), lineN(:,2), ':',...
    tau(:,3), adev(:,3), tau(:,3), lineB(:,3), ':', tau(:,3), lineN(:,3), ':','LineWidth', 1.5)
title('Gyro Allan Deviation')
xlabel('\tau')
ylabel('\sigma(\tau)')
legend('Gx \sigma', 'Gx \sigma_B', 'Gx \sigma_N',...
    'Gy \sigma', 'Gy \sigma_B', 'Gy \sigma_N',...
    'Gz \sigma', 'Gz \sigma_B', 'Gz \sigma_N')
grid on
saveas(gcf,[strcat(path,"\", 'Gyro Allan Deviation.png')]);
saveas(gcf,[strcat(path,"\", 'Gyro Allan Deviation.fig')]);

%% Acce
for a=5:7
    [tau(:,a-4),adev(:,a-4),N(a-4),B(a-4)] = AllanVar(t0,data(:,a),maxNumM);
    lineN(:,a-4) = N(a-4) ./ sqrt(tau(:,a-4));
    lineB(:,a-4) = B(a-4) * scfB * ones(size(tau(:,a-4)));
end

% disp(['Velocity Random Walk ((m/s^2)/sqrt(Hz))  :   ', num2str(N(1:3))]);
% disp(['Acce Bias Instability (m/s^2) :   ', num2str(B(1:3))]);
disp(['Velocity Random Walk (m/s/sqrt(h))  :   ', num2str(N(1:3)*60)]);
disp(['Acce Bias Instability (uG) :   ', num2str(B(1:3)/9.8*1000000)]);

figure,
loglog(tau(:,1), adev(:,1), tau(:,1), lineB(:,1), ':', tau(:,1), lineN(:,1), ':',...
    tau(:,2), adev(:,2), tau(:,2), lineB(:,2), ':', tau(:,2), lineN(:,2), ':',...
    tau(:,3), adev(:,3), tau(:,3), lineB(:,3), ':', tau(:,3), lineN(:,3), ':','LineWidth', 1.5)
title('Acce Allan Deviation')
xlabel('\tau')
ylabel('\sigma(\tau)')
legend('Ax \sigma', 'Ax \sigma_B', 'Ax \sigma_N',...
    'Ay \sigma', 'Ay \sigma_B', 'Ay \sigma_N',...
    'Az \sigma', 'Az \sigma_B', 'Az \sigma_N')
grid on    
saveas(gcf,[strcat(path,"\", 'Acce Allan Deviation.png')]);
saveas(gcf,[strcat(path,"\", 'Acce Allan Deviation.fig')]);