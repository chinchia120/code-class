% function GDP(inputs)
% GNSS Data Preprocessor
clear all
close all
%% �]�w�`�� %%
global HDR_A HDR_B OBS_A OBS_B GPSC GALC PHASE CODE 

c = 299792458;
f = 10.23.*[154 120 115 154 115 118]; % �W�v[MHz] cf. typelist
lam = 1e-6*c./f;                     % �i��[M]
typelist = {'L1','L2','L5','E1','E5a','E5b'};

%% Ū�J�[����� %%

navfile = 'CK01.23n';
obsfile1 = 'CK01.23o';
obsfile2 = 'CK01.23o';
disp(' Loading Data ... ')

% �w����
[path,name,ext] = fileparts(obsfile1);
if strcmp('.mat',ext),
    load(obsfile1);
    HDR_A = HDR; OBS_A = OBS;
    clear HDR OBS
else
    verid = chk_rnx(obsfile1);
    if (verid < 3) && (verid >= 2),
        [HDR_A,OBS_A] = loadrinexob(obsfile1);
    elseif verid == 3,
        [HDR_A,OBS_A] = loadrinexob30(obsfile1);
    else
        msg = sprintf([' ���䴩���ɮת����Τ��e�榡�A \n\n', ...
              ' ���ˬd�ɮ� : %s'],obsfile1);
        msgbox(msg,' ���~�T��','help');
        return
    end
end

% ������
[path,name,ext] = fileparts(obsfile2);
if strcmp('.mat',ext),
    load(obsfile2);
    HDR_B = HDR; OBS_B = OBS;
    clear HDR OBS
else
    verid = chk_rnx(obsfile2);
    if (verid < 3) && (verid >= 2),
        [HDR_B,OBS_B] = loadrinexob(obsfile2);
    elseif verid == 3,
        [HDR_B,OBS_B] = loadrinexob30(obsfile2);
    else
        msg = sprintf([' ���䴩���ɮת����Τ��e�榡�A \n\n', ...
              ' ���ˬd�ɮ� : %s'],obsfile2);
        msgbox(msg,' ���~�T��','help');
        return
    end
end
%

as = OBS_A.TOWSEC(1); ae = OBS_A.TOWSEC(end);
bs = OBS_B.TOWSEC(1); be = OBS_B.TOWSEC(end);
if (as<bs) && (ae<bs) || (as>be) && (ae>be),
    msg = sprintf([' �����S���ۦP�ɬq���[����ơA \n\n', ...
          ' ���ˬd�[���ɬO�_���~ ? ']);
    msgbox(msg,' ���~�T��','help');
    return
end
%% ��ƹw�B�z�Ѽ� %%
%%% ����[���q����
utype = [1 2];  % �u���ƥ�
%%% �]�w�̧C����[deg]
cutoff = 15;
%%% �R���ìP�s��
delsat=[];
%%% Cycle Slip setting
during = 15;    % �[���q�s��ɶ�(��)
slptol = 1000000;% �g�i�渨�̧C���e(����)
%%% Antenna Height of Receiver
anth1 = 0; anth2 = 0;
if any(HDR_A.ANT_HEN), anth1 = HDR_A.ANT_HEN(1);end
if any(HDR_B.ANT_HEN), anth2 = HDR_B.ANT_HEN(1);end
stnxyz = [HDR_A.STN_XYZ;HDR_B.STN_XYZ];
OBS_A = modifyobs(OBS_A);
OBS_B = modifyobs(OBS_B);
% ---------------------------------------------------------------------- %
%%% data flag
% dflg = 1 : �Ҧ��W�v�@�P�s�b��phase�H��code����[���q
% dflg = 2 : �U�W�v�s�b��phase�H��code����[���q
dflg = 1;
%%% system flag
% sflg = 1 : �ۦP�W�v���P�t���[���q�����@��
% sflg = 2 : �ۦP�W�v���P�t���[���q�������P��
sflg = 2;
%%% skyplot flag
% skyflg = 1 : �iø�[���ɬq���ìP�z�Ź�
% skyflg = 0 : ���iø�[���ɬq���ìP�z�Ź�
skyflg = 1;
% ---------------------------------------------------------------------- %

%------�e�B�z�򯸥[�W�ѽu��-------%
llh = xyz2llh(stnxyz(1,:));
llh(3) = llh(3)+anth1;
stnxyz(1,:) = llh2xyz(llh);
clear llh
llh = xyz2llh(stnxyz(2,:));
llh(3) = llh(3)+anth2;
stnxyz(2,:) = llh2xyz(llh);
clear llh

%% �簣���P�B�[���ɶ����[���q��T  %%
% allepoch:�`�[������, dtA:A���ݭ簣������, dtB:B���ݭ簣������
% ---------------------------------------------------------------------- %
if any(any(OBS_A.GSVID)) && any(any(OBS_B.GSVID)),
    epochs_A = size(OBS_A.GSVID,2);
    epochs_B = size(OBS_B.GSVID,2);
elseif any(any(OBS_A.ESVID)) && any(any(OBS_B.ESVID)),
    epochs_A = size(OBS_A.ESVID,2);
    epochs_B = size(OBS_B.ESVID,2);
else
    msg = sprintf([' �����S���ۦP�t�Ϊ��[����ơA \n\n', ...
          ' ���ˬd�[���ɬO�_���~ ? ']);
    msgbox(msg,' ���~�T��','help');
    return
end
allepoch=0; inc1=1; inc2=1; dtA=NaN; dtB=NaN; dT=1;
while 1
    m = allepoch + inc1; n = allepoch + inc2;  % m : A��; n : B��
    if (m > epochs_A) || (n > epochs_B),
        k1 = epochs_A - m;
        if k1 >= 0,dtA(inc1:inc1+k1) = (m:epochs_A);end
        k2 = epochs_B - n;
        if k2 >= 0,dtB(inc2:inc2+k2) = (n:epochs_B);end
        break,
    end
    if abs(OBS_A.TOWSEC(m)-OBS_B.TOWSEC(n)) < 0.01,
        allepoch = allepoch + 1;
        TOW(allepoch) = OBS_B.TOWSEC(n);
        if allepoch > 1, dT(allepoch-1) = TOW(allepoch)-TOW(allepoch-1); end
    elseif (OBS_A.TOWSEC(m)-OBS_B.TOWSEC(n)) > 0,
        dtB(inc2) = n;
        inc2 = inc2 + 1;
    elseif (OBS_A.TOWSEC(m)-OBS_B.TOWSEC(n)) < 0,
        dtA(inc1) = m;
        inc1 = inc1 + 1;
    end
end  % end while

if any(dtA),
    OBS_A.TG(dtA,:)=[];
    for j = 2:31,
        if any(OBS_A.(OBS_A.VAR{j}))==0,continue,end
        OBS_A.(OBS_A.VAR{j})(:,dtA) = [];
    end
end
if any(dtB),
    OBS_B.TG(dtB,:)=[];
    for j = 2:31,
        if any(OBS_B.(OBS_B.VAR{j}))==0,continue,end
        OBS_B.(OBS_B.VAR{j})(:,dtB) = [];
    end
end
% ---------------------------------------------------------------------- %
OBSINT = mode(dT); % �[���q���˶��Z[��]

%% �簣���P�B�[���ìP���[���q��T %%
% ---------------------------------------------------------------------- %
% GPS
maxid_A = size(OBS_A.GSVID,1);
maxid_B = size(OBS_B.GSVID,1);
if maxid_A > maxid_B,
    dsA = (maxid_B+1):1:maxid_A;
    for j = 4:21,
        if any(OBS_A.(OBS_A.VAR{j}))==0,continue,end
        OBS_A.(OBS_A.VAR{j})(dsA,:) = [];
    end
    Gmaxid = maxid_B;
elseif maxid_A < maxid_B,
    dsB = (maxid_A+1):1:maxid_B;
    for j = 4:21,
        if any(OBS_B.(OBS_B.VAR{j}))==0,continue,end
        OBS_B.(OBS_B.VAR{j})(dsB,:) = [];
    end
    Gmaxid = maxid_A;
else  % maxid_A == maxid_B, 
    Gmaxid = maxid_A;
end
clear dsA dsB
% Galileo
maxid_A = size(OBS_A.ESVID,1);
maxid_B = size(OBS_B.ESVID,1);
if maxid_A > maxid_B,
    dsA = (maxid_B+1):1:maxid_A;
    for j = 22:31,
        if any(OBS_A.(OBS_A.VAR{j}))==0,continue,end
        OBS_A.(OBS_A.VAR{j})(dsA,:) = [];
    end
    Emaxid = maxid_B;
elseif maxid_A < maxid_B,
    dsB = (maxid_A+1):1:maxid_B;
    for j = 22:31,
        if any(OBS_B.(OBS_B.VAR{j}))==0,continue,end
        OBS_B.(OBS_B.VAR{j})(dsB,:) = [];
    end
    Emaxid = maxid_A;
else  % maxid_A == maxid_B, 
    Emaxid = maxid_A;
end
%% �簣�p��̧C�������[���q��T %%
% ---------------------------------------------------------------------- %
[usebtn,ctype,ptype] = chk_obs2(HDR_A,HDR_B);
% utype = usebtn;
[GPSC,GALC] = getcode2(utype);
% �p��j��̧C����(cutoff)���ìP�y�� ------------------------------------- %
[gsvmat,gsvmat2,gvis,esvmat,evis,gps_week,satclkcorr] = satinfo2(navfile,cutoff,OBSINT,delsat);
% GPS
if any(any(gvis)),
    for j = 4:21,
        if any(OBS_A.(OBS_A.VAR{j}))==0,continue,end
        if any(OBS_B.(OBS_B.VAR{j}))==0,continue,end
        OBS_A.(OBS_A.VAR{j}) = gvis.*OBS_A.(OBS_A.VAR{j});
        OBS_B.(OBS_B.VAR{j}) = gvis.*OBS_B.(OBS_B.VAR{j});
    end
end
% Galileo
if any(any(evis)),
    for j = 22:31,
        if any(OBS_A.(OBS_A.VAR{j}))==0,continue,end
        if any(OBS_B.(OBS_B.VAR{j}))==0,continue,end
        OBS_A.(OBS_A.VAR{j}) = evis.*OBS_A.(OBS_A.VAR{j});
        OBS_B.(OBS_B.VAR{j}) = evis.*OBS_B.(OBS_B.VAR{j});
    end
end
% ---------------------------------------------------------------------- %
nostop = round(during*60/OBSINT);
clog(1,1) = 1;
clog(1,2) = allepoch;
if allepoch < nostop, clog = []; end
%% �p��ϥ��[���q���W�v�Ƹ�T %%
% ---------------------------------------------------------------------- %
nf = 0;
for i = 1:length(utype),
    clear iname
    u = utype(i);
    num = u;
    iname = typelist(num);
    if sflg == 1,
        if (u==1 || u==4) && all(ismember([1,4],utype)),
            if u==4,continue,end
            num = 14;
            iname = [typelist(1),typelist(4)];
        end
        if (u==3 || u==5) && all(ismember([3,5],utype)),
            if u==5,continue,end
            num = 35;
            iname = [typelist(3),typelist(5)];
        end
    end
    nf = nf + 1;
    typenum(nf) = num;
    names{nf} = iname;
    lamda(nf) = lam(u);
end
% ---------------------------------------------------------------------- %
[ptn,PHASE,CODE] = genptn(utype,ctype,ptype,dflg);
%% ���q�i��g�i�渨���� %%
% ---------------------------------------------------------------------- %
ZZ = cell(nf,size(clog,1));
for i = 1:nf,
    for j = 1:size(clog,1),
        [ZZ{i,j},ZZ{i,j}.prn,ZZ{i,j}.mat] = getobs2(clog(j,:),typenum(i),ptn);
        [ZZ{i,j}.out,ZZ{i,j}.ns] = csdfcn2(ZZ{i,j},lamda(i),nostop,slptol);
    end
end
% �ˬd�g�i�渨�����ᤧ��Ƴs���
nsec = 0; memo = []; clog2 = []; cut_session = [];
for ss = 1:size(clog,1),  % section ss
    clear nss nyes temp
    ep1 = clog(ss,1); ep2 = clog(ss,2);
    [nyes,temp] = continuity(ZZ{1,ss}.ns,nostop,1);
    if nf > 1,
        clear temp
        for i = 2:nf,
            % �C���[���q(�ìP)�ƥػݤj�� 1
            nss = continuity(ZZ{i,ss}.ns,nostop,1);
            nyes = nyes.*nss;
        end
        [nyes,temp] = continuity(nyes,nostop);
    end
    if any(temp),
        for j = 1:size(temp,1),
            nsec = nsec + 1;
            clog2(nsec,:) = temp(j,:)+ep1-1;
            memo(nsec) = ss;
        end
    else
        cut_session = [cut_session,ss]
    end
end
ZZ(:,cut_session) = [];
% clog2
if isempty(clog2),
    msg = sprintf([' �S���}�n���[����� ! \n\n', ...
        ' �й��է��]�w�ѼơC ']);
    msgbox(msg,' ���~�T��','help');
    return
end

%% ��X��ƹw�B�z���G %%
% �ìP����SVMAT�B�ìP�s��IDMAT�B�ìP����NSAT�A�H�ζg�i�渨CSMAT��T ------- %
% �q�XCODE_A/B�B�ۦ��[���qPHASE_A/B�A�H�Ψ䥦��T ------------------------ %
% ---------------------------------------------------------------------- %
L = cell(nsec,nf);
for ss2 = 1:nsec,  % section ss2
    ssk = memo(ss2);
    for i = 1:nf,
        ids = ZZ{i,ssk}.prn;
        mat{ss2,i} = ZZ{i,ssk}.out;
    end
    [w l] = size(mat{ss2,1});
    for i = 1:nf
        for ii = 1:l
            if i == 2
               LI = intersect(find(mat{ss2,i-1}(:,ii) > 0),find(mat{ss2,i}(:,ii) > 0));
               LL1 = intersect(LI,find(mat{ss2,i-1}(:,ii) == 2));
               LL2 = intersect(LI,find(mat{ss2,i}(:,ii) == 2));
               a1=zeros(length(ids{1}),1); a1(LI) = 1; a1(LL1) = 2;
               a2=zeros(length(ids{1}),1); a2(LI) = 1; a2(LL2) = 2;              
               MAT{ss2,i-1}(:,ii) = a1;
               MAT{ss2,i}(:,ii) = a2;
               clear a
            end
            if i ==1
               LI = intersect(find(mat{ss2,i}(:,ii) > 0),find(mat{ss2,i}(:,ii) > 0));
               LL1 = intersect(LI,find(mat{ss2,i}(:,ii) == 2));
               a1=zeros(length(ids{1}),1); a1(LI) = 1; a1(LL1) = 2;           
               MAT{ss2,i}(:,ii) = a1;
               clear a
            end
        end
    end

end  %% session loop end
for ss2 = 1:nsec,  % section ss2
    ep1 = clog2(ss2,1); ep2 = clog2(ss2,2);
    %     disp(['Section : ',num2str(ss2)])
    %     disp([num2str(TG(ep1,:)),' --> ',num2str(TG(ep2,:))])
    nep = ep2 - ep1 + 1;
    tspan = TOW(ep1:ep2);
    %     Gid = [];Eid=[];
    ssk = memo(ss2);
    for i = 1:nf,
                ids = ZZ{i,ssk}.prn;
        %         mat = ZZ{i,ssk}.out;
        L{ss2,i}.name = names{i};
        L{ss2,i}.lamda = lamda(i);
        [L{ss2,i}.IDMAT,L{ss2,i}.CSMAT,L{ss2,i}.NSAT] = ptnout(ids{1},tspan,MAT{ss2,i}(:,ep1:ep2));
        L{ss2,i}.PHASE = ptnout2(ZZ{i,ssk}.PHASE,MAT{ss2,i});
        [L{ss2,i}.IDC,temp,L{ss2,i}.NC] = ptnout(ids{2},tspan,MAT{ss2,i}(:,ep1:ep2));
        L{ss2,i}.CODE = ptnout2(ZZ{i,ssk}.CODE,MAT{ss2,i});
        L{ss2,i}.SVMAT = zeros(25,3,nep);
        L{ss2,i}.SVMAT2 = zeros(25,3,nep);
        L{ss2,i}.gpsweek = gps_week;
        for j = 1:nep,
            prn = ids{1}(MAT{ss2,i}(:,ep1-1+j)~=0);
            ns = length(prn);
            gid = prn(prn<50);
            eid = prn(prn>200)-200;
            if any(gid) && any(eid), % for GPS & Galileo
                L{ss2,i}.SVMAT(1:ns,:,j) = cat(1,gsvmat(gid,:,j),esvmat(gid,:,j));
                L{ss2,i}.SVMAT2(1:ns,:,j) = cat(1,gsvmat(gid,:,j),esvmat(gid,:,j));
            elseif any(gid), % for GPS-only
                %                 gid
                %                     j
                L{ss2,i}.SVMAT(1:ns,:,j) = gsvmat(gid,:,j+ep1-1);
                L{ss2,i}.SVMAT2(1:ns,:,j) = gsvmat2(gid,:,j+ep1-1);
            elseif any(Eid), % for Galileo-only
                L{ss2,i}.SVMAT(1:ns,:,j) = esvmat(eid,:,j);
                L{ss2,i}.SVMAT2(1:ns,:,j) = esvmat(eid,:,j);
            end
        end %% epoch loop end
    end %% frequency loop end
end  %% session loop end
NL = size(L,2);  %% num. of freq.
for Lf = 1:NL,
    for ss2 = 1:nsec,
        ep1 = clog2(ss2,1); ep2 = clog2(ss2,2);
        if ss2 == 1,
            La{1,Lf}.name = L{1,Lf}.name; La{1,Lf}.lamda = L{1,Lf}.lamda;
            La{1,Lf}.IDMAT = L{1,Lf}.IDMAT; La{1,Lf}.CSMAT = L{1,Lf}.CSMAT;
            La{1,Lf}.NSAT = L{1,Lf}.NSAT; La{1,Lf}.PHASE = L{1,Lf}.PHASE(:,:,ep1:ep2);
            La{1,Lf}.CODE = L{1,Lf}.CODE(:,:,ep1:ep2); 
            La{1,Lf}.IDC = L{1,Lf}.IDC; La{1,Lf}.NC = L{1,Lf}.NC;
            La{1,Lf}.SVMAT = L{1,Lf}.SVMAT; La{1,Lf}.SVMAT2 = L{1,Lf}.SVMAT2;
            La{1,Lf}.gpsweek = L{1,Lf}.gpsweek;
        else
            La{1,Lf}.IDMAT = cat(1,La{1,Lf}.IDMAT,L{ss2,Lf}.IDMAT);
            La{1,Lf}.CSMAT = cat(1,La{1,Lf}.CSMAT,L{ss2,Lf}.CSMAT);
            La{1,Lf}.NSAT = cat(2,La{1,Lf}.NSAT,L{ss2,Lf}.NSAT);
            La{1,Lf}.PHASE = cat(3,La{1,Lf}.PHASE,L{1,Lf}.PHASE(:,:,ep1:ep2));
            La{1,Lf}.IDC = cat(1,La{1,Lf}.IDC,L{ss2,Lf}.IDC);
            La{1,Lf}.NC = cat(2,La{1,Lf}.NC,L{ss2,Lf}.NC);
            La{1,Lf}.CODE = cat(3,La{1,Lf}.CODE,L{1,Lf}.CODE(:,:,ep1:ep2));
            La{1,Lf}.SVMAT = cat(3,La{1,Lf}.SVMAT,L{ss2,Lf}.SVMAT);
            La{1,Lf}.SVMAT2 = cat(3,La{1,Lf}.SVMAT2,L{ss2,Lf}.SVMAT2);        
        end
    end
end
save CK01_out La stnxyz satclkcorr HDR_A HDR_B