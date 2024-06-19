%=======================================================%
%               gnss_ins_data_loader.m                  %
%                   (MATLAB Version)                    %
%                                                       %
%   This m-file loads in data that will be played back  %
%   in the GNSS/INS EKF.  The data was collected from   %
%   flight test onboard a small hand launched aerial    %
%   vehicle and is contained in the file named          %
%   flight_test_data_set.mat.                           %
%                                                       %
%   Programmer:     Demoz Gebre-Egziabher               %
%   Created:        March 26, 2009                      %
%   Last Modified:  June 26, 2009                       %
%                                                       %
%   Copywrite 2009 Demoz Gebre-Egziabher                %
%   License: BSD, see bsd.txt for details               %
%=======================================================%



imu = load(imupath);
gnss = load(gnsspath);
gnss(:,1) = gnss(:,1)/1000;

%   Establish initial value for inertial sensor biases
initial_gyro_bias = -mean(imu(1:7000,2:4));
initial_accel_bias = -(mean(imu(1:7000,5:7)) + [0 0 g]);

% GNSS Time Synchronization and Interpolation with respect to IMU Data Rate
[gps_pos_lla, gps_vel_ned, inter_gnss, imu] = gnss_time_syn_int(gnss, imu);
t = inter_gnss(:,1);
drl = length(gps_pos_lla);


