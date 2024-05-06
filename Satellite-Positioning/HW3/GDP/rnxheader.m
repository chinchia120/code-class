function header = rnxheader(obsfile)

[path,name,ext] = fileparts(obsfile);
if strcmp('.mat',ext),
    load(obsfile);
    header = HDR;
else
    verid = chk_rnx(obsfile);
    if (verid < 3) && (verid >= 2),
        header = loadrinexob(obsfile,2);
    elseif verid == 3,
        header = loadrinexob30(obsfile,2);
    else
        msg = sprintf([' 不支援的檔案版本或內容格式 ! \n\n', ...
              ' 請檢查檔案 : %s'],obsfile);
        msgbox(msg,' 錯誤訊息','help');
    end
end
