function [HDR,OBS] = loadrinexob(filename,sflg,decimate_factor)
%   INPUTS
%      filename = Name of the ASCII text file containing the
%             RINEX2.xx-formatted Observation data 
%             (NOTE: make sure to put the name in single 
%             quotation marks (e.g.,  loadrinexn('stkr2581.02o')  )
%      sflg = setting for loading : =1(all), =2(header only)
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
%      TG = date using gregorian fomat.
%      TOWSEC = vector of times-of-reception given in GPS time-of-week
%               in seconds
%      L1,L2 = carrier-phase measurements made on L1 and L2
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
%      CLKOFFSET = vector of receiver clock offsets as determined by the
%                    receiver itself (units of seconds)
%

if nargin<3, decimate_factor = 1; end
if nargin<2, sflg = 1; end
if decimate_factor < 1, error('decimate_factor must be a positive integer'), end
if rem(decimate_factor,1) > 0, error('decimate_factor must be a positive integer'), end

% clear all
% filename = 'sv050810.06o';
% sflg = 1;
% decimate_factor = 1;
fid = fopen(filename);
if fid==-1,
   error('RINEX Observation data file not found or permission denied');
end

%% 宣告變數
if sflg == 1,
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
linecount = 0; breakflag = 0;
while 1   % this is the numeral '1'
    strall = fgetl(fid);
    if ~ischar(strall), breakflag = 1; break, end
    linecount = linecount + 1;

    if any(strfind(strall,'END OF HEADER')),
        break
    end
    if any(strfind(strall,'RINEX VERSION / TYPE')),
        verid = str2double(strall(1:9));
        if (verid >= 3) || (verid < 2),
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
    if any(strfind(strall,'# / TYPES OF OBSERV')),
        numobtype = str2double(strall(5:6));
        if numobtype > 9, 
            error('number of types of observations > 9')
        end
        k = 11;
        for i = 1:numobtype,
            HDR.GPS_TYPE{i} = strall(k:k+1);
            k = k + 6;
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

%%  Loop through the data section 
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
       if len < 80, strall(len+1:80) = ' '; end
       %
       year(k) = str2double(strall(1:3));
       month(k) = str2double(strall(4:6));
       day(k) = str2double(strall(7:9));
       hour(k) = str2double(strall(10:12));
       minute(k) = str2double(strall(13:15));
       second(k) = str2double(strall(16:26));
   
       if year(k) > 70, 
           fullyear = 1900+year(k); 
       else, 
           fullyear = 2000+year(k);
       end
       % Time in Gregorian calendar (A.D.)
       OBS.TG(k,:) = [fullyear,month(k),day(k),hour(k),minute(k),second(k)];
       % Time of day in seconds
       todsec(k) = 3600*hour(k) + 60*minute(k) + second(k);
       daynum = dayofweek(fullyear,month(k),day(k));
       % Time of week in seconds
       OBS.TOWSEC(k) = todsec(k) + 86400*daynum;

       epochflg(k) = str2double(strall(27:29));
       if isnan(epochflg(k)), epochflg(k) = 0; end;
       numsvs(k) = str2double(strall(30:32));
       ks = 34;
       if numsvs(k) <= 12,
           for i = 1:numsvs(k),
               ch(i) = str2double(strall(ks:ks+1));
               ks = ks + 3;
           end
           OBS.CLKOFFSET(k) = str2double(strall(69:80));
       else
           for i = 1:12,
               ch(i) = str2double(strall(ks:ks+1));
               ks = ks + 3;
           end
           OBS.CLKOFFSET(k) = str2double(strall(69:80));
           strall = fgetl(fid);
           if ~ischar(strall), breakflag = 1; break, end
           linecount = linecount + 1;
           ks = 34;
           for i = 1:numsvs(k)-12,
               ch(i+12) = str2double(strall(ks:ks+1));
               ks = ks + 3;
           end
       end
       %% NOTE: Channel 1 does not always have the same satellite in it. 
       %%       When the receiver loses a satellite or starts to loses
       %%       a satellite or starts to track a new one, it will make
       %%       a slight reordering of the channels.  Thus, channel 1
       %%       might have satellite 7 in it in the beginning and then may
       %%       in the beginning and then may have satellite 6 in it at the
       %%       have satellite 6 in it at the end.  This variable 'ch'
       %%       keeps end.  This variable 'ch' keeps track of which
       %%       satellite is in which channel.
       OBS.GSVID(ch(1:numsvs(k)),k) = 1;
   
       for i = 1:numsvs(k),
           strall = fgetl(fid);
           if ~ischar(strall), break, end
           linecount = linecount + 1;
      
           len = length(strall);
           if len < 80, strall(len+1:80) = '0'; end
      
           if numobtype > 0,
              ob(ch(i),k,1) = str2double(strall(1:14));
              if isnan(ob(ch(i),k,1)), ob(ch(i),k,1)=0; end
              obLLI(ch(i),k,1) = str2double(strall(15));
              obSS(ch(i),k,1) = str2double(strall(16));
           end
           if numobtype > 1,
              ob(ch(i),k,2) = str2double(strall(17:30));
              if isnan(ob(ch(i),k,2)), ob(ch(i),k,2)=0; end
              obLLI(ch(i),k,2) = str2double(strall(31));
              obSS(ch(i),k,2) = str2double(strall(32));
           end
           if numobtype > 2,
              ob(ch(i),k,3) = str2double(strall(33:46));
              if isnan(ob(ch(i),k,3)), ob(ch(i),k,3)=0; end
              obLLI(ch(i),k,3) = str2double(strall(47));
              obSS(ch(i),k,3) = str2double(strall(48));
           end
           if numobtype > 3,
              ob(ch(i),k,4) = str2double(strall(49:62));
              if isnan(ob(ch(i),k,4)), ob(ch(i),k,4)=0; end
              obLLI(ch(i),k,4) = str2double(strall(63));
              obSS(ch(i),k,4) = str2double(strall(64));
           end
           if numobtype > 4,
              ob(ch(i),k,5) = str2double(strall(65:78));
              if isnan(ob(ch(i),k,5)), ob(ch(i),k,5)=0; end
              obLLI(ch(i),k,5) = str2double(strall(79));
              obSS(ch(i),k,5) = str2double(strall(80));
           end

           if numobtype > 5,
              strall = fgetl(fid);
              if ~ischar(strall), break, end
              linecount = linecount + 1;
      
              len = length(strall);
              if len < 80, strall(len+1:80) = '0'; end
      
              ob(ch(i),k,6) = str2double(strall(1:14));
              if isnan(ob(ch(i),k,6)), ob(ch(i),k,6)=0; end
              obLLI(ch(i),k,6) = str2double(strall(15));
              obSS(ch(i),k,6) = str2double(strall(16));
          
              if numobtype > 6,
                 ob(ch(i),k,7) = str2double(strall(17:30));
                 if isnan(ob(ch(i),k,7)), ob(ch(i),k,7)=0; end
                 obLLI(i,k,7) = str2double(strall(31));
                 obSS(i,k,7) = str2double(strall(32));
              end
          
              if numobtype > 7,
                 ob(ch(i),k,8) = str2double(strall(33:46));
                 if isnan(ob(ch(i),k,8)), ob(ch(i),k,8)=0; end
                 obLLI(i,k,8) = str2double(strall(47));
                 obSS(i,k,8) = str2double(strall(48));
              end
          
              if numobtype > 8,
                 ob(ch(i),k,9) = str2double(strall(49:62));
                 if isnan(ob(ch(i),k,9)), ob(ch(i),k,9)=0; end
                 obLLI(i,k,9) = str2double(strall(63));
                 obSS(i,k,9) = str2double(strall(64));
              end
           end    % End the "If numobtype > 5" : Another obstype
       end   % End the "for i = 1:numsvs(k)" Loop : All satellite
   end  % End the "for ideci = 1:decimate_factor" Loop : Select epoch
   if breakflag == 1, break, end
end  % End the WHILE 1 Loop

%% 分別儲存各種觀測量
for i = 1:numobtype,
    switch HDR.GPS_TYPE{i}
        case 'L1'
            OBS.GL1 = ob(:,:,i);
            OBS.GL1LLI = obLLI(:,:,i);
            OBS.GL1SS = obSS(:,:,i);
        case 'L2'
            OBS.GL2 = ob(:,:,i);
            OBS.GL2LLI = obLLI(:,:,i);
            OBS.GL2SS = obSS(:,:,i);
        case 'L5'
            OBS.GL5 = ob(:,:,i);
            OBS.GL5LLI = obLLI(:,:,i);
            OBS.GL5SS = obSS(:,:,i);
        case 'C1'
            OBS.GC1C = ob(:,:,i);
        case 'P1'
            OBS.GC1P = ob(:,:,i);
        case 'C2'
            OBS.GC2C = ob(:,:,i);
        case 'P2'
            OBS.GC2P = ob(:,:,i);
        case 'C5'
            OBS.GC5I = ob(:,:,i);
        case 'S1'
            OBS.GS1 = ob(:,:,i);
        case 'S2'
            OBS.GS2 = ob(:,:,i);
        case 'S5'
            OBS.GS5 = ob(:,:,i);
    end
end
for i = 1:31,
    if any(any(eval(['OBS.',OBS.VAR{i}])))==0,
        eval(['OBS.',OBS.VAR{i},'=[];']),
    end
end
save(outfile,'OBS','HDR')
fclose(fid);
