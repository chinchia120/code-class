%% ========== Setup ========== %%
% ===== Setup
% clc; clear; close all;
close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%specify fault geometry and boundary condition

% fault_x{1}=[121.82000 121.59831 121.53000];
% fault_y{1}=[24.22500 23.93789 23.80000];
% dep{1}=[0 15]; %top depth of fault
% dp{1}=58.8074; %fault dip
% strike_seg{1}=[18 8];
% dip_seg{1}=10;
fault_x{1} = [120.3903 119.9512 119.5121];
fault_y{1} = [23.0898 23.0224 22.9551];
dep{1} = [0 25]; % top depth of fault
dp{1} = 20.0; % fault dip
strike_seg{1} = [6 6];
dip_seg{1} = 10;

% fault_x{2}=[121.60255 121.60200 121.65609];
% fault_y{2}=[23.96736 23.99600 24.08519];
% dep{2}=[0 5]; %top depth of fault
% dp{2}=[55]; %fault dip
% strike_seg{2}=[3 9];
% dip_seg{2}=[5];

outf=1; % outf = 1 if write output file, outf = 0 if no output file

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

origin=[min(fault_y{1}(1)) min(fault_x{1}(1))];

for k=1:size(fault_x,2)
    n_fault_x{k}=[];
    n_fault_y{k}=[];
    for k1=1:size(strike_seg{k},2)
        incx=(fault_x{k}(k1+1)-fault_x{k}(k1))/strike_seg{k}(k1);
        incy=(fault_y{k}(k1+1)-fault_y{k}(k1))/strike_seg{k}(k1);
        for k2=1:strike_seg{k}(k1)
            n_fault_x{k}=[n_fault_x{k},fault_x{k}(k1)+incx*(k2-1)];
            n_fault_y{k}=[n_fault_y{k},fault_y{k}(k1)+incy*(k2-1)];
        end
    end
    n_fault_x{k}=[n_fault_x{k},fault_x{k}(end)];
    n_fault_y{k}=[n_fault_y{k},fault_y{k}(end)];
end

for k=1:size(fault_x,2)
    n_dep{k}=[];
    n_dp{k}=[];
    for k1=1:size(dip_seg{k},2)
        incd=(dep{k}(k1+1)-dep{k}(k1))/dip_seg{k}(k1);
        for k2=1:dip_seg{k}(k1)
            n_dep{k}=[n_dep{k},dep{k}(k1)+incd*(k2-1)];
        end
        n_dp{k}=[n_dp{k},dp{k}(k1)*ones(1,dip_seg{k}(k1))];
    end
    n_dep{k}=[n_dep{k},dep{k}(end)];
end

%generate pm
for k=1:size(fault_x,2)
    [pm_pre{k},nhe{k},nve{k},strike_all{k}]=make_pm(n_fault_x{k},n_fault_y{k},n_dep{k},n_dp{k},origin);
    SegEnds_pre{k}=make_SegEnds(fault_x{k},fault_y{k},origin);
end

figure
for k=1:size(fault_x,2)
    plotpatchslip3D_vectors_pre(pm_pre{k},nve{k});hold on
    for k2=1:size(SegEnds_pre{k},1);  plot([SegEnds_pre{k}(k2,1) SegEnds_pre{k}(k2,3)],[SegEnds_pre{k}(k2,2) SegEnds_pre{k}(k2,4)],'ko'); end
end

if outf==1
    fid=fopen('pre_make_fault.out','w');
    for k=1:size(fault_x,2)
        fprintf(fid,'fault_x{%d}\r\n',k);
        fprintf(fid,'%f ',n_fault_x{k});
        fprintf(fid,'\r\n');
        fprintf(fid,'%f ',n_fault_y{k});
        fprintf(fid,'\r\n');
        fprintf(fid,'%f ',n_dep{k});
        fprintf(fid,'\r\n');
        fprintf(fid,'%f ',n_dp{k});
        fprintf(fid,'\r\n\r\n');
    end
    fclose(fid);
end

tmp = pm_pre{1, 1};
disp([tmp(1, 1:2)])
disp([tmp(end, 1:2)])