function loadrinexob(filename,decimate_factor)
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
%      TG = date using gregorian fomat.
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
%      CLKOFFSET = vector of receiver clock offsets as determined by the
%                    receiver itself (units of seconds)
%
global MARKER_XYZ ANTDELTA OBSINT CLKOFFSET SVID_MAT TOWSEC TG
global PHASE1 PHASE2 C1 P1 P2 D1 D2 S1 S2
global PHASE1LLI PHASE1SS PHASE2LLI PHASE2SS 
global C1LLI C1SS P1LLI P1SS P2LLI P2SS

if nargin<2, decimate_factor = 1; end
if decimate_factor < 1, error('decimate_factor must be a positive integer'), end
if rem(decimate_factor,1) > 0, error('decimate_factor must be a positive integer'), end

fid = fopen(filename);
if fid==-1
   error('RINEX Observation data file not found or permission denied');
end

%% Pre-load parameters in case the file omits any of them =================== %%
PHASE1=NaN; PHASE1LLI=NaN; PHASE1SS=NaN;
PHASE2=NaN; PHASE2LLI=NaN; PHASE2SS=NaN;
C1=NaN; C1LLI=NaN; C1SS=NaN; P1=NaN; P1LLI=NaN; P1SS=NaN;
P2=NaN; P2LLI=NaN; P2SS=NaN; D1=NaN; D2=NaN; S1=NaN; S2=NaN;
MARKER_XYZ=NaN; ANTDELTA=NaN; OBSINT=NaN; CLKOFFSET=NaN;

%%  Parse header section =========================================== %%
linecount = 0;
while 1   % this is the numeral '1'
    line = fgetl(fid);
    linecount = linecount + 1;

    if any(strfind(line,'END OF HEADER')),
        break
    end
    if any(strfind(line,'APPROX POSITION XYZ')),
        MARKER_XYZ(1) = str2double(line(1:14));
        MARKER_XYZ(2) = str2double(line(15:28));
        MARKER_XYZ(3) = str2double(line(29:42));
    end
    if any(strfind(line,'ANTENNA: DELTA H/E/N')),
        ANTDELTA(1) = str2double(line(1:14));
        ANTDELTA(2) = str2double(line(15:28));
        ANTDELTA(3) = str2double(line(29:42));
    end
    if any(strfind(line,'# / TYPES OF OBSERV')),
        numobtype = str2double(line(5:6));
        if numobtype > 9, 
            error('number of types of observations > 9')
        end
        obtype(1,:) = line(11:12);
        obtype(2,:) = line(17:18);
        obtype(3,:) = line(23:24);
        obtype(4,:) = line(29:30);
        obtype(5,:) = line(35:36);
        obtype(6,:) = line(41:42);
        obtype(7,:) = line(47:48);
        obtype(8,:) = line(53:54);
        obtype(9,:) = line(59:60);
    end
    if any(strfind(line,'INTERVAL')),
        OBSINT = str2double(line(1:10));
    end
    if any(strfind(line,'RCV CLOCK OFFS APPL')),
        clkoffappl = str2double(line(1:6));
    end
    if any(strfind(line,'LEAP SECONDS')),
        leapsec = str2double(line(1:6));
    end
end

%%  Loop through the data section ===================================== %%
k = 0; breakflag = 0;
while 1     % this is the numeral '1'
   k = k + 1;    % 'k' is keeping track of our time steps
   %
   for ideci = 1:decimate_factor,
       %
       line = fgetl(fid);
       if ~ischar(line), breakflag = 1; break, end
       linecount = linecount + 1;
       len = length(line);
       if len < 80, line(len+1:80) = ' '; end
       %
       year(k) = str2double(line(1:3));
       month(k) = str2double(line(4:6));
       day(k) = str2double(line(7:9));
       hour(k) = str2double(line(10:12));
       minute(k) = str2double(line(13:15));
       second(k) = str2double(line(16:26));
   
       % Time of day in seconds
       todsec(k) = 3600*hour(k) + 60*minute(k) + second(k);
       if year(k) > 70, 
           fullyear = 1900+year(k); 
       else, 
           fullyear = 2000+year(k);
       end
       % Time in Gregorian calendar (A.D.)
       TG(k,:) = [fullyear,month(k),day(k),hour(k),minute(k),second(k)];
       daynum = dayofweek(fullyear,month(k),day(k));
       % Time of week in seconds
       TOWSEC(k) = todsec(k) + 86400*daynum;

       epochflg(k) = str2double(line(27:29));
       if isnan(epochflg(k)), epochflg(k) = 0; end;
       numsvs(k) = str2double(line(30:32));
       ch(1) = str2double(line(34:35)); %% NOTE: Channel 1 does not
       ch(2) = str2double(line(37:38)); %% always have the same satellite
       ch(3) = str2double(line(40:41)); %% in it.  When the receiver
       ch(4) = str2double(line(43:44)); %% loses a satellite or starts to
       ch(5) = str2double(line(46:47)); %% track a new one, it will make
       ch(6) = str2double(line(49:50)); %% a slight reordering of the 
       ch(7) = str2double(line(52:53)); %% channels.  Thus, channel 1
       ch(8) = str2double(line(55:56)); %% might have satellite 7 in it
       ch(9) = str2double(line(58:59)); %% in the beginning and then may
       ch(10) = str2double(line(61:62));%% have satellite 6 in it at the
       ch(11) = str2double(line(64:65));%% end.  This variable 'ch' keeps
       ch(12) = str2double(line(67:68));%% track of which satellite is in
       %                                %% which channel
       CLKOFFSET(k) = str2double(line(69:80));
       SVID_MAT(ch(1:numsvs(k)),k) = 1;
   
       for i = 1:numsvs(k),
           line = fgetl(fid);
           if ~ischar(line), break, end
           linecount = linecount + 1;
      
           len = length(line);
           if len < 80, line(len+1:80) = ' '; end
      
           if numobtype > 0,
              ob(ch(i),k,1) = str2double(line(1:14));
              obLLI(ch(i),k,1) = str2double(line(15));
              obSS(ch(i),k,1) = str2double(line(16));
           end
           if numobtype > 1,
              ob(ch(i),k,2) = str2double(line(17:30));
              obLLI(ch(i),k,2) = str2double(line(31));
              obSS(ch(i),k,2) = str2double(line(32));
           end
           if numobtype > 2,
              ob(ch(i),k,3) = str2double(line(33:46));
              obLLI(ch(i),k,3) = str2double(line(47));
              obSS(ch(i),k,3) = str2double(line(48));
           end
           if numobtype > 3,
              ob(ch(i),k,4) = str2double(line(49:62));
              obLLI(ch(i),k,4) = str2double(line(63));
              obSS(ch(i),k,4) = str2double(line(64));
           end
           if numobtype > 4,
              ob(ch(i),k,5) = str2double(line(65:78));
              obLLI(ch(i),k,5) = str2double(line(79));
              obSS(ch(i),k,5) = str2double(line(80));
           end

           if numobtype > 5,
              line = fgetl(fid);
              if ~ischar(line), break, end
              linecount = linecount + 1;
      
              len = length(line);
              if len < 80, line(len+1:80) = ' '; end
      
              ob(ch(i),k,6) = str2double(line(1:14));
              obLLI(ch(i),k,6) = str2double(line(15));
              obSS(ch(i),k,6) = str2double(line(16));
          
              if numobtype > 6,
                 ob(ch(i),k,7) = str2double(line(17:30));
                 obLLI(i,k,7) = str2double(line(31));
                 obSS(i,k,7) = str2double(line(32));
              end
          
              if numobtype > 7,
                 ob(ch(i),k,8) = str2double(line(33:46));
                 obLLI(i,k,8) = str2double(line(47));
                 obSS(i,k,8) = str2double(line(48));
              end
          
              if numobtype > 8,
                 ob(ch(i),k,9) = str2double(line(49:62));
                 obLLI(i,k,9) = str2double(line(63));
                 obSS(i,k,9) = str2double(line(64));
              end
           end    % End the "If numobtype > 5" : Another obstype
       end   % End the "for i = 1:numsvs(k)" Loop : All satellite
   end  % End the "for ideci = 1:decimate_factor" Loop : Select epoch
   if breakflag == 1, break, end
end  % End the WHILE 1 Loop

%% 分別儲存各種觀測量
for i = 1:numobtype,
    if strcmp(obtype(i,:),'L1'),
        PHASE1 = ob(:,:,i);
        PHASE1LLI = obLLI(:,:,i);
        PHASE1SS = obSS(:,:,i);
    end
    if strcmp(obtype(i,:),'L2'),
        PHASE2 = ob(:,:,i);
        PHASE2LLI = obLLI(:,:,i);
        PHASE2SS = obSS(:,:,i);
    end
    if strcmp(obtype(i,:),'C1'),
        C1 = ob(:,:,i);
        C1LLI = obLLI(:,:,i);
        C1SS = obSS(:,:,i);
    end
    if strcmp(obtype(i,:),'P1'),
        P1 = ob(:,:,i);
        P1LLI = obLLI(:,:,i);
        P1SS = obSS(:,:,i);
    end
    if strcmp(obtype(i,:),'P2'),
        P2 = ob(:,:,i);
        P2LLI = obLLI(:,:,i);
        P2SS = obSS(:,:,i);
    end
    if strcmp(obtype(i,:),'D1'),
        D1 = ob(:,:,i);
    end
    if strcmp(obtype(i,:),'D2'),
        D2 = ob(:,:,i);
    end
    if strcmp(obtype(i,:),'S1'),
        S1 = ob(:,:,i);
    end
    if strcmp(obtype(i,:),'S2'),
        S2 = ob(:,:,i);
    end
end    
