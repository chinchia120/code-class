clc;
clear all;
close all;

%% Initial Value %%
scale_arrow_XY = 500;
scale_arrow_Z = 500;

%% Select File XY %%
[File_error_XY, Path_error_XY, ~] = uigetfile('*.csv', 'Please Select Your Error Report File of XY');
if File_error_XY == 0
    return;
end

%% Select File Z %%
[File_error_Z, Path_error_Z, ~] = uigetfile('*.csv', 'Please Select Your Error Report File of Z');
if File_error_Z == 0
    return;
end

%% Check Import Data XY %%
fid_XY = fopen(File_error_XY);

cnt = 1;
while ~ feof(fid_XY)
    tmp_XY = (strsplit(fgetl(fid_XY), ','));
    for i = 1: size(tmp_XY, 2)
        data_raw_XY(cnt, i) = str2double(tmp_XY(i));
    end
    cnt = cnt + 1;
end
fclose(fid_XY);

%% Check Import Data Z %%
fid_Z = fopen(File_error_Z);

cnt = 1;
while ~ feof(fid_Z)
    tmp_Z = (strsplit(fgetl(fid_Z), ','));
    for i = 1: size(tmp_Z, 2)
        data_raw_Z(cnt, i) = str2double(tmp_Z(i));
    end
    cnt = cnt + 1;
end
fclose(fid_Z);

%% Start Calculate %%
disp('<< ----- Start ----- >>');

%% Make XY Figure %%
get_XYplot(data_raw_XY, scale_arrow_XY, 'Error Figure XY', 'Error_Figure_XY.png');

%% Make Z Figure %%
get_Zplot(data_raw_Z, scale_arrow_Z, 'Error Figure Z', 'Error_Figure_Z.png');

%% Make Static Report %%
static_report(data_raw_XY(11: end, :), data_raw_Z(11: end, :));

%% Stop Calculate %%
disp('<< ----- Finish ----- >>');
