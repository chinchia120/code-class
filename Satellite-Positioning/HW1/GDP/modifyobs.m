function OBS = modifyobs(OBS)

for i = 1:size(OBS.GSVID,2)
    C1prn = [];P1prn=[];C2prn=[];P2prn=[];
    if ~isempty(OBS.GC1C), C1prn = find(OBS.GC1C(:,i)~=0); end
    if ~isempty(OBS.GC1P), P1prn = find(OBS.GC1P(:,i)~=0); end
    if ~isempty(OBS.GC2C), C2prn = find(OBS.GC2C(:,i)~=0); end
    if ~isempty(OBS.GC2P), P2prn = find(OBS.GC2P(:,i)~=0); end
    
    if ~isempty(P1prn) && ~isempty(C1prn)
        OBS.GC1C(setdiff(P1prn,C1prn),i) = OBS.GC1P(setdiff(P1prn,C1prn),i);
    end
    if  ~isempty(P2prn) && ~isempty(C2prn)
        OBS.GC2P(setdiff(C2prn,P2prn),i) = OBS.GC2C(setdiff(C2prn,P2prn),i);
    end
end
OBS.GC1P = [];OBS.GC2C=[];
