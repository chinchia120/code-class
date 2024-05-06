function [HDR,OBS] = loadrinexob30(filename,sflg,decimate_factor)
%   INPUTS
%      filename = Name of the ASCII text file containing the
%             RINEX2.xx-formatted Observation data 
%             (NOTE: make sure to put the name in single 
%             quotation marks (e.g.,  loadrinexn('stkr2581.02o')  )
%      decimate_factor = an integer which indicates the desired decimation
%                        of the data.  If it is equal to '1', then every
%                        data point is read in and stored.  If it is equal
%                        to '2', then every second data point is stored.
%                        If '3', then every third data point is stored,
%                        et cetera.  This is an optional parameter, the
%                        default is '1'.
%
%   OUTPUTS (ALL ARE GIVEN AS GLOBAL VARIABLES)
%      SVID_MAT = matrix of satellite measurement availability;
%                 if measurements have been made for a given satellite
%                 (i.e., prn #N) at the k-th epoch of time, then:
%                 SVID_MAT(N,k) = 1;
%      TOWSEC = vector of times-of-reception given in GPS time-of-week
%               in seconds
%      PHASE1,PHASE2 = carrier-phase measurements made on L1 and L2
%                      in units of carrier cycles (wavelengths)
%      C1 = C/A-code pseudorange measurement made on L1 in units of meters
%      P1,P2 = P(Y)-code pseudorange measurements made on L1 and L2
%              in units of meters
%      D1,D2 = Doppler measurements on L1 and L2 in units of Hz
%      S1,S2 = Raw signal strength measurements
%
%      MARKER_XYZ = approximate position of geodetic marker (WGS-84
%                   cartesian coordinates)
%      ANTDELTA:  ANTDELTA(1) = height of bottom surface of antenna 
%                               above the marker (in meters)
%                 ANTDELTA(2:3) = east and north eccentricities of antenna
%                                 center relative to the marker (in meters)
%      OBSINT = observation interval in seconds
%      CLOCKOFFSET = vector of receiver clock offsets as determined by the
%                    receiver itself (units of seconds)
%

if nargin<3, decimate_factor = 1; end
if nargin<2, sflg = 1; end
if decimate_factor < 1, error('decimate_factor must be a positive integer'), end
if rem(decimate_factor,1) > 0, error('decimate_factor must be a positive integer'), end

% clear all
% filename = 'sv062170.06o';
% sflg = 1;
% decimate_factor = 1;
fid = fopen(filename);
if fid==-1,
   error('RINEX Observation data file not found or permission denied');
end

%% 宣告變數
if sflg==1,
    [path,name,ext] = fileparts(filename);
    outfile = [name,'.mat'];
    HDR.VAR = {'STN_NAME';'RCV_TYPE';'ANT_TYPE';'STN_XYZ';'ANT_HEN';...
        'GPS_TYPE';'GAL_TYPE';'OBS_INT';'CLK_OFF';'LEAP_SEC'};
    for i = 1:length(HDR.VAR),
        eval(['HDR.',HDR.VAR{i},'= [];'])
    end
    OBS.VAR = {'TG';'TOWSEC';'CLKOFFSET';'GSVID';'GL1';'GL1LLI';'GL1SS';...
        'GL2';'GL2LLI';'GL2SS';'GL5';'GL5LLI';'GL5SS';...
        'GC1C';'GC1P';'GC2C';'GC2P';'GC5I';'GS1';'GS2';'GS5';...
        'ESVID';'EL1';'EL5';'EL7';'EC1B';'EC5I';'EC7I';...
        'ES1';'ES5';'ES7'};
    for i = 1:length(OBS.VAR),
        eval(['OBS.',OBS.VAR{i},'= [];'])
    end
else
    HDR.VAR = {'STN_NAME';'RCV_TYPE';'ANT_TYPE';'STN_XYZ';'ANT_HEN';...
        'GPS_TYPE';'GAL_TYPE';'OBS_INT';'CLK_OFF';'LEAP_SEC'};
    for i = 1:length(HDR.VAR),
        eval(['HDR.',HDR.VAR{i},'= [];'])
    end
    OBS = 0;
end

%%  Parse header section
linecount=0; breakflag=0; Gnumobtype=0; Enumobtype=0;
while 1   % this is the numeral '1'
    strall = fgetl(fid);
    if ~ischar(strall), breakflag = 1; break, end
    linecount = linecount + 1;

    len = length(strall);
    if len < 80, strall(len+1:80) = ' '; end
    
    if any(strfind(strall,'END OF HEADER')),
        break
    end
    if any(strfind(strall,'RINEX VERSION / TYPE')),
        verid = str2double(strall(1:9));
        if verid ~= 3.0, 
            error(' Incorrect rinex version ! ')
            return 
        end
    end
    if any(strfind(strall,'MARKER NAME')),
        HDR.STN_NAME = deblank(strall(1:20));
    end
    if any(strfind(strall,'REC # / TYPE / VERS')),
        HDR.RCV_TYPE = deblank(strall(21:40));
    end
    if any(strfind(strall,'ANT # / TYPE')),
        HDR.ANT_TYPE = deblank(strall(21:40));
    end
    if any(strfind(strall,'APPROX POSITION XYZ')),
        HDR.STN_XYZ(1) = str2double(strall(1:14));
        HDR.STN_XYZ(2) = str2double(strall(15:28));
        HDR.STN_XYZ(3) = str2double(strall(29:42));
    end
    if any(strfind(strall,'ANTENNA: DELTA H/E/N')),
        HDR.ANT_HEN(1) = str2double(strall(1:14));
        HDR.ANT_HEN(2) = str2double(strall(15:28));
        HDR.ANT_HEN(3) = str2double(strall(29:42));
    end
    if any(strfind(strall,'SYS / # / OBS TYPES')),
        if  strall(1) == 'G',
            Gnumobtype = str2double(strall(3:6));
            if Gnumobtype > 13,
                error('number of types of observations > 13')
            end
            k1 = 8;
            for i = 1:Gnumobtype,
                HDR.GPS_TYPE{i} = strall(k1:k1+2);
                k1 = k1 + 4;
            end
        end
        if  strall(1) == 'E',
            Enumobtype = str2double(strall(3:6));
            if Enumobtype > 13,
                error('number of types of observations > 13')
            end
            k2 = 8;
            for i = 1:Enumobtype,
                HDR.GAL_TYPE{i} = strall(k2:k2+2);
                k2 = k2 + 4;
            end
        end
    end
    if any(strfind(strall,'INTERVAL')),
        HDR.OBS_INT = str2double(strall(1:10));
    end
    if any(strfind(strall,'RCV CLOCK OFFS APPL')),
        HDR.CLK_OFF = str2double(strall(1:6));
    end
    if any(strfind(strall,'LEAP SECONDS')),
        HDR.LEAP_SEC = str2double(strall(1:6));
    end
end
if sflg==2, fclose(fid); return, end

%% Loop through the data section
k = 0; breakflag = 0;
while 1     % this is the numeral '1'
   k = k + 1;    % 'k' is keeping track of our time steps
   %
   for ideci = 1:decimate_factor,
       %
       strall = fgetl(fid);
       if ~ischar(strall), breakflag = 1; break, end
       linecount = linecount + 1;
       len = length(strall);
       if len < 65, strall(len+1:65) = ' '; end
       
       year(k) = str2double(strall(3:6));
       month(k) = str2double(strall(7:9));
       day(k) = str2double(strall(10:12));
       hour(k) = str2double(strall(13:15));
       minute(k) = str2double(strall(16:18));
       second(k) = str2double(strall(19:29));
   
       % Time in Gregorian calendar (A.D.)
       OBS.TG(k,:) = [year(k),month(k),day(k),hour(k),minute(k),second(k)];
       % Time of day in seconds
       todsec(k) = 3600*hour(k) + 60*minute(k) + second(k);
       daynum = dayofweek(year(k),month(k),day(k));
       % Time of week in seconds
       OBS.TOWSEC(k) = todsec(k) + 86400*daynum;

       epochflg(k) = str2double(strall(32));
       if isnan(epochflg(k)), epochflg(k) = 0; end;
       numsvs(k) = str2double(strall(33:35));
       OBS.CLKOFFSET(k) = str2double(strall(48:62));
       
       clear Ech Gch
       ig=0; ie=0; 
       for i = 1:numsvs(k),
           strall = fgetl(fid);
           if ~ischar(strall), break, end
           linecount = linecount + 1;
           len = length(strall);

           ks = 4;
           if strall(1) == 'G',
               Gmaxlen = 3 + 16*Gnumobtype;
               if len < Gmaxlen, strall(len+1:Gmaxlen) = ' '; end
               ig = ig + 1;
               Gch(ig) = str2double(strall(2:3));
               for jg = 1:Gnumobtype,
                   Gob(Gch(ig),k,jg) = str2double(strall(ks:ks+13));
                   GobLLI(Gch(ig),k,jg) = str2double(strall(ks+14));
                   GobSS(Gch(ig),k,jg) = str2double(strall(ks+15));
                   ks = ks + 16;
               end
           end %End GPS loop
           
           if strall(1) == 'E'
               Emaxlen = 3 + 16*Enumobtype;
               if len < Emaxlen, strall(len+1:Emaxlen) = ' '; end
               ie = ie + 1;
               Ech(ie) = str2double(strall(2:3));
               for je = 1:Enumobtype,
                   Eob(Ech(ie),k,je) = str2double(strall(ks:ks+13));
                   ks = ks + 16;
               end
           end %End GALILEO loop
       end   % End the "for i = 1:numsvs(k)" Loop : All satellite
       if any(ig), OBS.GSVID(Gch(1:ig),k) = 1; end
       if any(ie), OBS.ESVID(Ech(1:ie),k) = 1; end
   end  % End the "for ideci = 1:decimate_factor" Loop : Select epoch
   if breakflag == 1, break, end
end  % End the WHILE 1 Loop

%% 分別儲存各種觀測量
if any(Gnumobtype),
    for i = 1:Gnumobtype,
        switch HDR.GPS_TYPE{i}
            case {'L1C','L1P'}
                OBS.GL1 = Gob(:,:,i);
                OBS.GL1LLI = GobLLI(:,:,i);
                OBS.GL1SS = GobSS(:,:,i);
            case {'L2C','L2P'}
                OBS.GL2 = Gob(:,:,i);
                OBS.GL2LLI = GobLLI(:,:,i);
                OBS.GL2SS = GobSS(:,:,i);
            case 'L5I'
                OBS.GL5 = Gob(:,:,i);
                OBS.GL5LLI = GobLLI(:,:,i);
                OBS.GL5SS = GobSS(:,:,i);
            case 'C1C'
                OBS.GC1C = Gob(:,:,i);
            case 'C1P'
                OBS.GC1P = Gob(:,:,i);
            case {'C2C','C2X'}  % C2X --> L2C pseudorange
                OBS.GC2C = Gob(:,:,i);
            case 'C2P'
                OBS.GC2P = Gob(:,:,i);
            case 'C5I'
                OBS.GC5I = Gob(:,:,i);
            case {'S1C','S1P'}
                OBS.GS1 = Gob(:,:,i);
            case {'S2C','S2P'}
                OBS.GS2 = Gob(:,:,i);
            case 'S5I'
                OBS.GS5 = Gob(:,:,i);
        end
    end
end
if any(Enumobtype),
    for i = 1:Enumobtype,
        switch HDR.GAL_TYPE{i}
            case 'L1B'
                OBS.EL1 = Eob(:,:,i);
            case 'L5I'
                OBS.EL5 = Eob(:,:,i);
            case 'L7I'
                OBS.EL7 = Eob(:,:,i);
            case 'C1B'
                OBS.EC1B = Eob(:,:,i);
            case 'C5I'
                OBS.EC5I = Eob(:,:,i);
            case 'C7I'
                OBS.EC7I = Eob(:,:,i);
            case 'S1B'
                OBS.ES1 = Eob(:,:,i);
            case 'S5I'
                OBS.ES5 = Eob(:,:,i);
            case 'S7I'
                OBS.ES7 = Eob(:,:,i);
        end
    end
end
for i = 1:31,
    if any(any(eval(['OBS.',OBS.VAR{i}])))==0,
        eval(['OBS.',OBS.VAR{i},'=[];']),
    end
end
save(outfile,'OBS','HDR')
fclose(fid);
