%% ========== Setup ========== %%
% ===== Reference IS-GPS-200M
% https://www.gps.gov/technical/icwg/IS-GPS-200M.pdf

% ===== Setup
clc; clear; close all;
format longG;

% ===== Initial Value
% RefPose = [-2956517.76926541 5076035.26024164 2476582.34767972]; % Information Building
% RefPose = [-2956619.16455631 5075902.22105795 2476625.54446272]; % CKSV
% RefPose = [-2957049.61127712 5075853.28740182 2476274.22547061]; % AA

% ===== Read rcvr Data
[rcvrfname, rcvrpname] = uigetfile({'*rcvr.dat'}, 'Please select your rcvr.dat file', pwd);
rcvr = RcvrDataReader([rcvrpname rcvrfname]);

% ===== Read eph Data
[ephfname, ephpname] = uigetfile({'*eph.dat'}, 'Please select your eph.dat file', rcvrpname);
eph = EphDataReader([ephpname ephfname]);

% ===== Output Data
OutputFolder = sprintf('OutputFigure');
if ~exist(OutputFolder, 'dir'); mkdir(OutputFolder); end
OutputPose = [OutputFolder '/' extractBefore(rcvrfname, '_rcvr') '_LSE_ReceiverPos.txt'];

%% ========== Align Data ========== %%
[rcvrGroup, ephGroup] = AlignRcvrEph(rcvr.Data, eph.Data);

%% ========== Compute Receiver Position ========== %%
rcvrPos = zeros(size(rcvrGroup, 1), 10);
for i = 1: size(rcvrGroup, 1)
    pos = ReceiverPos(rcvrGroup{i}, ephGroup{i});
    if ~isempty(pos)
        rcvrPos(i, :) = pos;
    end
end 
rcvrPos(rcvrPos(:, 1) == 0, :) = [];

%% ========== Save Receiver Position ========== %%
% ===== Change to 10 Decimal Places
formattedMatrix = sprintfc('%0.10f', rcvrPos);
 
% ===== Save Text File
writecell(formattedMatrix, OutputPose, 'Delimiter', '\t');

%% ========== Receiver Position ========== %%
% ===== Remove Error
rcvrPosFilter = rcvrPos;
% rcvrPosFilter(rcvrPosFilter(:, 2) < 22.9983 | rcvrPosFilter(:, 2) > 22.9987 | rcvrPosFilter(:, 3) < 120.21 | rcvrPosFilter(:, 3) > 120.22, :) = [];

% ===== LLA
rcvrPosLLA = mean(rcvrPosFilter(:, 2:4));
array2table(rcvrPosLLA, 'VariableNames', {'Lat', 'Lon', 'Alt'})

% ===== XYZ
rcvrPosXYZ = wgslla2xyz(rcvrPosLLA);
array2table(rcvrPosXYZ, 'VariableNames', {'X', 'Y', 'Z'})