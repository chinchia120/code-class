%% ========== Setup ========== %%
% ===== Setup
clc; clear; close all;

% ===== Initial Value
sec = zeros(49, 2);

%% ========== Read Dataset ========== %%
% ===== Read Folder
FolderPath = uigetdir(pwd, 'Select Folder');

% ===== Read Station
stafile = [FolderPath '/sta.dat'];
stafile = fopen(stafile);
stadata = textscan(stafile, '%f %f %s', 'Delimiter', '\t');
fclose(stafile);

% ===== Read Displacement
dis = [FolderPath '/comfilt.out'];
disfile = fopen(dis);
i = 0;
while ~feof(disfile)
    i = i+1;
    distmp = fgetl(disfile);
    disspt = strsplit(distmp, ' ');

    if mod(i, 10) == 4
        sec(int32(i/10)+1, 1) = str2double(disspt(4));
    elseif mod(i, 10) == 5
        sec(int32(i/10), 2) = str2double(disspt(4));
    end
end
fclose(disfile);

%% ========== Creat Output Folder ========== %%
OutputFolder = sprintf([FolderPath '_secular']);
if ~exist(OutputFolder, 'dir'); mkdir(OutputFolder); end

%% ========== Station Secular Format ========== %%
OutputFile = sprintf([OutputFolder '/StationSecular.dat']);
fid = fopen(OutputFile, 'w');
for i = 1: length(sec)
    Sta = stadata{1,3}{i};
    Lat = stadata{1,1}(i);
    Lon = stadata{1,2}(i);
    fprintf(fid, '%s\t%7.4f\t%6.4f\t%7.4f\t%7.4f\t0.01\t0.01\r\n', Sta, Lat, Lon, sec(i,1:2));
end
fclose(fid);