function [GSV,GSV2,Gout,ESV,Eout,gps_week, satclkcorr] = satinfo2(nfile,cutoff,tinc,delsats)
 %% 輸出觀測時段之衛星衛星坐標
% Syntax
%    [GSV,Gout] = satinfo(navfile,cutoff)
%                or
%    [GSV,Gout,ESV,Eout] = satinfo(navfile,cutoff)
%
% Input 
%    nfile = Navigation filename. EX: 'sv050810.06n' or 'd081xyz.mat'
%    cutoff  = Maskangle
%    delsats = delete PRN number of satellite
%    tinc = time interval
%
% Output
%    GSV = WGS'84 (x,y,z) coordinates for satellite. (GPS)
%    Gout   = Satellite position pattern. (GPS)
%    ESV = WGS'84 (x,y,z) coordinates for satellite. (Galileo)
%    Eout   = Satellite position pattern. (Galileo)
%
% Function
%    cpeleazi1,loadrinexn,svposeph,xyz2llh
%
%% 
if nargin < 4, delsats = []; end
if nargin < 3, error('insufficient number of input arguments'),end

global HDR_A HDR_B OBS_A OBS_B GPSC 

[path,name,ext] = fileparts(nfile);
if strcmp('.mat',ext),
    sflg = 3;
elseif strcmp('.sp3',ext),
    % Global constants of the relevant parameters in constant_global.m file
    constant_global
    sflg = 2;
else
    sflg = 1;
end
%%
 c = 299792458;
xyz_A = HDR_A.STN_XYZ;
xyz_B = HDR_B.STN_XYZ;
plh_A = xyz2llh(xyz_A);
plh_B = xyz2llh(xyz_B);
% for true data (GPS nav)
if sflg==1,
    gps_week= [];
    EPH = loadrinexn(nfile);
    GSVID = OBS_A.GSVID.*OBS_B.GSVID;
    [maxid,epochs] = size(GSVID);
    GSV = zeros(maxid,3,epochs);
    GSV2 = zeros(maxid,3,epochs);
    Gout = zeros(maxid,epochs);
    satclkcorr = zeros(35,epochs);

    prns = setdiff(find(any(GSVID,2)),delsats);
    ns = length(prns);
    for i = 1:ns,
        if ~ismember(prns(i),EPH(1,:)),
            msg = ['No ephemeris information for PRN # ',num2str(prns(i))];
            error(msg);
        end
    end
    for i = 1:epochs,
        tow = OBS_A.TOWSEC(i);
        clear prno svpos svpos2 elev ele index
        k = 0;
        for j = 1:ns,
            prn = prns(j);
            ephs = EPH(:,(EPH(1,:)==prn));
            % Estimate the time-of-transmission
            tot = tow - (GPSC.a(prn,i))/c;
            tot2 = tow - (GPSC.b(prn,i))/c;
            if GSVID(prn,i),
                k = k + 1;
                ieph = find_eph2(ephs,prn,tow);
                [svxyz,E] = svposeph(ieph,tot);
                [svxyz2,E2] = svposeph(ieph,tot2);
                % Calculate satellite clock correction
                sv_clk = svclkcorr(ieph,tot,E);  % in meter
                sv_clk2 = svclkcorr(ieph,tot2,E2);  % in meter
                % PseudoRange corrected for satellite clock error
                crange = GPSC.a(prn,i) + sv_clk;
                crange2 = GPSC.b(prn,i) + sv_clk2;
                satclkcorr(prn,i) = sv_clk;
                %===SVclock改正 for code=========================%
%                   if (any(OBS_A.GC1C)~=0),OBS_A.GC1C(prn,i) = OBS_A.GC1C(prn,i)+ sv_clk;end
%                   if (any(OBS_A.GC1P)~=0),OBS_A.GC1P(prn,i) = OBS_A.GC1P(prn,i)+ sv_clk;end 
%                   if (any(OBS_A.GC2P)~=0),OBS_A.GC2P(prn,i) = OBS_A.GC2P(prn,i)+ sv_clk;end 
%                   if (any(OBS_B.GC1C)~=0),OBS_B.GC1C(prn,i) = OBS_B.GC1C(prn,i)+ sv_clk2;end
%                   if (any(OBS_B.GC1P)~=0),OBS_B.GC1P(prn,i) = OBS_B.GC1P(prn,i)+ sv_clk2;end 
%                   if (any(OBS_B.GC2P)~=0),OBS_B.GC2P(prn,i) = OBS_B.GC2P(prn,i)+ sv_clk2;end 
%               %=======================================%
                % Adjust satellite position for earth rotation correction
                svpos(k,:) = erotcorr(svxyz,crange);
                svpos2(k,:) = erotcorr(svxyz2,crange2);
                prno(k) = prn;
                rho = sqrt((svpos(k,1)-xyz_A(1))^2+(svpos(k,2)-xyz_A(2))^2+(svpos(k,3)-xyz_A(3))^2);
                rho2 = sqrt((svpos2(k,1)-xyz_B(1))^2+(svpos2(k,2)-xyz_B(2))^2+(svpos2(k,3)-xyz_B(3))^2);
                rclk = (GPSC.a(prn,i)-rho+sv_clk)/c;
                rclk2 = (GPSC.b(prn,i)-rho2+sv_clk2)/c;
                rho_old = rho;
            end
        end
        elev(1,:) = cpeleazi1(svpos,xyz_A,plh_A);
%         elev(2,:) = cpeleazi1(svpos2,xyz_B,plh_B);
        ele(1,:) = min(elev,[],1);
        index = find(ele >= cutoff);
        GSV(prno(index),:,i) = svpos(index,:);
        GSV2(prno(index),:,i) = svpos2(index,:);
%         GSV2 = GSV;
        Gout(prno(index),i) = 1;
    end
    ESV = 0; Eout = 0;
end

% for true data (GPS sp3)
if sflg==2,
    NAJ = 999999.999999;
    GSVID = OBS_A.GSVID.*OBS_B.GSVID;
    [maxid,epochs] = size(GSVID);
    GSV = zeros(maxid,3,epochs);
    GSV2 = zeros(maxid,3,epochs);
    Gout = zeros(maxid,epochs);
    prns = setdiff(find(any(GSVID,2)),delsats);    
    SP3_processor_new(nfile,[nfile(1:8) HDR_A.STN_NAME(1:2) HDR_B.STN_NAME(1:2) 'sp3_out'],prns,OBS_A.TG(1,:),OBS_A.TG(end,:),tinc,2)
    file_exist = exist([nfile(1:8) HDR_A.STN_NAME(1:2) HDR_B.STN_NAME(1:2) 'sp3_out2.mat']);
    if file_exist ~= 2
        SP3_interp([nfile(1:8) HDR_A.STN_NAME(1:2) HDR_B.STN_NAME(1:2) 'sp3_out'],[nfile(1:8) HDR_A.STN_NAME(1:2) HDR_B.STN_NAME(1:2) 'sp3_out2.mat'],tinc)
    end
    
%     SP3_interp('sp3_out','sp3_out2',tinc)
    load([nfile(1:8) HDR_A.STN_NAME(1:2) HDR_B.STN_NAME(1:2) 'sp3_out2.mat'])
    gps_week =  SP3time(1,1);
    save lginput prns SP3time SP3X SP3Y SP3Z SP3clk xyz_B xyz_B
    clear prns SP3time SP3X SP3Y SP3Z SP3clk xyz_B xyz_B
    load('lginput')
    
    SP3X(1,:) = [];     
    SP3Y(1,:) = [];    
    SP3Z(1,:) = [];    
    SP3time = SP3time(:,2);
    SP3clk(1,:) = []; 
    rT = OBS_A.TOWSEC;
    % Langrange InterPolation Constants
    % Number of points used in LG orbit interpolation
    nXYZ_30 = 9;
    % Number of points used in LG clock interpolation
    nCLK_30 = 9;
    
    NumEpo = length(SP3time);
    NumSat = length(prns);
    
  epochs = 2840%120 %因為SP3  23:45後沒有資料 %%這裡要記得改 重要重要
%   epochstart = 48960;%1
%   epochend = epochstart + epochs;
    length(rT)
    for i = 1:epochs 
        if SP3time(end) <= rT(i),break,end
        if i > NumEpo, break,end
        clear prno svpos svpos2 elev ele index
        k = 0;
        for j = 1:NumSat,
            prn = prns(j);
            if GSVID(prn,i) == 1,
                k = k + 1;
                CLKsat(i) = SVCLK(rT(i),SP3time,SP3clk(:,j),GPSC.a(prn,i),nCLK_30,NAJ); % get 衛星時鐘改正
                if CLKsat(i) == NAJ
                    CLKsat(i) = 0;
                end
                CLKsat2(i) = SVCLK(rT(i),SP3time,SP3clk(:,j),GPSC.b(prn,i),nCLK_30,NAJ); %get 衛星時鐘改正
                if CLKsat2(i) == NAJ
                    CLKsat2(i) = 0;
                end     
%                 %===SVclock改正 for code=========================%
                  if any(OBS_A.GC1C) ~=0,OBS_A.GC1C(prn,i) = OBS_A.GC1C(prn,i)+c*CLKsat(i)*10^-6;end
                  if any(OBS_A.GC1P) ~=0,OBS_A.GC1P(prn,i) = OBS_A.GC1P(prn,i)+c*CLKsat(i)*10^-6;end 
                  if any(OBS_A.GC2P) ~=0,OBS_A.GC2P(prn,i) = OBS_A.GC2P(prn,i)+c*CLKsat(i)*10^-6;end 
                  if any(OBS_B.GC1C) ~=0,OBS_B.GC1C(prn,i) = OBS_B.GC1C(prn,i)+c*CLKsat2(i)*10^-6;end
                  if any(OBS_B.GC1P) ~=0,OBS_B.GC1P(prn,i) = OBS_B.GC1P(prn,i)+c*CLKsat2(i)*10^-6;end 
                  if any(OBS_B.GC2P) ~=0,OBS_B.GC2P(prn,i) = OBS_B.GC2P(prn,i)+c*CLKsat2(i)*10^-6;end 
%                 %=======================================%
                 X = SatPo_new(rT(i),GPSC.a(prn,i),CLKsat(i) ...   %get sat pos with 地球旋轉改正 (Sta1)
                        ,SP3time,SP3X(:,j),SP3Y(:,j),SP3Z(:,j) ...
                        ,xyz_A,nXYZ_30,NAJ,0);
                 X2 = SatPo_new(rT(i),GPSC.b(prn,i),CLKsat2(i) ...   % get sat pos with 地球旋轉改正 (Sta2)
                        ,SP3time,SP3X(:,j),SP3Y(:,j),SP3Z(:,j) ...
                        ,xyz_B,nXYZ_30,NAJ,0);
                svpos(k,:) = X(:,1);
                svpos2(k,:) = X2(:,1);
                prno(k) = prn;
            end
        end
%         save SSS  svpos xyz_A plh_A svpos2 xyz_B plh_B GSVID prns
        elev(1,:) = cpeleazi1(svpos,xyz_A,plh_A);
        elev(2,:) = cpeleazi1(svpos2,xyz_B,plh_B);
        save EEEL elev
        ele(1,:) = min(elev,[],1);
        index = find(ele >= cutoff);
        GSV(prno(index),:,i) = svpos(index,:);
        GSV2(prno(index),:,i) = svpos2(index,:);
        Gout(prno(index),i) = 1;
    end
    ESV = 0; Eout = 0;
end
        
% for simulation data (GPS + Galileo)
if sflg==3,
    load(nfile);  % load gsvmat & esvmat
    GSV=0; Gout=0; ESV=0; Eout=0;
    if any(any(OBS_A.GSVID)) && any(any(OBS_B.GSVID)),
        GSVID = OBS_A.GSVID.*OBS_B.GSVID;
        [maxid,epochs] = size(GSVID);
        gid = size(gsvmat,1);
        GSV = zeros(maxid,3,epochs);
        Gout = zeros(maxid,epochs);
        for i = 1:epochs,
            clear prns prno ids svpos elev ele index
            prns = find(GSVID(:,i));
            prno = prns(~ismember(prns,delsats));
            k = 0;
            for ks = 1:length(prno),
                id = prno(ks);
                if (id > gid) || any(gsvmat(id,:,i))==0,continue,end
                k = k + 1;
                ids(k) = id;
                svpos(k,:) = gsvmat(id,:,i);
            end
            elev(1,:) = cpeleazi1(svpos,xyz_A,plh_A);
            elev(2,:) = cpeleazi1(svpos,xyz_B,plh_B);
            ele(1,:) = min(elev,[],1);
            index = find(ele >= cutoff);
            GSV(ids(index),:,i) = svpos(index,:);
            Gout(ids(index),i) = 1;
        end
    end
    if any(any(OBS_A.ESVID)) && any(any(OBS_B.ESVID)),
        ESVID = OBS_A.ESVID.*OBS_B.ESVID;
        [maxid,epochs] = size(ESVID);
        eid = size(esvmat,1);
        ESV = zeros(maxid,3,epochs);
        Eout = zeros(maxid,epochs);
        for i = 1:epochs,
            clear prns prno ids svpos elev ele index
            prns = find(ESVID(:,i));
            prno = prns(~ismember(prns+200,delsats));
            k = 0;
            for ks = 1:length(prno),
                id = prno(ks);
                if (id > eid) || any(esvmat(id,:,i))==0,continue,end
                k = k + 1;
                ids(k) = id;
                svpos(k,:) = esvmat(id,:,i);
            end
            elev(1,:) = cpeleazi1(svpos,xyz_A,plh_A);
            elev(2,:) = cpeleazi1(svpos,xyz_B,plh_B);
            ele(1,:) = min(elev,[],1);
            index = find(ele >= cutoff);
            ESV(ids(index),:,i) = svpos(index,:);
            Eout(ids(index),i) = 1;
        end
    end
%     GSV2 = [];%模擬資料只需ㄧ站衛星位置即可,與真實資料不同
end