%% Inertial Sensor Noise Analysis Using Allan Variance
% reference: https://www.mathworks.com/help/fusion/ug/inertial-sensor-noise-analysis-using-allan-variance.html
% from Peggy Hsu's code, 2021,09
% modified by Chi-Hsin Huang, 2023,10 


clear all ;close all

% read data
[file,path] = uigetfile({'*.txt';'*.csv'},'Select IMU data');
filepath = fullfile(path, file);
disp(filepath);
data = readmatrix(filepath);

% set data format
Timestamp = data(:,1);
IMUdata = [data(:,2:4) data(:,5:7)];
% [~,TF] = rmoutliers(vecnorm(IMUdata(:,1:3),2,2),'mean');
% IMUdata=IMUdata(~TF,:);
% [~,TF] = rmoutliers(vecnorm(IMUdata(:,4:6),2,2),'mean');
% IMUdata=IMUdata(~TF,:);

fs = 1/mean(diff(Timestamp));       % IMU frequency 
maxNumM = 100;  % sampling density
t0 = 1/fs;
scfB = sqrt(2*log(2)/pi);

arw_tau_lim = 10^2;% tau smaller than 10e2
arrw_tau_lim = 10^1;% tau larger than 10e1
gb_tau_lim = [10^0,10^3];% tau between 10e0 and 10e3
vrw_tau_lim = 10^2;
acrw_tau_lim = 10^1;
ab_tau_lim = [10^0,10^3];

%% Gyro
for g=1:3
    [tau(:,g),adev(:,g),N(g),K(g),B(g),tauB(g)] = AllanVar(t0,IMUdata(:,g),maxNumM,...
                                                  arw_tau_lim,arrw_tau_lim,gb_tau_lim);
    lineN(:,g) = N(g) ./ sqrt(tau(:,g));
    lineK(:,g) = K(g) .* sqrt(tau(:,g)/3);
    lineB(:,g) = B(g) * scfB * ones(size(tau(:,g)));
end
arw(:,1)=N(1:3)';
arrw(:,1)=K(1:3)';
gbi(:,1)=B(1:3)';
gbtau(:,1)=tauB';
arw(:,2)=rad2deg(N(1:3)')*60;
arrw(:,2)=rad2deg(K(1:3)')/60;
gbi(:,2)=rad2deg(B(1:3)')*3600;
gbtau(:,2)=tauB'/3600;

figure,
loglog(tau(:,1), adev(:,1), tau(:,1), lineB(:,1), ':', tau(:,1), lineN(:,1), ':', tau(:,1), lineK(:,1), ':',...
       tau(:,2), adev(:,2), tau(:,2), lineB(:,2), ':', tau(:,2), lineN(:,2), ':', tau(:,2), lineK(:,2), ':',...
       tau(:,3), adev(:,3), tau(:,3), lineB(:,3), ':', tau(:,3), lineN(:,3), ':', tau(:,3), lineK(:,3), ':','LineWidth', 1.5)
title('Gyro Allan Deviation')
xlabel('\tau(s)')
ylabel('\sigma(\tau)')
legend('Gx \sigma', 'Gx \sigma_B', 'Gx \sigma_N', 'Gx \sigma_K',...
    'Gy \sigma', 'Gy \sigma_B', 'Gy \sigma_N', 'Gy \sigma_K',...
    'Gz \sigma', 'Gz \sigma_B', 'Gz \sigma_N', 'Gz \sigma_K')
grid on
saveas(gcf,[strcat(path,"\", 'Gyro Allan Deviation.png')]);
saveas(gcf,[strcat(path,"\", 'Gyro Allan Deviation.fig')]);

%% Acce
for a=4:6
    [tau(:,a-3),adev(:,a-3),N(a-3),K(a-3),B(a-3),tauB(a-3)] = AllanVar(t0,IMUdata(:,a),maxNumM,...
                                                              vrw_tau_lim,acrw_tau_lim,ab_tau_lim);
    lineN(:,a-3) = N(a-3) ./ sqrt(tau(:,a-3));
    lineK(:,a-3) = K(a-3) .* sqrt(tau(:,a-3)/3);
    lineB(:,a-3) = B(a-3) * scfB * ones(size(tau(:,a-3)));
end
vrw(:,1)=N(1:3)';
acrw(:,1)=K(1:3)';
abi(:,1)=B(1:3)';
abtau(:,1)=tauB';
vrw(:,2)=N(1:3)'*60;
acrw(:,2)=K(1:3)'/60;
abi(:,2)=B(1:3)'*100000;
abtau(:,2)=tauB'/3600;


figure,
loglog(tau(:,1), adev(:,1), tau(:,1), lineB(:,1), ':', tau(:,1), lineN(:,1), ':', tau(:,1), lineK(:,1), ':',...
       tau(:,2), adev(:,2), tau(:,2), lineB(:,2), ':', tau(:,2), lineN(:,2), ':', tau(:,2), lineK(:,2), ':',...
       tau(:,3), adev(:,3), tau(:,3), lineB(:,3), ':', tau(:,3), lineN(:,3), ':', tau(:,3), lineK(:,3), ':','LineWidth', 1.5)
title('Acce Allan Deviation')
xlabel('\tau(s)')
ylabel('\sigma(\tau)')
legend('Ax \sigma', 'Ax \sigma_B', 'Ax \sigma_N', 'Ax \sigma_K',...
    'Ay \sigma', 'Ay \sigma_B', 'Ay \sigma_N', 'Ay \sigma_K',...
    'Az \sigma', 'Az \sigma_B', 'Az \sigma_N', 'Az \sigma_K')
grid on    
saveas(gcf,[strcat(path,"\", 'Acce Allan Deviation.png')]);
saveas(gcf,[strcat(path,"\", 'Acce Allan Deviation.fig')]);
%% save data

t = table(arw(:,1),arw(:,2),arrw(:,1),arrw(:,2),gbi(:,1),gbi(:,2),gbtau(:,1),gbtau(:,2),vrw(:,1),vrw(:,2),acrw(:,1),acrw(:,2),abi(:,1),abi(:,2),abtau(:,1),abtau(:,2));
t.Properties.VariableNames={'ARW((rad/s)/sqrt(Hz))','ARW((deg/s)/sqrt(h))','ARRW((rad/s)sqrt(Hz))','ARRW((deg/s)sqrt(h))',...
                            'GBI(rad/s)','GBI(deg/h)','GBT(s)','GBT(h)',...
                            'VRW((m/s^2)/sqrt(Hz))','VRW((m/s)/sqrt(h))','ACRW((m/s^2)/sqrt(Hz))','ACRW((m/s^2)/sqrt(h))',...
                            'ABI(m/s^2)','ABI(mGal)','ABT(s)','ABT(h)'};
disp(t)
writetable(t,strcat(path,"\", 'Allan variance.csv'));