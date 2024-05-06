function outype = getgtyp(intype,oflg)
%%% 輸出觀測量編碼相對應的子變數名稱(for GPS)
% oflg = 1 : phase type name
%      = 2 : code type name
%      = 3 : all type name
%
ptype =  { 'L5', 'L2', 'L1','L5I','L2C','L1C','L2P','L1P'};
ptype2 = {'GL5','GL2','GL1','GL5','GL2','GL1','GL2','GL1'};

% 存在優先順序
ctype =  {  'C2',  'C1',  'P2',  'P1', 'C5I', 'C2C', 'C2X', 'C1C', 'C2P', 'C1P'};
ctype2 = {'GC2C','GC1C','GC2P','GC1P','GC5I','GC2C','GC2X','GC1C','GC2P','GC1P'};

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
