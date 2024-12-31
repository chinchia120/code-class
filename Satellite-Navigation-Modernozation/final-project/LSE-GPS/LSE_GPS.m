%% ========== Setup ========== %%
% ===== Reference IS-GPS-200M
% https://www.gps.gov/technical/icwg/IS-GPS-200M.pdf

% ===== Setup
clc; clear; close all;
format longG;

% ===== Initial
% RefPose = [-2956560.21714865 5076017.17083689 2476601.64675965];
% RefPose = [-2956554.94163553 5076015.62439893 2476596.00901585];
% RefPose = [-2956517.76926541 5076035.26024164 2476582.34767972];

% ===== Read rcvr Data
% rcvrpname = '/Users/chinchia120/Documents/code-class/Satellite-Navigation-Modernozation/final-project/Experiment-Data/20241113/E2-Tainan-Shalun/';
% rcvrfname = 'NMUT22070002W_2024-11-13_06-05-10_rcvr.dat';
[rcvrfname, rcvrpname] = uigetfile({'*_rcvr.dat'}, 'Please select your rcvr.dat file', pwd);
rcvr = RcvrDataReader([rcvrpname rcvrfname]);

% ===== Read eph Data
% ephpname = '/Users/chinchia120/Documents/code-class/Satellite-Navigation-Modernozation/final-project/Experiment-Data/20241113/E2-Tainan-Shalun/';
% ephfname = 'NMUT22070002W_2024-11-13_06-05-10_eph.dat';
[ephfname, ephpname] = uigetfile({'*_eph.dat'}, 'Please select your eph.dat file', rcvrpname);
eph = EphDataReader([ephpname ephfname]);

% ===== Output Data
OutputFolder = sprintf('OutputFigure');
if ~exist(OutputFolder, 'dir'); mkdir(OutputFolder); end
OutputPose = [OutputFolder '/' extractBefore(rcvrfname, '_rcvr') '_ReceiverPos.txt'];

%% ========== Align Data ========== %%
[uniqueValues, ~, groupIndices] = unique(rcvr.rcvr_tow);
rcvrGroup = cell(length(uniqueValues), 1);
ephGroup = cell(length(uniqueValues), 1);

for i = 1:length(uniqueValues)
    % ===== Receiver Group
    A = rcvr.Data(groupIndices == i, :);
    
    % ===== Eph Data
    B = eph.Data;

    Align_A = [];
    Align_B = [];
    
    for j = 1: size(A, 1)
        Time_A = A(j, 1);
        PRN_A = A(j, 2);
        
        PRN_B = B(B(:, 2) == PRN_A, :);

        if ~isempty(PRN_B)
            timeDiff = abs(PRN_B(:, 1) - Time_A);

            [~, minIdx] = min(timeDiff);
            closestRow = PRN_B(minIdx, :);

            Align_A = [Align_A; A(j, :)];
            Align_B = [Align_B; closestRow];
        end
    end
    
    % ===== Save Align Data
    rcvrGroup{i} = Align_A;
    ephGroup{i} = Align_B;
end

%% ========== Compute Receiver Position ========== %%
rcvrPos = zeros(size(rcvrGroup, 1), 5);
for i = 1: size(rcvrGroup, 1)
    pos = ReceiverPos(rcvrGroup{i}, ephGroup{i})
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
rcvrPosFilter(rcvrPosFilter(:, 2) < 22.9983 | rcvrPosFilter(:, 2) > 22.9987 | rcvrPosFilter(:, 3) < 120.21 | rcvrPosFilter(:, 3) > 120.22, :) = [];

% ===== LLA
rcvrPosLLA = mean(rcvrPosFilter(:, 2:4));
array2table(rcvrPosLLA, 'VariableNames', {'Lat', 'Lon', 'Alt'})

% ===== XYZ
rcvrPosXYZ = wgslla2xyz(rcvrPosLLA);
array2table(rcvrPosXYZ, 'VariableNames', {'X', 'Y', 'Z'})