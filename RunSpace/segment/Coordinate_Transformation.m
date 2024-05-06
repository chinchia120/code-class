%% Launch Data %%
clc; 
clear all;
close all;

%% Initial Data %%
foleder_name = sprintf('TWD97-data');
[status, msg, msgID] = mkdir(foleder_name);

%% Select Input File %%
[File_Input, Path_Input, ~] = uigetfile('*.txt', 'Please Select Your File');
if File_Input == 0
    disp('User selected Cancel');
    return;
else
    disp(['User selected ', fullfile(Path_Input, File_Input)]);
end

%% Check Input File %%
fid_File = fopen(fullfile(Path_Input, File_Input));

cnt = 1;
disp('Loading Input File ...');
while ~ feof(fid_File)
    tmp_File = (strsplit(fgetl(fid_File), ' '));
    for i = 1: size(tmp_File, 2)
        data_raw(cnt, i) = str2double(tmp_File(i));
    end
    cnt = cnt + 1;
end
fclose(fid_File);
disp('Loading File Success ...');

%% Coordinate Transformation
data = wgs84_to_twd97(data_raw(:, 2: 3));
data = [data_raw(:, 1), data];

path = ['./', foleder_name, '//'];
file_output_name = [path, 'TWD97-data.txt'];
file = fopen(file_output_name, 'w');

for i = 1: size(data, 1)
    fprintf(file, '%15.9f %12.6f %13.6f\n', data(i, 1), data(i, 2), data(i, 3));
end