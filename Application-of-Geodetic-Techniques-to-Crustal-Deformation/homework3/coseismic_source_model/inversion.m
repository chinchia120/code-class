%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%input parameters
%datatype = 1 for horizontal velocity | format: lon (¢X), lat (¢X), Deast (mm/yr), Dnorth (mm/yr), Sigeast (mm/yr), Signorth (mm/yr)
%datatype = 2 for vertical velocity | format: lon (¢X), lat (¢X), Dup (mm/yr), Sigup (mm/yr)
%datatype = 3 for insar los velocity | format: lon (¢X), lat (¢X), Dlos (mm/yr), Siglos (mm/yr)
%weightdata: larger value, lower weighting
input_file{1}='disp_h_CGPS.dat'; %input file name
datatype{1}=1;
weightdata{1}=1;
look{1}=NaN; %[flight_direction,looking angle] for InSAR data -- not applicable for other geodetic data
input_file{2}='disp_u_CGPS.dat'; %input file name
datatype{2}=2;
weightdata{2}=1;
look{2}=NaN; %[flight_direction,looking angle] for InSAR data -- not applicable for other geodetic data
input_file{3}='disp_h_SGPS.dat'; %input file name
datatype{3}=1;
weightdata{3}=1;
look{3}=NaN; %[flight_direction,looking angle] for InSAR data -- not applicable for other geodetic data
input_file{4}='disp_u_SGPS.dat'; %input file name
datatype{4}=2;
weightdata{4}=1;
look{4}=NaN; %[flight_direction,looking angle] for InSAR data -- not applicable for other geodetic data
input_file{5}='disp_u_level.dat'; %input file name
datatype{5}=2;
weightdata{5}=1;
look{5}=NaN; %[flight_direction,looking angle] for InSAR data -- not applicable for other geodetic data
%{
input_file{6}='disp_h_NDHU.dat'; %input file name
datatype{6}=1;
weightdata{6}=1;
look{6}=NaN; %[flight_direction,looking angle] for InSAR data -- not applicable for other geodetic data
input_file{7}='disp_u_NDHU.dat'; %input file name
datatype{7}=2;
weightdata{7}=1;
look{7}=NaN; %[flight_direction,looking angle] for InSAR data -- not applicable for other geodetic data
input_file{5}='co_los_asc_GA40_down.gmt'; %input file name
datatype{5}=3;
weightdata{5}=2;
look{5}=[-1.237209025118827e+01 3.2e+01]; %[flight_direction,looking angle] for InSAR data -- not applicable for other geodetic data
input_file{6}='co_los_dsc_GA40_down.gmt'; %input file name
datatype{6}=3;
weightdata{6}=2;
look{6}=[-1.676091359075176e+02 3.2e+01]; %[flight_direction,looking angle] for InSAR data -- not applicable for other geodetic data
%}

%specify fault geometry and boundary condition
fault_x{1}=[121.820000 121.807684 121.795368 121.783052 121.770736 121.758419 121.746103 121.733787 121.721471 121.709155 121.696839 121.684523 121.672207 121.659891 121.647574 121.635258 121.622942 121.610626 121.598310 121.589771 121.581233 121.572694 121.564155 121.555616 121.547078 121.538539 121.530000];
fault_y{1}=[24.225000 24.209049 24.193099 24.177148 24.161198 24.145247 24.129297 24.113346 24.097396 24.081445 24.065494 24.049544 24.033593 24.017643 24.001692 23.985742 23.969791 23.953841 23.937890 23.920654 23.903418 23.886181 23.868945 23.851709 23.834473 23.817236 23.800000];
dep{1}=[0.000000 1.500000 3.000000 4.500000 6.000000 7.500000 9.000000 10.500000 12.000000 13.500000 15.000000]; %top depth of fault
dp{1}=[56.807400 56.807400 56.807400 56.807400 56.807400 56.807400 56.807400 56.807400 56.807400 56.807400]; %fault dip
isSurf{1}=1; %isSurf = 1 if fault breaks free surface; = 0 otherwise; = NaN if no smoothing
bss{1}=1; % bss = 1 if left-lateral; -1 if right-lateral; = NaN if no constraint
bds{1}=1; %bds = 1 if reverse; -1 if normal; = NaN if no constraint
gss{1}=NaN; % gss (geological ss rate) = NaN if no constraint; else then value should be positive
gds{1}=NaN; % gds (geological ds rate) = NaN if no constraint; else then value should be positive

fault_x{2}=[121.602550 121.602367 121.602183 121.602000 121.608010 121.614020 121.620030 121.626040 121.632050 121.638060 121.644070 121.650080 121.656090];
fault_y{2}=[23.967360 23.976907 23.986453 23.996000 24.005910 24.015820 24.025730 24.035640 24.045550 24.055460 24.065370 24.075280 24.085190];
dep{2}=[0.000000 0.625000 1.250000 1.875000 2.500000 3.125000 3.750000 4.375000 5.000000]; %top depth of fault
dp{2}=[55.000000 55.000000 55.000000 55.000000 55.000000 55.000000 55.000000 55.000000]; %fault dip
isSurf{2}=1; %isSurf = 1 if fault breaks free surface; = 0 otherwise; = NaN if no smoothing
bss{2}=1; % bss = 1 if left-lateral; -1 if right-lateral; = NaN if no constraint
bds{2}=1; %bds = 1 if reverse; -1 if normal; = NaN if no constraint
gss{2}=NaN; % gss (geological ss rate) = NaN if no constraint; else then value should be positive
gds{2}=NaN; % gds (geological ds rate) = NaN if no constraint; else then value should be positive

%specify parameters
% gamma = smoothing parameter (increasing gamma decreases roughness) 
gamma_smooth=0.5;

%generate output files or not
gout=NaN; %gout = NaN if not generating output files; else if yes

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
pm=[];np{1}=0;
for k=1:size(fault_x,2)
    [pm_pre{k},nhe{k},nve{k}]=make_pm(fault_x{k},fault_y{k},dep{k},dp{k},origin);
    pm=[pm;pm_pre{k}];
    np{k+1}=np{k}+size(pm_pre{k},1);
end
npatches=size(pm,1);
   
%make G matrix
make_G_matrix_kinematic

%original data and weighting matrix
d_orig=[];sig=[];nd{1}=0;
for k=1:size(data,2)
    if datatype{k}==1
        d_orig=[d_orig;data{k}(:,3);data{k}(:,4)];
        sig=[sig;data{k}(:,5)*weightdata{k};data{k}(:,6)*weightdata{k}];
        nd{k+1}=nd{k}+size(data{k},1)*2;
    else
        d_orig=[d_orig;data{k}(:,3)];
        sig=[sig;data{k}(:,4)*weightdata{k}];
        nd{k+1}=nd{k}+size(data{k},1);
    end
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
mis=sqrt(sum((d_orig-dhat).^2)/size(d_orig,1))

for  k=1:size(data,2)
    dhat_set{k}=dhat(nd{k}+1:nd{k+1},1);
end

%plot results
plot_results

%generate output files
if ~isnan(gout);output_files;end
