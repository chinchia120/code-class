%===========================================================%
%                       plot_EKF_output.m                   %
%                                                           %
%   This m-script plots the figures for Case Study 1 shown  %
%   shown.                                                  %
%                                                           %
%   Programmer:     Demoz Gebre-Egziabher                   %
%   Created:        March 26, 2009                          %
%   Last Modified:  June 26, 2009                           %
%                                                           %
%                                                           %
%   Copywrite 2009 Demoz Gebre-Egziabher                    %
%   License: BSD, see bsd.txt for details                   %
%===========================================================%
close all;

OutputFolder = sprintf('OutputFigure');
if ~exist(OutputFolder, 'dir'); mkdir(OutputFolder); end

%   Plot Trajectory lat lon
figure
subplot(3,3,[1 6])
geoscatter(pos_ins(1:k, 1)*r2d, pos_ins(1:k, 2)*r2d, '.'); hold on;
geoscatter(inter_gnss(1:50:end, 2), inter_gnss(1:50:end, 3), '.');
text(inter_gnss(1, 2),inter_gnss(1, 3),'Start')
text(inter_gnss(end, 2),inter_gnss(end, 3),'End')
legend('GNSS/INS solution', 'GNSS solution');
title('Trajectory');
%   Plot Height 
subplot(3,3,[7 9])
plot(t, pos_ins(1:k, 3), '.'); hold on;
plot(t(1:50:end),inter_gnss(1:50:end, 4), '.'); 
xlabel('time (s)');ylabel('Height');
grid on;
legend('GNSS/INS solution', 'GNSS solution');
title('Height');

%   Plot Attitude Estimates
for k=1:size(eul_ins,1)
    for q=1:3
        if eul_ins(k,q)<-pi
            eul_ins(k,q)=eul_ins(k,q)+2*pi;
        end
        if eul_ins(k,q)>pi
            eul_ins(k,q)=eul_ins(k,q)-2*pi;
        end
    end
end

saveas(gcf, [OutputFolder, '\Trajectory.png']);

figure
subplot(311)
plot(t,eul_ins(:,3)*r2d,'r-','linewidth',2);
legend('GNSS/INS solution');
title('Yaw angle');
xlabel('time (s)');
ylabel('\psi (deg)');
grid on;
    
subplot(312)
plot(t,eul_ins(:,2)*r2d,'g-','linewidth',2);
legend('GNSS/INS solution');
title('Pitch angle');
xlabel('time (s)');
ylabel('\theta (deg)');
grid on;

subplot(313)
plot(t,eul_ins(:,1)*r2d,'b-','linewidth',2);
legend('GNSS/INS solution');
title('Roll angle');
xlabel('time (s)');
ylabel('\phi (deg)');
grid on;
sgtitle('Attitude')

saveas(gcf, [OutputFolder, '\Attitude.png']);