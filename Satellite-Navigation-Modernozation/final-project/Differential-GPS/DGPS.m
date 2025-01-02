%% ========== Setup ========== %%
% ===== Reference IS-GPS-200M
% https://www.gps.gov/technical/icwg/IS-GPS-200M.pdf

% ===== Setup
clc; clear; close all;

% ===== Read Experiment rcvr Data
[Exprcvrfname, Exprcvrpname] = uigetfile({'*_rcvr.dat'}, 'Please Select Experiment rcvr.dat File', pwd);
Exprcvr = RcvrDataReader([Exprcvrpname Exprcvrfname]);

% ===== Read Experiment eph Data
[Expephfname, Expephpname] = uigetfile({'*_eph.dat'}, 'Please Select Experiment eph.dat File', Exprcvrpname);
Expeph = EphDataReader([Expephpname Expephfname]);

% ===== Read Pesudorange Correction Data
[PrCorfname, PrCorpname] = uigetfile({'*_PrCor.mat'}, 'Please Select Pesudorange Correction File', Exprcvrpname);
Data = load([PrCorpname PrCorfname]);
PrCor = Data.PrCor;

% ===== Output Data
OutputFolder = sprintf('OutputFigure');
if ~exist(OutputFolder, 'dir'); mkdir(OutputFolder); end
OutputPose = [OutputFolder '/' extractBefore(Exprcvrfname, '_rcvr') '_DGPS_ReceiverPos.txt'];

%% ========== Align Data ========== %%
[ExprcvrGroup, ExpephGroup] = AlignRcvrEph(Exprcvr.Data, Expeph.Data);

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