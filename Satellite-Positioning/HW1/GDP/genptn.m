function [ptn,PHASE,CODE] = genptn(usetype,ctype,ptype,obsflg)
% 輸出共同存在觀測量之邏輯矩陣
% ptn{6,1} : 存在觀測量之邏輯矩陣(衛星數,筆數)
% obsflg = 1 : 所有頻率共同存在有phase以及code兩者觀測量
% obsflg = 2 : 各頻率存在有phase以及code兩者觀測量
%
global OBS_A OBS_B

nt = length(usetype);
ptn = cell(6,2);
PHASE = cell(6,2); CODE = cell(6,2);

if obsflg==1,
    k1=0; k2=0;
    for i = 1:nt,
        j = usetype(i);
        if isempty(ptype{j}),continue,end
        PHASE{j,1}=OBS_A.(ptype{j});
        PHASE{j,2}=OBS_B.(ptype{j});
        if j < 4, % GPS
            k1 = k1 + 1;
            if k1==1,ptn1 = ones(size(PHASE{j,1})); end
            mat1 = (PHASE{j,1}.*PHASE{j,2})~=0;
            ptn1 = ptn1.*mat1;
           
        else      % Galileo
            k2 = k2 + 1;
            if k2==1,ptn2 = ones(size(PHASE{j,1})); end
            mat2 = (PHASE{j,1}.*PHASE{j,2})~=0;
            ptn2 = ptn2.*mat2;
        end
    end
    for i = 1:nt,
        j = usetype(i);
        if isempty(ctype{j}),continue,end
        CODE{j,1}=OBS_A.(ctype{j});
        CODE{j,2}=OBS_B.(ctype{j});
        if j < 4, % GPS
            k1 = k1 + 1;
            if k1==1,ptn1 = ones(size(CODE{j,1})); end
            mat1 = (CODE{j,1}.*CODE{j,2})~=0;
            ptn1 = ptn1.*mat1;
        else      % Galileo
            k2 = k2 + 1;
            if k2==1,ptn2 = ones(size(CODE{j,1})); end
            mat2 = (CODE{j,1}.*CODE{j,2})~=0;
            ptn2 = ptn2.*mat2;
        end
    end
    ug = usetype(usetype<4);
    if any(ug),
        [ptn{ug,1}]=deal(ptn1); % for phase
        [ptn{ug,2}]=deal(ptn1); % for code
    end
    ue = usetype(usetype>3);
    if any(ue),
        [ptn{ue,1}]=deal(ptn2); % for phase
        [ptn{ue,2}]=deal(ptn2); % for code
    end
end

if obsflg==2,
    for i = 1:nt,
        j = usetype(i);
        if ~isempty(ptype{j}),
            PHASE{j,1}=OBS_A.(ptype{j});
            PHASE{j,2}=OBS_B.(ptype{j});
            if j < 4, % GPS
                ptn1{j} = (PHASE{j,1}.*PHASE{j,2})~=0;
            else      % Galileo
                ptn2{j} = (PHASE{j,1}.*PHASE{j,2})~=0;
            end
        end
        if ~isempty(ctype{j}),
            CODE{j,1}=OBS_A.(ctype{j});
            CODE{j,2}=OBS_B.(ctype{j});
            if j < 4, % GPS
                if any(any(ptn1))==0,ptn1 = ones(size(CODE{j,1})); end
                tmp1 = (CODE{j,1}.*CODE{j,2})~=0;
                ptn1 = ptn1.*tmp1;
            else      % Galileo
                if any(any(ptn2))==0,ptn2 = ones(size(CODE{j,1})); end
                tmp2 = (CODE{j,1}.*CODE{j,2})~=0;
                ptn2 = ptn2.*tmp2;
            end
        end
        if j < 4, % GPS
            ptn{j,1:2} = deal(ptn2);
        else      % Galileo
            ptn{j,1:2} = deal(ptn1);
        end
    end
end

