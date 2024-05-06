function verid = chk_rnx(ofilename)

fid = fopen(ofilename);
if fid==-1,
    msg = sprintf([' 觀測檔不存在或不允許存取 \n\n', ...
        ' 請檢查檔案 : %s'],ofilename);
    msgbox(msg,' 錯誤訊息','help');
    return
end

% get rinex version
strall = fgetl(fid);
if ~ischar(strall),
    msg = sprintf([' 觀測檔沒有觀測資料 \n\n', ...
        ' 請檢查檔案 : %s'],ofilename);
    msgbox(msg,' 錯誤訊息','help');
    return
end

if any(strfind(strall,'RINEX VERSION / TYPE')),
    verid = str2double(strall(1:9));
else
    msg = sprintf([' 不符合 RINEX 觀測檔的格式 ! \n\n', ...
        ' 請檢查檔案 : %s'],ofilename);
    msgbox(msg,' 錯誤訊息','help');
    return
end

fclose(fid);