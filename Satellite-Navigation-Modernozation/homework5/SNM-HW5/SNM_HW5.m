%% ========== Setup ========== %%
% ===== Setup
clc; clear; close all;
format longG;

% ===== Reference IS-GPS-200M
% https://www.gps.gov/technical/icwg/IS-GPS-200M.pdf

% ===== Read Data
rcvr = RcvrDataReader('DataFile_hw5/rcvr.dat');
eph = EphDataReader('DataFile_hw5/eph.dat');

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
            for k = 1: length(eph.svid)
                if rcvri.svid(j) == eph.svid(k)
                    eph_svid(index_eph_svid, :) = eph.Data(k, :);
                    index_eph_svid = index_eph_svid + 1;
                end
            end
            
            [~, idx] = min(abs(eph_svid(:, 1)-rcvri.rcvr_tow(j)));
            eph_tmp(index_eph, :) = eph_svid(idx, :);
            index_eph = index_eph + 1;
        end
        
        % ===== Save eph Data
        ehpi = EphDataReader(eph_tmp);

        % ===== Calculate 
        rcvr_pos(rcvr_pos_index, :) = ReceiverPos(rcvr_tmp, eph_tmp);
        rcvr_pos_index = rcvr_pos_index + 1;
        
        % ===== Save Receiver Position
        save('ReceiverPos.mat', 'rcvr_pos');

        % ===== Next Time Data
        currtime = rcvr.rcvr_tow(i);
        index_rcvr = 2;
        clear rcvr_tmp eph_tmp;
        rcvr_tmp(1, :) = rcvr.Data(i, :);
    end
end

%% ========== Save Receiver Position ========== %%
save('ReceiverPos.mat', 'rcvr_pos');