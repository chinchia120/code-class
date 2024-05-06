function verid = chk_rnx(ofilename)

fid = fopen(ofilename);
if fid==-1,
    msg = sprintf([' �[���ɤ��s�b�Τ����\�s�� \n\n', ...
        ' ���ˬd�ɮ� : %s'],ofilename);
    msgbox(msg,' ���~�T��','help');
    return
end

% get rinex version
strall = fgetl(fid);
if ~ischar(strall),
    msg = sprintf([' �[���ɨS���[����� \n\n', ...
        ' ���ˬd�ɮ� : %s'],ofilename);
    msgbox(msg,' ���~�T��','help');
    return
end

if any(strfind(strall,'RINEX VERSION / TYPE')),
    verid = str2double(strall(1:9));
else
    msg = sprintf([' ���ŦX RINEX �[���ɪ��榡 ! \n\n', ...
        ' ���ˬd�ɮ� : %s'],ofilename);
    msgbox(msg,' ���~�T��','help');
    return
end

fclose(fid);