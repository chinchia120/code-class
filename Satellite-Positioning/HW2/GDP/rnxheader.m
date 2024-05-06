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
        msg = sprintf([' ���䴩���ɮת����Τ��e�榡 ! \n\n', ...
              ' ���ˬd�ɮ� : %s'],obsfile);
        msgbox(msg,' ���~�T��','help');
    end
end
