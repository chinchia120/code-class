%===========================================================%
%               gnss_ins_filter_config.m                    %
%                                                           %
%   This m-file contains all the conifiguraiton switches    %
%   for the GNSS/INS filter.                                %
%                                                           %
%   Programmer:     Demoz Gebre-Egziabher                   %
%   Created:        March 26, 2009                          %
%   Last Modified:  March 26, 2009                          %
%                                                           %
%   Copywrite 2009 Demoz Gebre-Egziabher                    %
%   License: BSD, see bsd.txt for details                   %
%===========================================================%


%   Configure the Extended Kalman Filter (EKF)

CLOSED_LOOP = 1;        %   If set to 1, a GNSS-aided
%   inertial navigator is simulated.
%   If set to 0, the simulation will
%   be that of an unaided INS.

NO_CORIOLIS = 1;        %   If set to 1, coriolis acceleraitons
%   are ignored in the time upadate
%   equations. Should be set to 0 when
%   using high grade inertial sensors and
%   GNSS updates come at a slow rate.

SMALL_PROP_TIME = 1;    %   If set to 1, it means that the time
%   between GNSS updates is small and,
%   thus, Schuler dynamics can be
%   ignored without much consequence.
%   That is, the approximation given by
%   Equation (6.17) is used for the
%   velocity propagation instead of
%   Equation (6.13)

%% set data path
%======================================%
imupath = 'data\imu_pointer.txt';
gnsspath= 'data\gnss_data_pointer.txt';
%======================================%

%% GNSS measurement update rate in Hz
gnss_update_rate = 1;

%% GPS measurement noise standard deviation ratio
%======================================%
gps_pos_sigma_ratio = 1;
gps_vel_sigma_ratio = 1;
%======================================%

%% IMU output error covariance
%======================================%
% Gyro Bias Instability  (rad/s)->(rad/hr)
% If the code crash in GNSS outage,try to set sigma_g_d_x=(1e-06)*3600 and sigma_g_d_y=(1e-06)*3600;
sigma_g_d_x = (1e-06)*3600;sigma_g_d_y= (1e-06)*3600;sigma_g_d_z= (3.7399e-06)*3600;
sigma_g_d=[sigma_g_d_x sigma_g_d_y sigma_g_d_z]*0.01;

% Angle Random Walk      (rad/s/sqrt(Hz))
sigma_g_w_x = (5.4886e-5);sigma_g_w_y = (6.1957e-5);sigma_g_w_z = (8.2915e-5);
sigma_g_w = [sigma_g_w_x sigma_g_w_y sigma_g_w_z];

% Acce Bias Instability     (m/s^2)
sigma_a_d_x = (0.00044697);sigma_a_d_y = (0.00044448);sigma_a_d_z = (0.00175);
sigma_a_d = [sigma_a_d_x sigma_a_d_y sigma_a_d_z]*0.01;

% Velocity Random Walk (m/s^2/sqrt(Hz))
sigma_a_w_x = (0.00042294);sigma_a_w_y = (0.00043086);sigma_a_w_z = (0.00345);
sigma_a_w = [sigma_a_w_x  sigma_a_w_y  sigma_a_w_z ];

%======================================%
tau_g = 3600;                     % Correlation time or time constant of b_{gd} (s)
tau_a = 3600;                     % Correlation time or time constant of b_{ad} (s)

%% Initial attitude
%======================================%
init_att = [0, 0, 0];            % [roll, pitch, yaw]; (deg.)
%======================================%
