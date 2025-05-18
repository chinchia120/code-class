%% ========== Setup ========== %%
% ===== Setup
clc; clear; close all;
warning off;

% ===== Figure Folder
OutputFigure = sprintf('OutputFigure');
if ~exist(OutputFigure, 'dir'); mkdir(OutputFigure); end

% ===== File Folder
OutputFile = sprintf('OutputFile');
if ~exist(OutputFile, 'dir'); mkdir(OutputFile); end

%% ========== Pre-Make Fault ========== %%
% ===== Fault 1 Parameters
fault_x{1} = [119.8 119.9512 120.3];
fault_y{1} = [23.05 23.05 23.05];
dep{1} = [0 15];            % top depth of fault
dp{1} = 68.0;               % fault dip
strike_seg{1} = [5 8];      % strike segments
dip_seg{1} = 7;             % dip segments
outf = 1;                   % outf = 1 if write output file, outf = 0 if no output file

% ===== Make Fault
origin = [min(fault_y{1}(1)) min(fault_x{1}(1))];

for k = 1:size(fault_x,2)
    n_fault_x{k} = [];
    n_fault_y{k} = [];
    for k1 = 1:size(strike_seg{k},2)
        incx = (fault_x{k}(k1+1)-fault_x{k}(k1)) / strike_seg{k}(k1);
        incy = (fault_y{k}(k1+1)-fault_y{k}(k1)) / strike_seg{k}(k1);
        for k2 = 1:strike_seg{k}(k1)
            n_fault_x{k} = [n_fault_x{k}, fault_x{k}(k1)+incx*(k2-1)];
            n_fault_y{k} = [n_fault_y{k}, fault_y{k}(k1)+incy*(k2-1)];
        end
    end
    n_fault_x{k} = [n_fault_x{k}, fault_x{k}(end)];
    n_fault_y{k} = [n_fault_y{k}, fault_y{k}(end)];
end

for k = 1:size(fault_x,2)
    n_dep{k} = [];
    n_dp{k} = [];
    for k1 = 1:size(dip_seg{k},2)
        incd = (dep{k}(k1+1)-dep{k}(k1)) / dip_seg{k}(k1);
        for k2 = 1:dip_seg{k}(k1)
            n_dep{k} = [n_dep{k}, dep{k}(k1)+incd*(k2-1)];
        end
        n_dp{k} = [n_dp{k}, dp{k}(k1)*ones(1,dip_seg{k}(k1))];
    end
    n_dep{k} = [n_dep{k}, dep{k}(end)];
end

% ===== Generate pm
for k = 1:size(fault_x,2)
    [pm_pre{k}, nhe{k}, nve{k}, strike_all{k}] = make_pm(n_fault_x{k}, n_fault_y{k}, n_dep{k}, n_dp{k}, origin);
    SegEnds_pre{k} = make_SegEnds(fault_x{k}, fault_y{k},origin);
end

% ===== Plot Fault
figure;
for k = 1:size(fault_x,2)
    plotpatchslip3D_vectors_pre(pm_pre{k}, nve{k});
    hold on;
    for k2 = 1:size(SegEnds_pre{k},1)
        plot([SegEnds_pre{k}(k2,1) SegEnds_pre{k}(k2,3)], [SegEnds_pre{k}(k2,2) SegEnds_pre{k}(k2,4)], 'ko');
    end
end

saveas(gcf, [OutputFigure, sprintf('/Fault_%.1f.png', dp{1})]);

% ===== Write Output File
if outf == 1
    fid = fopen([OutputFile, sprintf('/pre_make_fault.out')], 'w');
    for k = 1:size(fault_x,2)
        fprintf(fid, 'fault_x{%d}\r\n', k);
        fprintf(fid, '%f ', n_fault_x{k});
        fprintf(fid, '\r\n');
        fprintf(fid, '%f ', n_fault_y{k});
        fprintf(fid, '\r\n');
        fprintf(fid, '%f ', n_dep{k});
        fprintf(fid, '\r\n');
        fprintf(fid, '%f ', n_dp{k});
        fprintf(fid, '\r\n\r\n');
    end
    fclose(fid);
end

% ===== Check Pre-Make Fault
pre_fault = pm_pre{1, 1};
fprintf('pre_fault: %f %f\n', pre_fault(1, 1:2));
fprintf('pre_fault: %f %f\n', pre_fault(end, 1:2));

% ===== Clear Variables
clear origin;

%% ========== Inversion ========== %%
% ===== Setup
input_file{1} = 'InputFile/disp_h_CGPS.dat';    % input file name
datatype{1} = 1;
weightdata{1} = 1;
look{1} = NaN;                                  % [flight_direction,looking angle] for InSAR data -- not applicable for other geodetic data

input_file{2} = 'InputFile/disp_u_CGPS.dat';    % input file name
datatype{2} = 2;
weightdata{2} = 1;
look{2} = NaN;                                  % [flight_direction,looking angle] for InSAR data -- not applicable for other geodetic data

% ===== Fault 1 Parameters
fault_x{1} = n_fault_x{1, 1};
fault_y{1} = n_fault_y{1, 1};
dep{1} = n_dep{1, 1};
dp{1} = n_dp{1, 1};
% dp{1} = ones(size(n_dp{1, 1}))*68;

isSurf{1} = 1;      % isSurf = 1 if fault breaks free surface; = 0 otherwise; = NaN if no smoothing
bss{1} = 1;         % bss = 1 if left-lateral; -1 if right-lateral; = NaN if no constraint
bds{1} = NaN;       % bds = 1 if reverse; -1 if normal; = NaN if no constraint
gss{1} = NaN;       % gss (geological ss rate) = NaN if no constraint; else then value should be positive
gds{1} = NaN;       % gds (geological ds rate) = NaN if no constraint; else then value should be positive

gamma_smooth = 1;   % smoothing parameter (increasing gamma decreases roughness)
gout = 1;           % gout = NaN if not generating output files; else if yes

% ===== Load Data
for k = 1:size(datatype,2)
    data{k} = load(input_file{k});
end

origin = [min(data{1}(:,2)) min(data{1}(:,1))];
for k=1:size(data,2)
    xy{k} = ll2xy([data{k}(:,2) data{k}(:,1)]', origin);
end

% ===== Generate pm
pm = [];
np{1} = 0;
for k = 1:size(fault_x,2)
    [pm_pre{k}, nhe{k}, nve{k}, strike_all{k}] = make_pm(fault_x{k}, fault_y{k}, dep{k}, dp{k}, origin);
    pm = [pm; pm_pre{k}];
    np{k+1} = np{k} + size(pm_pre{k},1);
end
npatches=size(pm,1);

% ===== Make G Matrix
G = [];
for k = 1:size(data,2)
    if datatype{k} == 1
        [Gss, Gds] = Get_Gs_horizontal(pm, xy{k});
    elseif datatype{k} == 2
        [Gss, Gds] = Get_Gs_vertical(pm, xy{k});
    end
    G = [G; [Gss,Gds]];
end

% ===== Original Data and Weighting Matrix
d_orig = [];
sig = [];
nd{1} = 0;
for k = 1:size(data,2)
    if datatype{k} == 1
        d_orig = [d_orig;data{k}(:,3); data{k}(:,4)];
        sig = [sig; data{k}(:,5)*weightdata{k}; data{k}(:,6)*weightdata{k}];
        nd{k+1} = nd{k} + size(data{k},1)*2;
    else
        d_orig = [d_orig;data{k}(:,3)];
        sig = [sig; data{k}(:,4)*weightdata{k}];
        nd{k+1} = nd{k}+size(data{k},1);
    end
end
C = repmat(sig, 1, 2*npatches);

% ===== Make Smoothing
for k = 1:size(fault_x,2)
    if ~isnan(isSurf{k})            %Lap = Laplacian operator (discrete)
        [Lap{k}, Lap_inv] = modelwt(nve{k}, nhe{k}, pm_pre{k}(1,1), pm_pre{k}(1,2), isSurf{k});
    end
end

Lapp_ss_all=[];                     % strike-slip component
for k1 = 1:size(fault_x,2)          % smoothing seg.
    if isnan(isSurf{k1})
        continue;
    else
        Lapp_ss = [];
        for k2 = 1:size(fault_x,2)  % non-smoothing seg.
            if k1 == k2
                Lapp_ss = [Lapp_ss, Lap{k1}];
            else
                Lapp_ss = [Lapp_ss, zeros(size(pm_pre{k1},1), size(pm_pre{k2},1))];
            end
        end
        Lapp_ss_all = [Lapp_ss_all; Lapp_ss];
    end
end
Lapp = [[Lapp_ss_all, zeros(size(Lapp_ss_all))]; [zeros(size(Lapp_ss_all)), Lapp_ss_all]];

% ===== Make New G Matrix
gamma = 10^(-gamma_smooth);
A = [G./C; gamma*Lapp];
d = [d_orig./sig; zeros(size(Lapp,1),1)];

% ===== Make Boundary Condition for Slip
% generate BNi_ss and BNi_ds for fault kinematics and BGi_ss and BGi_ds for constraint of geological rate
for k = 1:size(fault_x,2)
    if ~isnan(bss{k}); BNi_ss{k} = bss{k}*-eye(size(pm_pre{k},1)); end
    if ~isnan(bds{k}); BNi_ds{k} = bds{k}*-eye(size(pm_pre{k},1)); end
    if ~isnan(gss{k}); BGi_ss{k} = bss{k}*eye(size(pm_pre{k},1)); end
    if ~isnan(gds{k}); BGi_ds{k} = bds{k}*eye(size(pm_pre{k},1)); end
end

% strike-slip component for fault kinematics
B_ss_all = [];
for k1 = 1:size(fault_x,2)          % bounded seg.
    if isnan(bss{k1})
        continue;
    else
        B_ss = [];
        for k2 = 1:size(fault_x,2)  %non-bounded seg.
            if k1 == k2
                B_ss = [B_ss, BNi_ss{k1}];
            else
                B_ss = [B_ss, zeros(size(pm_pre{k1},1), size(pm_pre{k2},1))];
            end
        end
        B_ss_all = [B_ss_all; B_ss];
    end
end
bounds_ss = zeros(size(B_ss_all,1), 1);

% dip-slip component for fault kinematics
B_ds_all = [];
for k1 = 1:size(fault_x,2)              % bounded seg.
    if isnan(bds{k1})
        continue;
    else
        B_ds=[];
        for k2 = 1:size(fault_x,2)      % non-bounded seg.
            if k1 == k2
                B_ds = [B_ds, BNi_ds{k1}];
            else
                B_ds = [B_ds, zeros(size(pm_pre{k1},1), size(pm_pre{k2},1))];
            end
        end
        B_ds_all = [B_ds_all;B_ds];
    end
end
bounds_ds = zeros(size(B_ds_all,1),1);
BN = [[B_ss_all, zeros(size(B_ss_all))]; [zeros(size(B_ds_all)),B_ds_all]];

% strike-slip component for for constraint of geological rate
BG_ss_all = [];
bounds_g_ss = [];
for k1 = 1:size(fault_x,2)              % bounded seg.
    if isnan(gss{k1})
        continue;
    else
        BG_ss = [];
        for k2 = 1:size(fault_x,2)      % non-bounded seg.
            if k1 == k2
                BG_ss = [BG_ss, BGi_ss{k1}];
            else
                BG_ss = [BG_ss, zeros(size(pm_pre{k1},1), size(pm_pre{k2},1))];
            end
        end
        BG_ss_all = [BG_ss_all; BG_ss];
        bounds_g_ss = [bounds_g_ss; gss{k1}*ones(size(BG_ss,1),1)];
    end
end

% dip-slip component for for constraint of geological rate
BG_ds_all = [];
bounds_g_ds = [];
for k1 = 1:size(fault_x,2)              % bounded seg.
    if isnan(gds{k1})
        continue;
    else
        BG_ds = [];
        for k2 = 1:size(fault_x,2)      % non-bounded seg.
            if k1 == k2
                BG_ds = [BG_ds, BGi_ds{k1}];
            else
                BG_ds=[BG_ds, zeros(size(pm_pre{k1},1), size(pm_pre{k2},1))];
            end
        end
        BG_ds_all = [BG_ds_all; BG_ds];
        bounds_g_ds = [bounds_g_ds; gds{k1}*ones(size(BG_ds,1),1)];
    end
end
BG= [[BG_ss_all, zeros(size(BG_ss_all))]; [zeros(size(BG_ds_all)),BG_ds_all]];
B = [BN; BG];
bounds = [bounds_ss; bounds_ds; bounds_g_ss; bounds_g_ds];

% ===== Least Squares Inversion
s = lsqlin(A, d, B, bounds);

% ===== Calculate Model Velocities
dhat = G*s;
rnorm = norm((d_orig-dhat)./sig);
mis = sqrt(sum((d_orig-dhat).^2) / size(d_orig,1));

for k = 1:size(data,2)
    dhat_set{k} = dhat(nd{k}+1:nd{k+1}, 1);
end

% ===== Plot Results
% plot fault geometry and slip distribution
for k = 1:size(fault_x,2)
    ss_pre{k} = s(np{k}+1:np{k+1});
    ds_pre{k} = s(npatches+np{k}+1:npatches+np{k+1});
    s_pre{k} = [ss_pre{k}; ds_pre{k}];
end

dip = dp{1};
for k = 1:size(data,2)
    if datatype{k} == 1
        figure;
        for i = 1:size(fault_x,2)
            plotpatchslip3D_vectors(pm_pre{i}, s_pre{i}', nve{i});
            hold on;
        end
        quiver(xy{k}(:,1), xy{k}(:,2), data{k}(:,3), data{k}(:,4), 'b');
        quiver(xy{k}(:,1), xy{k}(:,2), dhat_set{k}(1:size(data{k},1)), dhat_set{k}(size(data{k},1)+1:2*size(data{k},1)), 'r');
        axis equal;
        
        saveas(gcf, [OutputFigure, sprintf('/Fault_%.1f_Horizontal_%.1f.png', dip(1), gamma_smooth)]);
    elseif datatype{k} == 2
        figure;
        for i = 1:size(fault_x,2)
            plotpatchslip3D_vectors(pm_pre{i}, s_pre{i}', nve{i});
            hold on;
        end
        quiver3(xy{k}(:,1), xy{k}(:,2), 0*xy{k}(:,1), zeros(size(data{k},1),1),zeros(size(data{k},1),1),data{k}(:,3),'k');
        quiver3(xy{k}(:,1), xy{k}(:,2), 0*xy{k}(:,1), zeros(size(data{k},1),1),zeros(size(data{k},1),1),dhat_set{k},'g');
        axis equal;

        saveas(gcf, [OutputFigure, sprintf('/Fault_%.1f_Vertical_%.1f.png', dip(1), gamma_smooth)]);
    end
end

% ===== Check rnorm and mis
fprintf('rnorm: %f\n', rnorm);
fprintf('mis: %f\n', mis);

% ===== Generate Output Files
if ~isnan(gout)
    % output observation, calculation, and residual files
    for k = 1:size(data,2)
        if datatype{k} == 1
            fid = fopen([OutputFile, sprintf('/calh_%d.gmt', k)], 'w');
            fprintf(fid, '%13.9f  %13.10f  %10.6f  %10.6f\r\n', [data{k}(:,1) data{k}(:,2) dhat_set{k}(1:size(data{k},1)) dhat_set{k}(size(data{k},1)+1:2*size(data{k},1))]');
            fclose(fid);
        elseif datatype{k} == 2
            fid = fopen([OutputFile, sprintf('/calu_%d.gmt', k)], 'w');
            fprintf(fid, '%13.9f  %13.10f  %10.6f\r\n', [data{k}(:,1) data{k}(:,2) dhat_set{k}]');
            fclose(fid);
        end
    end

    % output fault geometry and slip distribution
    for k = 1:size(fault_x,2)
        fid = fopen([OutputFile, sprintf('/fault_info_%d.dat', k)], 'w');
        fprintf(fid, '%8.4f %7.4f\r\n',fliplr(origin));
        fprintf(fid, '%i\r\n',nhe{k});
        fprintf(fid, '%i\r\n',nve{k});
        fclose(fid);
        
        fid = fopen([OutputFile, sprintf('/pm_%d.dat', k)], 'w');
        fprintf(fid, '%10.4f %10.4f %10.4f %10.4f %10.4f %10.4f %10.4f\r\n', pm_pre{k}');
        fclose(fid);
        
        outputpatchslip3D_vectors(pm_pre{k}, s_pre{k}', nve{k}, k, OutputFile);
    end
end