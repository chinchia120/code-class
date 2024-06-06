%   GPS time synchronization and interpolation for GNSS to IMU rate

%   GNSS file
[filename_gnss, pathname_gnss, filterindex_gnss] = uigetfile('*.txt', 'Select GNSS file');
f_gnss = load([pathname_gnss filename_gnss]);
[nRow_gnss, nCol_gnss] = size(f_gnss);
t_gnss_start = f_gnss(1,1); t_gnss_second = f_gnss(2,1); t_gnss_end = f_gnss(end,1);
gnss_rate = round(1/(t_gnss_second-t_gnss_start), 1); gnss_count = size(f_gnss, 1);

%   IMU file
[filename_imu, pathname_imu, filterindex_imu] = uigetfile('*.txt', 'Select IMU file');
f_imu = load([pathname_imu filename_imu]);
[nRow_imu, nCol_imu] = size(f_imu);
t_imu_start = f_imu(1,1); t_imu_second = f_imu(2,1); t_imu_end = f_imu(end,1);
imu_rate = round(1/(t_imu_second-t_imu_start), 1); imu_count = size(f_imu, 1);

%   Time synchronization and interpolation
cnt = 1;
while (t_imu_start < t_gnss_end)
    cnt = cnt + 1;
    t_imu_start = f_imu(cnt,1);
end

inter_gnss = zeros((cnt-1), 7);
gnss_row = 2;
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
    
    
    for j = 1:7
        if (j == 1)
            inter_gnss(i, 1) = t_imu_start;
        else
            inter_gnss(i,j) = f_gnss(gnss_row,j) - ...
            ((f_gnss(gnss_row,j) - f_gnss(gnss_row-1,j))/((t_gnss_second - t_gnss_start)/(t_gnss_second - t_imu_start)));
        end
   end
                               
end

gps_pos_lla(:, 1:3) = inter_gnss(:, 2:4);
gps_vel_ned(:, 1:3) = inter_gnss(:, 5:7);

