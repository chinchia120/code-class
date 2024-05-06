function [gcode,ecode] = getcode2(usetype)

global HDR_A HDR_B OBS_A OBS_B  %gindex eindex

Gtyp_A = getgtyp(HDR_A.GPS_TYPE,2);
Gtyp_B = getgtyp(HDR_B.GPS_TYPE,2);
Etyp_A = getetyp(HDR_A.GAL_TYPE,2);
Etyp_B = getetyp(HDR_B.GAL_TYPE,2);
a1 = length(Gtyp_A); a2 = length(Gtyp_B); 
a3 = length(Etyp_A); a4 = length(Etyp_B); 

gflg = 1; eflg = 1;
if any(a1)==0 || any(a2)==0, gcode=0; gflg=0; end
if any(a3)==0 || any(a4)==0, ecode=0; eflg=0; end
if (any(usetype<4) && gflg==0) || (any(usetype>3) && eflg==0),
    msg = sprintf([' 測站缺少電碼觀測量， \n\n',' 請檢查觀測檔是否有誤 ? ']);
    msgbox(msg,' 錯誤訊息','help');
    return
end

%% Pseudorange for GPS
if gflg==1,
    for i = 1:a1,
        clear CODE
        if any(OBS_A.(Gtyp_A{i}))==0,continue,end
        CODE = OBS_A.(Gtyp_A{i});
        rows = find(any(CODE,2));
        for j = 1:length(rows),
            clear cols
            prn = rows(j);
            cols = find(CODE(prn,:));
            gcode.a(prn,cols) = CODE(prn,cols);
%             gindex.a(prn,cols) = i;
        end
    end
    for i = 1:a2,
        clear CODE
        if any(OBS_B.(Gtyp_B{i}))==0,continue,end
        CODE = OBS_B.(Gtyp_B{i});
        rows = find(any(CODE,2));
        for j = 1:length(rows),
            clear cols
            prn = rows(j);
            cols = find(CODE(prn,:));
            gcode.b(prn,cols) = CODE(prn,cols);
%             gindex.b(prn,cols) = i;
        end
    end
end

%% Pseudorange for Galileo
if eflg==1,
    for i = 1:a3,
        clear CODE
        if any(OBS_A.(Etyp_A{i}))==0,continue,end
        CODE = OBS_A.(Etyp_A{i});
        rows = find(any(CODE,2));
        for j = 1:length(rows),
            clear cols
            prn = rows(j);
            cols = find(CODE(prn,:));
            ecode.a(prn,cols) = CODE(prn,cols);
%             eindex.a(prn,cols) = i;
        end
    end
    for i = 1:a4,
        clear CODE
        if any(OBS_B.(Etyp_B{i}))==0,continue,end
        CODE = OBS_B.(Etyp_B{i});
        rows = find(any(CODE,2));
        for j = 1:length(rows),
            clear cols
            prn = rows(j);
            cols = find(CODE(prn,:));
            ecode.b(prn,cols) = CODE(prn,cols);
%             eindex.b(prn,cols) = i;
        end
    end
end

