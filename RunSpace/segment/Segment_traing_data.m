%% Launch Data %%
clc; 
clear all;
close all;

%% Initial Data %%
interval = 1;
foleder_name = sprintf('segment-interval-%02d-training', interval);
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

%% Segment File %%
disp('Start Segment File ...');
len = size(data_raw, 1);
path = ['./', foleder_name, '//'];
file_output_name = [path, 'training_data_interval_', sprintf('%02d', interval), '.txt'];
file = fopen(file_output_name, 'w');
for i = 1: len-1-interval
    for j = 1: interval+2
        if j == 1 
            fprintf(file, '%12.10f %13.10f ', data_raw(i, 2), data_raw(i, 3));
        elseif j == 2
            fprintf(file, '%12.10f %13.10f ', data_raw(i+1+interval, 2), data_raw(i+1+interval, 3));
        else
            fprintf(file, '%12.10f %13.10f ', data_raw(i+j-2, 2), data_raw(i+j-2, 3));
        end
        
        if j == interval+2
            fprintf(file, '\n');
        end
    end
end
fclose(file);
disp('End of Segment ...');