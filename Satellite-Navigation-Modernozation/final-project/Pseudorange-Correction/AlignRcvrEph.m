function [rcvrGroup, ephGroup] = AlignRcvrEph(rcvr_dat, eph_dat)
%% ========== Read Data ========== %%
rcvr = RcvrDataReader(rcvr_dat);
eph = EphDataReader(eph_dat);

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

end