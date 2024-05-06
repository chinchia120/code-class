%% ========== Setup ========== %%
clc;
clear;
close all;

%% ========== Initial Value ========== %%
student_id = 'P66134111';
longitude = mod(str2num(extractAfter(student_id, 1)), 180);                 % deg
latitude = mod(str2num(extractBefore(reverse(student_id), 9)), 90);         % deg
altitude = 0;                                                               % m
recPos = [latitude, longitude, altitude];                                   % [deg deg m]
maskAngle = 0;                                                              % deg
startTime = datetime(2024, 04, 01, 00, 00, 00);

%% ========== Display the GNSS Receiver Position ========== %%
geoplot(latitude, longitude);
title("Receiver Position");

saveas(gcf, sprintf('2024-04-01-000000-0.fig'));
saveas(gcf, sprintf('2024-04-01-000000-0.png'));

%% ========== Skyplot of GPS ========== %%
[navmsg, satIDs, gnssFileType] = exampleHelperParseGNSSFile("GPS");
sp = skyplot([], [], MaskElevation=maskAngle);

satPos = gnssconstellation(startTime, navmsg, GNSSFileType=gnssFileType);
[az, el, vis] = lookangles(recPos, satPos, maskAngle);
set(sp, AzimuthData=az(vis), ElevationData=el(vis), LabelData=satIDs(vis));
title(sprintf('Skyplot of GPS at %s', startTime));

saveas(gcf, sprintf('2024-04-01-000000-1.fig'));
saveas(gcf, sprintf('2024-04-01-000000-1.png'));

%% ========== Skyplot of Satellite ========== %%
allSatSys = ["GPS", "GLONASS", "Galileo", "BeiDou", "QZSS"];
satLetter = ["G", "R", "E", "C", "J"];
sp = skyplot([], [], MaskElevation=maskAngle);

for ii = 1: numel(allSatSys)
    satSys = allSatSys(ii);
    [navmsg, satIDs, gnssFileType] = exampleHelperParseGNSSFile(satSys);
    satPos = gnssconstellation(startTime, navmsg, GNSSFileType=gnssFileType);  
    [az,el,vis] = lookangles(recPos, satPos, maskAngle);

    satIDLabel = arrayfun(@(x) sprintf("%c%02d", satLetter(ii),x), satIDs);
    satGroup = categorical(repmat(ii, numel(satIDLabel), 1), 1: numel(allSatSys), allSatSys);
    set(sp, AzimuthData=[sp.AzimuthData(:); az(vis)], ElevationData=[sp.ElevationData(:); el(vis)], ...
            LabelData=[sp.LabelData(:); satIDLabel(vis)], GroupData=[sp.GroupData; satGroup(vis)]);
    title(sprintf('Skyplot of Satellites at %s', startTime));
end
legend;

saveas(gcf, sprintf('2024-04-01-000000-2.fig'));
saveas(gcf, sprintf('2024-04-01-000000-2.png'));

%% ========== Helper Function ========== %%
function [navmsg, satIDs, gnssFileType] = exampleHelperParseGNSSFile(satSys)
    switch satSys
        case "GPS"
            file = "almanac_20240401/0ABI00SWE_S_20240920000_01D_GN.rnx";
            navmsg = rinexread(file);
            gpsData = navmsg.GPS;
            [~,idx] = unique(gpsData.SatelliteID);
            navmsg = gpsData(idx,:);
            gnssFileType = "RINEX";

        case "GLONASS"
            file = "almanac_20240401/0ABI00SWE_S_20240920000_01D_RN.rnx";
            navmsg = rinexread(file);
            gloData = navmsg.GLONASS;
            [~,idx] = unique(gloData.SatelliteID);
            navmsg = gloData(idx,:);
            gnssFileType = "RINEX";

        case "Galileo"
            file = "almanac_20240401/0ABI00SWE_S_20240920000_01D_EN.rnx";
            navmsg = rinexread(file);
            galData = navmsg.Galileo;
            [~,idx] = unique(galData.SatelliteID);
            navmsg = galData(idx,:);
            gnssFileType = "RINEX";

        case "BeiDou"
            file = "almanac_20240401/0ABI00SWE_S_20240920000_01D_CN.rnx";
            navmsg = rinexread(file);
            bdsData = navmsg.BeiDou;
            [~,idx] = unique(bdsData.SatelliteID);
            navmsg = bdsData(idx,:); 
            gnssFileType = "RINEX";

        case "QZSS"
            file = "almanac_20240401/0ABI00SWE_S_20240920000_01D_JN.rnx";
            navmsg = rinexread(file);
            qzsData = navmsg.QZSS;
            [~,idx] = unique(qzsData.SatelliteID);
            navmsg = qzsData(idx,:);
            gnssFileType = "RINEX";
    end
    satIDs = navmsg.SatelliteID;
end