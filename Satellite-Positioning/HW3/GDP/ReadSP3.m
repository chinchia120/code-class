function [SP3data,numsat,header] = ReadSP3(filename)

% Read precise satellite orbit from SP3 file
% 
% %%%%%%%%%% HELP %%%%%%%%%%
% 
% [SP3data,numsat,header] = ReadSP3(filename)
% 
% Input Data
% filename = SP3 filename
% 
% Output Data
% SP3data = [GPSweek GPSsec PRN X Y Z clk]
% numsat = number of satellite in SP3 file
% header = header of SP3 file
% *** X Y Z -> km
%     clk -> microsec
%
% Written by  Phakphong Homniam
% December 21, 2002

%%%%%%%%%% BEGIN %%%%%%%%%%

% See if this file has already been read and formatted for MATLAB
save_file = sprintf('%s.mat', deblank(filename));
if exist(save_file) == 2
    file_exists = 1;
else
    file_exists = 0;
end
if file_exists == 1
    load_string = sprintf('load %s', save_file);
    eval(load_string);
    fprintf('Data loaded from existing file, %s.\n', save_file);
    return
end

fprintf('Reading in SP3 data from file %s.\n', filename);

gps_week = [];
gps_sec_start = [];
ep_interval = [];
numsat = [];
gps_sec = [];
header = [];
SP3data = [];
time = [];
gpstime = [];

fid = fopen(filename,'r');

noom = 0;

for i = 1:22
    line = fgetl(fid);
    header = [header;line];
end
while feof(fid) == 0
    line = fgetl(fid);
    if length(line) >= 60
        add = str2num([line(3:4) line(5:18) line(19:32) line(33:46) line(47:60)]);
        SP3data = [SP3data;add];
        continue
    elseif length(line) == 31
        noom = noom+1;
        addtime = str2num(line(4:end));
        time = [time;addtime];
        continue
    else
        continue
    end
end
fclose(fid);

numsat = str2num(header(3,5:6));
for i = 1:size(time,1)
    [gps_week gps_sec] = utc2gps(time(i,:),0);
    add_gpstime(1:numsat,1) = gps_week;
    add_gpstime(1:numsat,2) = gps_sec;
    gpstime = [gpstime;add_gpstime];
end

%%%%%%%% RESULT %%%%%%%%
       
SP3data = [gpstime SP3data];
numsat;
header;    

save_string = sprintf('save %s', save_file);
eval(save_string);

%%%%%%%%%% END %%%%%%%%%%
    