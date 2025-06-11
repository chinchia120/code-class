%% ========== Setup ========== %%
% ===== Setup
clc; clear; close all;

% ===== Initial Value
secstd = zeros(49, 6);

%% ========== Read Dataset (32_P66134111_filter1) ========== %%
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
        secstd(int32(i/10)+1, 1) = str2double(disspt(4));
        secstd(int32(i/10)+1, 4) = str2double(disspt(6));
    elseif mod(i, 10) == 5
        secstd(int32(i/10), 2) = str2double(disspt(4));
        secstd(int32(i/10), 5) = str2double(disspt(6));
    elseif mod(i, 10) == 6
        secstd(int32(i/10), 3) = str2double(disspt(4));
        secstd(int32(i/10), 6) = str2double(disspt(6));
    end
end
fclose(disfile);

%% ========== Creat Output Folder ========== %%
OutputFolder = sprintf([FolderPath '_secular_std']);
if ~exist(OutputFolder, 'dir'); mkdir(OutputFolder); end

%% ========== Station Secular Format ========== %%
OutputFileh = sprintf([OutputFolder '/interseismic_velh.dat']);
OutputFileu = sprintf([OutputFolder '/interseismic_velu.dat']);
fidh = fopen(OutputFileh, 'w');
fidu = fopen(OutputFileu, 'w');

for i = 1: length(secstd)
    Lat = stadata{1,1}(i);
    Lon = stadata{1,2}(i);

    fprintf(fidh, '%7.4f\t%6.4f\t%10.4f\t%9.4f\t%6.3f\t%6.3f\r\n', Lat, Lon, secstd(i,1:2), secstd(i,4:5));
    fprintf(fidu, '%7.4f\t%6.4f\t%9.4f\t%6.3f\r\n', Lat, Lon, secstd(i,3), secstd(i,6));
end
fclose(fidh);
fclose(fidu);