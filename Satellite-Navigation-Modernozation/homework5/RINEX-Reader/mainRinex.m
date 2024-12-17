%% =============== Setup =============== %%
clc; clear; close all;

%% =============== Select nav File =============== %%
[navfname, navpname] = uigetfile({'*.nav'}, 'Please select your nav file', pwd);
filePath_nav = [navpname navfname];
[outputEphemeris] = readRinexNav(filePath_nav);

%% =============== Select obs File =============== %%
[obsfname, obspname] = uigetfile({'*.obs'}, 'Please select your obs file', pwd);
filePath_obs = [obspname obsfname];
[XYZ_station,obs,observablesHeader,measurementsInterval]=readRinex302(filePath_obs);

%% =============== Save Observation Data (obs) into rcvr.dat =============== %%
fid1 = fopen([extractBefore(obsfname, '.obs'), '_rcvr.dat'], 'w+');
[m,n]=size(obs);
for i=1:1:m
    for j=1:1:n
        if j==n
            fprintf(fid1, '%.15d \n', obs(i,j) );
        else
            fprintf(fid1, '%.15d \t', obs(i,j) );
        end
    end
end
fclose(fid1);

%% =============== Save Ephemeris Data (outputEphemeris) into eph.dat =============== %%
fid2 = fopen([extractBefore(obsfname, '.obs'), '_eph.dat'], 'w+');
[m,n]=size(outputEphemeris.gpsEphemeris);
for i=1:1:m
    for j=1:1:n
        if j==n
            fprintf(fid2, '%.15d \n', outputEphemeris.gpsEphemeris(i,j) );
        else
            fprintf(fid2, '%.15d \t', outputEphemeris.gpsEphemeris(i,j) );
        end
    end
end
fclose(fid2);