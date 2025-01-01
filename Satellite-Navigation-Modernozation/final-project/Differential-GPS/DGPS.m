%% ========== Setup ========== %%
% ===== Reference IS-GPS-200M
% https://www.gps.gov/technical/icwg/IS-GPS-200M.pdf

% ===== Setup
clc; clear; close all;
format longG;

% ===== Initial
% RefPose = [-2956554.94163553 5076015.62439893 2476596.00901585];
% RefPose = [-2956517.76926541 5076035.26024164 2476582.34767972]; % Information Building
RefPose = [-2956619.16455631 5075902.22105795  2476625.54446272]; % CKSV

% ===== Read Reference rcvr Data
Refrcvrpname = '/Users/chinchia120/Documents/code-class/Satellite-Navigation-Modernozation/final-project/Experiment-Data/20241227/receiver1-NCKU-CK-Campus-Information-Building/';
Refrcvrfname = 'Binary2024-12-27_143421_rcvr.dat';
[Refrcvrfname, Refrcvrpname] = uigetfile({'*_rcvr.dat'}, 'Please Select Reference rcvr.dat File', pwd);
Refrcvr = RcvrDataReader([Refrcvrpname Refrcvrfname]);

% ===== Read Reference eph Data
Refephpname = '/Users/chinchia120/Documents/code-class/Satellite-Navigation-Modernozation/final-project/Experiment-Data/20241227/receiver1-NCKU-CK-Campus-Information-Building/';
Refephfname = 'Binary2024-12-27_143421_eph.dat';
[Refephfname, Refephpname] = uigetfile({'*_eph.dat'}, 'Please Select Reference eph.dat File', Refrcvrpname);
Refeph = EphDataReader([Refephpname Refephfname]);

% ===== Read Experiment rcvr Data
Exprcvrpname = '/Users/chinchia120/Documents/code-class/Satellite-Navigation-Modernozation/final-project/Experiment-Data/20241227/receiver2-NCKU-CK-Campus-Information-Building/';
Exprcvrfname = 'Binary2024-12-27_143422_rcvr.dat';
[Exprcvrfname, Exprcvrpname] = uigetfile({'*_rcvr.dat'}, 'Please Select Experiment rcvr.dat File', Refrcvrpname);
Exprcvr = RcvrDataReader([Exprcvrpname Exprcvrfname]);

% ===== Read Experiment eph Data
Expephpname = '/Users/chinchia120/Documents/code-class/Satellite-Navigation-Modernozation/final-project/Experiment-Data/20241227/receiver2-NCKU-CK-Campus-Information-Building/';
Expephfname = 'Binary2024-12-27_143422_eph.dat';
[Expephfname, Expephpname] = uigetfile({'*_eph.dat'}, 'Please Select Experiment eph.dat File', Exprcvrpname);
Expeph = EphDataReader([Expephpname Expephfname]);

% ===== Output Data
OutputFolder = sprintf('OutputFigure');
if ~exist(OutputFolder, 'dir'); mkdir(OutputFolder); end
OutputPose = [OutputFolder '/' extractBefore(Exprcvrfname, '_rcvr') '_DGPS_ReceiverPos.txt'];

%% ========== Align Data ========== %%
[RefrcvrGroup, RefephGroup] = AlignRcvrEph(Refrcvr.Data, Refeph.Data);
[ExprcvrGroup, ExpephGroup] = AlignRcvrEph(Exprcvr.Data, Expeph.Data);

%% ========== Compute Pseudorange Coorection ========== %%
PrCor = cell(size(RefrcvrGroup, 1), 1);
for i = 1:size(RefrcvrGroup, 1)
    % ===== Satellite Position
    satpos = SatellitePos(RefrcvrGroup{i}, RefephGroup{i});
    if ~isempty(satpos)
    % ===== Correct Pesudorange
        prTure = sqrt(sum((satpos(:, 5:7)-RefPose).^2, 2));
        prCor = prTure - satpos(:, 3) + GPSConstant.c*satpos(:, 4);
        PrCor{i} = [satpos(:, 1: 2) prCor];
    end
end 
PrCor = PrCor(~cellfun('isempty', PrCor));

%% ========== Receiver Position ========== %%
ExprcvrPos = zeros(size(ExprcvrGroup, 1), 10);
for i = 1: size(ExprcvrGroup, 1)
    pos = ReceiverPos(ExprcvrGroup{i}, ExpephGroup{i}, PrCor)
    if ~isempty(pos)
        ExprcvrPos(i, :) = pos;
    end
end
ExprcvrPos(ExprcvrPos(:, 1) == 0, :) = [];

%% ========== Save Receiver Position ========== %%
% ===== Change to 10 Decimal Places
formattedMatrix = sprintfc('%0.10f', ExprcvrPos);

% ===== Save Text File
writecell(formattedMatrix, OutputPose, 'Delimiter', '\t');