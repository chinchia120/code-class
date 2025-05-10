%generate BNi_ss and BNi_ds for fault kinematics and BGi_ss and BGi_ds for constraint of geological rate
for k=1:size(fault_x,2)
    if ~isnan(bss{k});BNi_ss{k}=bss{k}*-eye(size(pm_pre{k},1));end
    if ~isnan(bds{k});BNi_ds{k}=bds{k}*-eye(size(pm_pre{k},1));end
    if ~isnan(gss{k});BGi_ss{k}=bss{k}*eye(size(pm_pre{k},1));end
    if ~isnan(gds{k});BGi_ds{k}=bds{k}*eye(size(pm_pre{k},1));end
end
%strike-slip component for fault kinematics
B_ss_all=[];
for k1=1:size(fault_x,2) %bounded seg.
    if isnan(bss{k1})
        continue
    else
        B_ss=[];
        for k2=1:size(fault_x,2) %non-bounded seg.
            if k1==k2
                B_ss=[B_ss,BNi_ss{k1}];
            else
                B_ss=[B_ss,zeros(size(pm_pre{k1},1),size(pm_pre{k2},1))];
            end
        end
        B_ss_all=[B_ss_all;B_ss];
    end
end
bounds_ss=zeros(size(B_ss_all,1),1);
%dip-slip component for fault kinematics
B_ds_all=[];
for k1=1:size(fault_x,2) %bounded seg.
    if isnan(bds{k1})
        continue
    else
        B_ds=[];
        for k2=1:size(fault_x,2) %non-bounded seg.
            if k1==k2
                B_ds=[B_ds,BNi_ds{k1}];
            else
                B_ds=[B_ds,zeros(size(pm_pre{k1},1),size(pm_pre{k2},1))];
            end
        end
        B_ds_all=[B_ds_all;B_ds];
    end
end
bounds_ds=zeros(size(B_ds_all,1),1);
BN=[[B_ss_all,zeros(size(B_ss_all))];[zeros(size(B_ds_all)),B_ds_all]];

%strike-slip component for for constraint of geological rate
BG_ss_all=[];bounds_g_ss=[];
for k1=1:size(fault_x,2) %bounded seg.
    if isnan(gss{k1})
        continue
    else
        BG_ss=[];
        for k2=1:size(fault_x,2) %non-bounded seg
            if k1==k2
                BG_ss=[BG_ss,BGi_ss{k1}];
            else
                BG_ss=[BG_ss,zeros(size(pm_pre{k1},1),size(pm_pre{k2},1))];
            end
        end
        BG_ss_all=[BG_ss_all;BG_ss];
        bounds_g_ss=[bounds_g_ss;gss{k1}*ones(size(BG_ss,1),1)];
    end
end
%dip-slip component for for constraint of geological rate
BG_ds_all=[];bounds_g_ds=[];
for k1=1:size(fault_x,2) %bounded seg.
    if isnan(gds{k1})
        continue
    else
        BG_ds=[];
        for k2=1:size(fault_x,2) %non-bounded seg
            if k1==k2
                BG_ds=[BG_ds,BGi_ds{k1}];
            else
                BG_ds=[BG_ds,zeros(size(pm_pre{k1},1),size(pm_pre{k2},1))];
            end
        end
        BG_ds_all=[BG_ds_all;BG_ds];
        bounds_g_ds=[bounds_g_ds;gds{k1}*ones(size(BG_ds,1),1)];
    end
end
BG=[[BG_ss_all,zeros(size(BG_ss_all))];[zeros(size(BG_ds_all)),BG_ds_all]];

B=[BN;BG];
bounds=[bounds_ss;bounds_ds;bounds_g_ss;bounds_g_ds];
