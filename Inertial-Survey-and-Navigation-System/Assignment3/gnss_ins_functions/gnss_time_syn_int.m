%   GNSS Time Synchronization and Interpolation with respect to IMU Data Rate
function [gps_pos_lla, gps_vel_ned, inter_gnss,f_imu] = gnss_time_syn_int(f_gnss, f_imu)
%   GNSS file
t_gnss_start = f_gnss(1,1); t_gnss_second = f_gnss(2,1); t_gnss_end = f_gnss(end,1);
gnss_rate = round(1/(t_gnss_second-t_gnss_start), 1); gnss_count = size(f_gnss, 1);

%   IMU file
t_imu_start = f_imu(1,1); t_imu_second = f_imu(2,1); t_imu_end = f_imu(end,1);
imu_rate = round(1/(t_imu_second-t_imu_start), 1); imu_count = size(f_imu, 1);

%   Time synchronization and interpolation
cnt = 1;
while (t_imu_start < t_gnss_end)
    cnt = cnt + 1;
    t_imu_start = f_imu(cnt,1);
end

inter_gnss = zeros((cnt-1), 13);
gnss_row = 2;
count=0;
for i = 1:imu_count
    t_imu_start = f_imu(i,1);
    if (t_imu_start > t_gnss_end)
        break;
    end

    if (t_imu_start > t_gnss_second)
        gnss_row = gnss_row + 1;
        if (gnss_row > length(f_gnss))
            gnss_row = length(f_gnss);
        end
        t_gnss_start = f_gnss(gnss_row-1,1);
        t_gnss_second = f_gnss(gnss_row,1);
    end
    dt_gnss=t_gnss_second - t_gnss_start;
    
    if dt_gnss>1    %GNSS outage
       for j = 1:13
            if (j == 1)
                inter_gnss(i, 1) = t_imu_start;
            else
                inter_gnss(i,j) = NaN;
            end
        end
    else             %interpolation
        for j = 1:13
            if (j == 1)
                inter_gnss(i, 1) = t_imu_start;
            else
                inter_gnss(i,j) = f_gnss(gnss_row,j) - ...
                    ((f_gnss(gnss_row,j) - f_gnss(gnss_row-1,j))/((t_gnss_second - t_gnss_start)/(t_gnss_second - t_imu_start)));
            end
        end
    end        

                               
end
d2r = pi/180;           %   Degrees to radians

gps_pos_lla(:, 1) = inter_gnss(:, 2).*d2r;
gps_pos_lla(:, 2) = inter_gnss(:, 3).*d2r;
gps_pos_lla(:, 3) = inter_gnss(:, 4);
gps_vel_ned(:, 1:3) = inter_gnss(:, 5:7);

end