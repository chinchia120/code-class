%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%input parameters
[crd(:,2) crd(:,1) Veast Vnorth Vup Sigeast Signorth Sigup]=textread('interseismic_velocity_CGPS_S.dat','%f%f%f%f%f%f%f%f');

%specify fault geometry and boundary condition
fault_x{1}=[121.405 121.4200 121.435 121.4600 121.485 121.5625 121.640];
fault_y{1}=[25.01 25.0500 25.09 25.1200 25.15 25.2000 25.25];
dep{1}=[0 4 6 11]; %top depth of fault
dp{1}=[50 30 20]; %fault dip
isSurf{1}=NaN; %isSurf = 1 if fault breaks free surface; = 0 otherwise; = NaN if no smoothing
bss{1}=-1; % bss = 1 if left-lateral; -1 if right-lateral
bds{1}=1; %bds = 1 if reverse; -1 if normal
gss{1}=NaN; % gss (geological ss rate) = NaN if no constraint; else then value should be positive
gds{1}=NaN; % gds (geological ds rate) = NaN if no constraint; else then value should be positive

fault_x{2}=[121.35 121.25];
fault_y{2}=[24.90 25.15];
dep{2}=[0 15]; %top depth of fault
dp{2}=[50]; %fault dip
isSurf{2}=NaN; %isSurf = 1 if fault breaks free surface; = 0 otherwise; = NaN if no smoothing
bss{2}=1; % bss = 1 if left-lateral; -1 if right-lateral
bds{2}=-1; %bds = 1 if reverse; -1 if normal
gss{2}=NaN; % gss (geological ss rate) = NaN if no constraint; else then value should be positive
gds{2}=NaN; % gds (geological ds rate) = NaN if no constraint; else then value should be positive

fault_x{3}=[121.50 121.60 121.70 121.80];
fault_y{3}=[24.95 25.02 25.06 25.10];
dep{3}=[0 2 4 6 8 11]; %top depth of fault
dp{3}=[50 50 30 20 20]; %fault dip
isSurf{3}=NaN; %isSurf = 1 if fault breaks free surface; = 0 otherwise; = NaN if no smoothing
bss{3}=-1; % bss = 1 if left-lateral; -1 if right-lateral
bds{3}=1; %bds = 1 if reverse; -1 if normal
gss{3}=NaN; % gss (geological ss rate) = NaN if no constraint; else then value should be positive
gds{3}=NaN; % gds (geological ds rate) = NaN if no constraint; else then value should be positive

%specify parameters
% gamma = smoothing parameter (increasing gamma decreases roughness) 
gamma_smooth=-1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

origin=[min(crd(:,1)) min(crd(:,2))];
xy = ll2xy(crd', origin);

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
   
%make baseline elongation rate matrix
[Vbase,Sigbase,baselines,Vec_unit,crossind,centers,L,BaseEnds]=make_baseline_elongation_rates(Veast,Vnorth,Sigeast,Signorth,xy,pm,SegEnds);
%[Vtilt,Sigtilt]=make_baseline_tilt_rates(Vup,Sigup,xy,pm,SegEnds);

%make G matrix
make_G_matrix_KE
G=[Gss Gds];

%weighting matrix
sig=Sigbase;
C=repmat(sig,1,2*npatches);

%%calculate discrete Laplacian operator
make_smoothing

%%make new G matrix
gamma=10^(-gamma_smooth);
A=[G./C;gamma*Lapp];
d=[Vbase./sig;zeros(size(Lapp,1),1)];

%%make boundary condition for slip
make_slip_boundary

%%do least squares inversion
%s=A\d;   %standard unconstrained least squares
warning off %turn off warning about large-scale method
s=lsqlin(A,d,B,bounds);
warning on

%caclulate model velocities
dhat=G*s;
rnorm=norm((Vbase-dhat)./sig)

figure; hold on;  
for k=1:size(BaseEnds,1)
    cal(k)=dhat(k)/L(k);
    cline([BaseEnds(k,1) BaseEnds(k,3)],[BaseEnds(k,2) BaseEnds(k,4)],[cal(k) cal(k)])
end
for k=1:size(SegEnds,1);  plot([SegEnds(k,1) SegEnds(k,3)],[SegEnds(k,2) SegEnds(k,4)],'k'); end

colorbar
caxis([-1 1])
axis equal

figure; hold on;  
for k=1:size(BaseEnds,1)
    resi(k)=(Vbase(k)-dhat(k))/L(k);
    cline([BaseEnds(k,1) BaseEnds(k,3)],[BaseEnds(k,2) BaseEnds(k,4)],[resi(k) resi(k)])
end
for k=1:size(SegEnds,1);  plot([SegEnds(k,1) SegEnds(k,3)],[SegEnds(k,2) SegEnds(k,4)],'k'); end

colorbar
caxis([-1 1])
axis equal

for k=1:size(fault_x,2)
    ss_pre{k}=s(np{k}+1:np{k+1});
    ds_pre{k}=s(npatches+np{k}+1:npatches+np{k+1});
    s_pre{k}=[ss_pre{k};ds_pre{k}];
end

figure
for k=1:size(fault_x,2)
    plotpatchslip3D_vectors(pm_pre{k},s_pre{k}',nve{k});hold on
    %for k2=1:size(SegEnds_pre{k},1);  plot([SegEnds_pre{k}(k2,1) SegEnds_pre{k}(k2,3)],[SegEnds_pre{k}(k2,2) SegEnds_pre{k}(k2,4)],'k'); end
end
