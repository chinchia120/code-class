function [EPH,ALM] = loadrinexn(filename)
%   INPUTS
%  filename = Name of the ASCII text file containing the
%             RINEX2-formatted Navigation message data 
%             (NOTE: make sure to put the name in single 
%             quotation marks (e.g., loadrinexn('stkr2581.02n')
%
%
% clear all
% filename = 'KWEZ0170.07n';
fid = fopen(filename);
if fid==-1,
   error('RINEX Navigation message data file not found or permission denied');
end
%
%% «Å§iÅÜ¼Æ
ALM.VAR = {'ALPHA';'BETA';'UTC_A0';'UTC_A1';'UTC_TOT';'UTC_WN';'LEAP_SEC'};
for i = 1:length(ALM.VAR),
    eval(['ALM.',ALM.VAR{i},'= [];'])
end

%%  Parse header
head_lines = 0;
while 1   % this is the numeral '1'
    head_lines = head_lines + 1;
    strall = fgetl(fid);
    len = length(strall);
    if len < 80, strall(len+1:80) = ' '; end
    if any(strfind(strall,'END OF HEADER')),
        break,
    end
    if any(strfind(strall,'ION ALPHA')),
        ALM.ALPHA(1) = str2num(strall(3:14));
        ALM.ALPHA(2) = str2num(strall(15:26));
        ALM.ALPHA(3) = str2num(strall(27:38));
        ALM.ALPHA(4) = str2num(strall(39:50));
    end
    if any(strfind(strall,'ION BETA')),
        ALM.BETA(1) = str2num(strall(3:14));
        ALM.BETA(2) = str2num(strall(15:26));
        ALM.BETA(3) = str2num(strall(27:38));
        ALM.BETA(4) = str2num(strall(39:50));
    end
    if any(strfind(strall,'DELTA-UTC')),
        ALM.UTC_A0 = str2num(strall(4:23));
        ALM.UTC_A1 = str2num(strall(24:42));
        ALM.UTC_TOT = str2num(strall(43:51));
        ALM.UTC_WN = str2num(strall(52:60));
    end
    if any(strfind(strall,'LEAP SECONDS')),
        ALM.LEAP_SEC = str2num(strall(1:6));
    end
end
%
noeph = -1;
while 1,
   noeph = noeph + 1;
   strall = fgetl(fid);
   if strall == -1, break;  end
end
noeph = noeph/8;
frewind(fid);
for i = 1:head_lines, strall = fgetl(fid); end;

% 
%%  Loop through the data section
PRN      = zeros(1,noeph);
TOE      = zeros(1,noeph);
SQRTSMA  = zeros(1,noeph);
DELTAN   = zeros(1,noeph);
M0       = zeros(1,noeph);
ECCEN    = zeros(1,noeph);
ARGPERI  = zeros(1,noeph);
CUS      = zeros(1,noeph);
CUC      = zeros(1,noeph);
CRS      = zeros(1,noeph);
CRC      = zeros(1,noeph);
CIS      = zeros(1,noeph);
CIC      = zeros(1,noeph);
I0       = zeros(1,noeph);
IDOT     = zeros(1,noeph);
OMEGA0   = zeros(1,noeph);
OMEGADOT = zeros(1,noeph);
AF0      = zeros(1,noeph);
AF1      = zeros(1,noeph);
AF2      = zeros(1,noeph);
IODE     = zeros(1,noeph);
URA      = zeros(1,noeph);
HEALTH   = zeros(1,noeph);
TGD      = zeros(1,noeph);
IODC     = zeros(1,noeph);
TOM      = zeros(1,noeph);
INTV     = zeros(1,noeph);

for i = 1:noeph,
    %
    strall = fgetl(fid);
    if ~ischar(strall), break, end
    len = length(strall);
    if len < 79, strall(len+1:79) = '0'; end
    %
    PRN(i) = str2num(strall(1:2));
    %    TOC_YEAR   = str2num(strall(4:5));
    %    TOC_MONTH  = str2num(strall(7:8));
    %    TOC_DAY    = str2num(strall(10:11));
    %    TOC_HOUR   = str2num(strall(13:14));
    %    TOC_MINUTE = str2num(strall(16:17));
    %    TOC_SEC    = str2num(strall(18:22));
    AF0(i) = str2num(strall(23:41));
    AF1(i) = str2num(strall(42:60));
    AF2(i) = str2num(strall(61:79));
    % LINE 1
    strall = fgetl(fid);
    IODE(i) = str2num(strall(4:22));
    CRS(i) = str2num(strall(23:41));
    DELTAN(i) = str2num(strall(42:60));
    M0(i) = str2num(strall(61:79));
    % LINE 2
    strall = fgetl(fid);
    CUC(i) = str2num(strall(4:22));
    ECCEN(i) = str2num(strall(23:41));
    CUS(i) = str2num(strall(42:60));
    SQRTSMA(i) = str2num(strall(61:79));
    % LINE 3
    strall = fgetl(fid);
    TOE(i) = str2num(strall(4:22));
    CIC(i) = str2num(strall(23:41));
    OMEGA0(i) = str2num(strall(42:60));
    CIS(i) = str2num(strall(61:79));
    % LINE 4
    strall = fgetl(fid);
    I0(i) = str2num(strall(4:22));
    CRC(i) = str2num(strall(23:41));
    ARGPERI(i) = str2num(strall(42:60));
    OMEGADOT(i) = str2num(strall(61:79));
    % LINE 5
    strall = fgetl(fid);
    IDOT(i) = str2num(strall(4:22));
    CODES_ON_L2(i) = str2num(strall(23:41));
    TOE_WN(i) = str2num(strall(42:60));
    L2_P_FLAG(i) = str2num(strall(61:79));
    % LINE 6
    strall = fgetl(fid);
    URA(i) = str2num(strall(4:22));
    HEALTH(i) = str2num(strall(23:41));
    TGD(i) = str2num(strall(42:60));
    IODC(i) = str2num(strall(61:79));
    % LINE 7
    strall = fgetl(fid);
    len = length(strall);
    if len < 79, strall(len+1:79) = '0'; end
    TOM(i) = str2num(strall(4:22));
%     INTV(i) = str2num(strall(23:41));
%     SPARE1(i) = str2num(strall(42:60));
%     SPARE2(i) = str2num(strall(61:79));
end
%
EPH(1,:)  = PRN;
EPH(2,:)  = TOE;
EPH(3,:)  = SQRTSMA;
EPH(4,:)  = DELTAN;
EPH(5,:)  = M0;
EPH(6,:)  = ECCEN;
EPH(7,:)  = ARGPERI;
EPH(8,:)  = CUS;
EPH(9,:)  = CUC;
EPH(10,:) = CRS;
EPH(11,:) = CRC;
EPH(12,:) = CIS;
EPH(13,:) = CIC;
EPH(14,:) = I0;
EPH(15,:) = IDOT;
EPH(16,:) = OMEGA0;
EPH(17,:) = OMEGADOT;
EPH(18,:) = AF0;
EPH(19,:) = AF1;
EPH(20,:) = AF2;
EPH(21,:) = IODE;
EPH(22,:) = URA;
EPH(23,:) = HEALTH;
EPH(24,:) = TGD;
% EPH(25,:) = IODC;
% EPH(26,:) = TOM;
% EPH(27,:) = INTV;

fclose(fid);
save  EEE EPH