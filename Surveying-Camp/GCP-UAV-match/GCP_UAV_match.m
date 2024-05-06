clc;
clear all;
close all;

%% Output File Name %%
file_name = input("Please Type in Output File Name? ", "s");

%% Open File %%
fid = fopen(file_name, 'w');

%% Match GCP and UAV %%
while true
    GCP = input("Please Type in GCP Name? ", "s");
    if strcmp(GCP, "0")
        break;
    end
    fprintf(fid, 'GCP: %s\n',GCP);
    
    while true
        num = input("Please Type in Start and Final UAV Number? ", 's');
        UAV = sscanf(num, '%d %d');
        if UAV(1) == 0 && UAV(2) == 0
            break;
        end

        for i = UAV(1): UAV(2)
            fprintf(fid, '  DJI_%04d\n', i);
        end
    end
    fprintf(fid, '\n');
end

%% Close File %%
fclose(fid);