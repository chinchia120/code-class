%% ========== Setup ========== %%
% ===== Reference IS-GPS-200M
% https://www.gps.gov/technical/icwg/IS-GPS-200M.pdf

% ===== Setup
clc; clear; close all;
format longG;

% ===== Read rcvr Data
[rcvrfname, rcvrpname] = uigetfile({'*.dat'}, 'Please select your rcvr.dat file', pwd);
rcvr = RcvrDataReader([rcvrpname rcvrfname]);

% ===== Read eph Data
[ephfname, ephpname] = uigetfile({'*.dat'}, 'Please select your eph.dat file', pwd);
eph = EphDataReader([ephpname ephfname]);

% ===== Output Data
OutputFolder = sprintf('OutputFigure');
if ~exist(OutputFolder, 'dir'); mkdir(OutputFolder); end
OutputMat = [OutputFolder '/' extractBefore(rcvrfname, '_rcvr') '_ReceiverPos.mat'];
OutputAnalysis = [OutputFolder '/' extractBefore(rcvrfname, '_rcvr')];

%% ========== Correct Data ========== %%
currtime = rcvr.rcvr_tow(1);
index_rcvr = 1;
rcvr_pos_index = 1;

for i = 1: length(rcvr.svid)
    if currtime == rcvr.rcvr_tow(i)
        % ===== Align rcvr Data
        rcvr_tmp(index_rcvr, :) = rcvr.Data(i, :);
        index_rcvr = index_rcvr + 1;
    else
        % ===== Save rcvr Data
        rcvri = RcvrDataReader(rcvr_tmp);
        
        % ===== Align rcvr Data to eph Data
        index_eph = 1;
        for j = 1: length(rcvri.svid)
            index_eph_svid = 1;
            flag = 0;
            for k = 1: length(eph.svid)
                if rcvri.svid(j) == eph.svid(k)
                    eph_svid(index_eph_svid, :) = eph.Data(k, :);
                    index_eph_svid = index_eph_svid + 1;
                    flag = 1;
                elseif rcvri.svid(j) < eph.svid(k)
                    break;
                end
            end

            if flag == 0
                clear eph_svid;
                continue; 
            end

            [~, idx] = min(abs(eph_svid(:, 1)-rcvri.rcvr_tow(j)));
            eph_tmp(index_eph, :) = eph_svid(idx, :);
            index_eph = index_eph + 1;
        end
        
        % ===== Save eph Data
        ephi = EphDataReader(eph_tmp);

        % ===== Remove rcvr Empty PRN
        [~, idx] = intersect(rcvri.svid, ephi.svid);
        rcvr_tmp = rcvr_tmp(idx, :);

        % ===== Calculate
        rcvr_pos(rcvr_pos_index, :) = ReceiverPos(rcvr_tmp, eph_tmp);
        rcvr_pos_index = rcvr_pos_index + 1;

        % ===== Next Time Data
        currtime = rcvr.rcvr_tow(i);
        index_rcvr = 2;
        clear rcvr_tmp eph_tmp;
        rcvr_tmp(1, :) = rcvr.Data(i, :);
    end
end

% ===== Save Receiver Position
save(OutputMat, 'rcvr_pos');

%% ========== Analysis ========== %%
% ===== Read Receiver Data
ReceiverMat = OutputMat;
% TruePos = [-2957049.61127712 5075853.28740182 2476274.22547061 22.9953162021276 120.223876713871 82.8651043531462];
TruePos = [];

% ===== Analysis
ReceiverAnalysis(ReceiverMat, TruePos, OutputAnalysis);