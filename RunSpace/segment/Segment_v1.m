%% Launch Data %%
clc; 
clear all;
close all;

%% Initial Data %%
foleder_name = 'segment-data-01Hz-30Sec';
[status, msg, msgID] = mkdir(foleder_name);
frequency = 1;
interval = 30;

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
cnt_file_seg = 1;
path = ['./', foleder_name, '//'];
for i = 1: len
    if mod(i, 50*interval) == 1
        file_output_name = [path, 'data_segment_', sprintf('%03d', cnt_file_seg), '.txt']; 
        file = fopen(file_output_name, 'w');
        fprintf(file, '%12.10f %13.10f ', data_raw(i, 2), data_raw(i, 3));
    elseif mod(i, 50*interval) == 0 || i == len
        fprintf(file, '%12.10f %13.10f ', data_raw(i, 2), data_raw(i, 3));
        fclose(file);
        cnt_file_seg = cnt_file_seg + 1;
    else
        if frequency == 50
            fprintf(file, '%12.10f %13.10f ', data_raw(i, 2), data_raw(i, 3));        
        elseif mod(i, 50/frequency) == 1
            fprintf(file, '%12.10f %13.10f ', data_raw(i, 2), data_raw(i, 3));
        end 
    end
end
disp('End of Segment ...');