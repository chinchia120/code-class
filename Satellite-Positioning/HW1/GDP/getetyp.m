function outype = getetyp(intype,oflg)
%%% 輸出觀測量編碼相對應的子變數名稱(for Galileo)
% oflg = 1 : phase type name
%      = 2 : code type name
%      = 3 : all type name
%
ptype =  {'L7I','L5I','L1B'};
ptype2 = {'EL7','EL5','EL1'};

ctype =  { 'C7I', 'C5I', 'C1B'};
ctype2 = {'EC7I','EC5I','EC1B'};

outype = [];

if oflg==1,
    if ~isempty(intype),
        index = find(ismember(ptype,intype));
        outype = ptype2(index);
    end
elseif oflg==2,
    if ~isempty(intype),
        index = find(ismember(ctype,intype));
        outype = ctype2(index);
    end
elseif oflg==3,
    if ~isempty(intype),
        index1 = find(ismember(ptype,intype));
        tp1 = ptype2(index1);
        index2 = find(ismember(ctype,intype));
        tp2 = ctype2(index2);
        outype = cat(2,tp1,tp2);
    end
end
