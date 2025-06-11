%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%input parameters
%datatype = 1 for horizontal velocity | format: lon (¢X), lat (¢X), Veast (mm/yr), Vnorth (mm/yr), Sigeast (mm/yr), Signorth (mm/yr)
%datatype = 2 for vertical velocity | format: lon (¢X), lat (¢X), Vup (mm/yr), Sigup (mm/yr)
%datatype = 3 for insar los velocity | format: lon (¢X), lat (¢X), Vlos (mm/yr), Siglos (mm/yr)
input_file{1}='interseismic_velh.dat'; %input file name
datatype{1}=1;
look{1}=NaN; %[flight_direction,looking angle] for InSAR data -- not applicable for other geodetic data
input_file{2}='interseismic_velu.dat'; %input file name
datatype{2}=2;
look{2}=NaN; %[flight_direction,looking angle] for InSAR data -- not applicable for other geodetic data
%input_file{1}='interseismic_los.dat'; %input file name
%datatype{1}=3;
%look{3}=[167.176132 23]; %[flight_direction,looking angle] for InSAR data -- not applicable for other geodetic data

%specify fault geometry and boundary condition
fault_x{1}=[121.405 121.4200 121.435 121.4600 121.485 121.5625 121.640];
fault_y{1}=[25.01 25.0500 25.09 25.1200 25.15 25.2000 25.25];
dep{1}=[0 4 6 11]; %top depth of fault
dp{1}=[50 30 20]; %fault dip
isSurf{1}=1; %isSurf = 1 if fault breaks free surface; = 0 otherwise; = NaN if no smoothing
bss{1}=-1; % bss = 1 if left-lateral; -1 if right-lateral; = NaN if no constraint
bds{1}=1; %bds = 1 if reverse; -1 if normal; = NaN if no constraint
gss{1}=NaN; % gss (geological ss rate) = NaN if no constraint; else then value should be positive
gds{1}=NaN; % gds (geological ds rate) = NaN if no constraint; else then value should be positive
iscreep(1)=1; %iscreep = NaN if not a creeping fault; else it is a creeping fault

fault_x{2}=[121.35 121.25];
fault_y{2}=[24.90 25.15];
dep{2}=[0 15]; %top depth of fault
dp{2}=[50]; %fault dip
isSurf{2}=NaN; %isSurf = 1 if fault breaks free surface; = 0 otherwise; = NaN if no smoothing
bss{2}=1; % bss = 1 if left-lateral; -1 if right-lateral; = NaN if no constraint
bds{2}=-1; %bds = 1 if reverse; -1 if normal; = NaN if no constraint
gss{2}=NaN; % gss (geological ss rate) = NaN if no constraint; else then value should be positive
gds{2}=NaN; % gds (geological ds rate) = NaN if no constraint; else then value should be positive
iscreep(2)=NaN; %iscreep = NaN if not a creeping fault; else it is a creeping fault

fault_x{3}=[121.50 121.60 121.70 121.80];
fault_y{3}=[24.95 25.02 25.06 25.10];
dep{3}=[0 2 4 6 8 11]; %top depth of fault
dp{3}=[50 50 30 20 20]; %fault dip
isSurf{3}=1; %isSurf = 1 if fault breaks free surface; = 0 otherwise; = NaN if no smoothing
bss{3}=-1; % bss = 1 if left-lateral; -1 if right-lateral; = NaN if no constraint
bds{3}=1; %bds = 1 if reverse; -1 if normal; = NaN if no constraint
gss{3}=NaN; % gss (geological ss rate) = NaN if no constraint; else then value should be positive
gds{3}=NaN; % gds (geological ds rate) = NaN if no constraint; else then value should be positive
iscreep(3)=NaN; %iscreep = NaN if not a creeping fault; else it is a creeping fault

%specify parameters
% gamma = smoothing parameter (increasing gamma decreases roughness) 
gamma_smooth=-1;

%generate output files or not
gout=1; %gout = NaN if not generating output files; else if yes

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%load data
for k=1:size(datatype,2)
    data{k}=load(input_file{k});
end

origin=[min(data{1}(:,2)) min(data{1}(:,1))];
for k=1:size(data,2)
    xy{k} = ll2xy([data{k}(:,2) data{k}(:,1)]', origin);
end

%generate pm
pm=[];SegEnds=[];np{1}=0;
for k=1:size(fault_x,2)
    [pm_pre{k},nhe{k},nve{k}]=make_pm(fault_x{k},fault_y{k},dep{k},dp{k},origin);
    SegEnds_pre{k}=make_SegEnds(fault_x{k},fault_y{k},origin);
    pm=[pm;pm_pre{k}];
    SegEnds=[SegEnds;SegEnds_pre{k}];
    np{k+1}=np{k}+size(pm_pre{k},1);
end
npatches=size(pm,1);
   
%make baseline
for k=1:size(data,2)
    [baselines{k},Vec_unit{k},crossind{k},L{k},BaseEnds{k}]=make_baseline(xy{k},pm,pm_pre,iscreep);
end

%make baseline elongation or tilt rate matrix
for k=1:size(data,2)
    if datatype{k}==1
        [Vbase{k},Sigbase{k}]=make_elongation_rates(data{k}(:,3),data{k}(:,4),data{k}(:,5),data{k}(:,6),baselines{k},Vec_unit{k},L{k},BaseEnds{k},SegEnds);
    elseif datatype{k}==2
        [Vbase{k},Sigbase{k}]=make_tilt_rates(data{k}(:,3),data{k}(:,4),baselines{k},L{k},BaseEnds{k},SegEnds);
    elseif datatype{k}==3
        [Vbase{k},Sigbase{k}]=make_insar_tilt_rates(data{k}(:,3),data{k}(:,4),baselines{k},L{k},BaseEnds{k},SegEnds);
    end
end

%make G matrix
make_G_matrix_KE

%original data and weighting matrix
d_orig=[];
sig=[];
for k=1:size(data,2)
    d_orig=[d_orig;Vbase{k}];
    sig=[sig;Sigbase{k}];
end
C=repmat(sig,1,2*npatches);

%%calculate discrete Laplacian operator
make_smoothing

%%make new G matrix
gamma=10^(-gamma_smooth);
A=[G./C;gamma*Lapp];
d=[d_orig./sig;zeros(size(Lapp,1),1)];

%%make boundary condition for slip
make_slip_boundary

%%do least squares inversion
%s=A\d;   %standard unconstrained least squares
warning off %turn off warning about large-scale method
s=lsqlin(A,d,B,bounds);
warning on

%caclulate model velocities
dhat=G*s;
rnorm=norm((d_orig-dhat)./sig)

for  k=1:size(data,2)
    if k==1;n1=1;else n1=n1+size(Vbase{k-1},1);end
    if k==1;n2=size(Vbase{k},1);else n2=n2+size(Vbase{k},1);end
    dhat_set{k}=dhat(n1:n2,1);
end

%plot results
plot_results

%generate output files
if ~isnan(gout);output_files;end
