function [Time,SP3X,SP3Y,SP3Z,Clk,remark] = FormSP3(filename,PRN,sep,lep)

% read precise satellite orbit form SP3 file
%
% %%%%%%%%%% HELP %%%%%%%%%%
%
% [Time,SP3X,SP3Y,SP3Z,Clk,remark] = FormSP3(filename,PRN,SEP,LEP)
%
% Input Data
% filename = SP3 filename (string type)
% PRN = Vehicle ID (number of satellite x 1 or 1 x number of satellite)
% sep = Start time,second
% lep = Last time,second
%
% Output
% Time = GPS time of each epoch,second [GPSweek GPSsec]
% SP3X = X-coordinate,m (number of epoch+1 x number of satellite)
% SP3Y = Y-coordinate,m (number of epoch+1 x number of satellite)
% SP3Z = Z-coordinate,m ((number of epoch+1 x number of satellite)
% Clk = Clock correction,microsecs (number of epoch+1 x number of satellite)
% 
% Written by  Phakphong Homniam
% December 23, 2002

%%%%%%%%%% BEGIN %%%%%%%%%%

PRN = PRN(:)';
[SP3data,numsat,header] = ReadSP3(filename);
 save SP35data SP3data 
 sep %= 259200
 lep % = 344700 %u記得改回來
sep_arr = find(SP3data(:,2) == SP3data(1,2));%find(SP3data(:,2) == 0)%sep)
lep_arr = find(SP3data(:,2) == SP3data(end,2));%find(SP3data(:,2) == 85500)%lep)

if lep < sep
    lep = sep+604800;
end
if any(lep_arr) == 0,
    lep_arr = find(SP3data(:,2) == SP3data(end,2));
end

SEP = sep_arr(end)/numsat;
LEP = lep_arr(end)/numsat;
numep = (LEP-SEP)+1;
ep = [numsat*(SEP-1)+1:numsat:numsat*(LEP-1)+1];
SP3 = SP3data(ep(1):ep(end)+numsat-1,:);
[rowSP3,colSP3] = size(SP3);
numprn = length(PRN);
if (numep-rowSP3/numsat) ~= 0
    fprintf('Err:number of epoch not complete: %f\n',numep-rowSP3/numsat-1);
    return
end

Time(1:numep,1:2) = 0;
SP3X(1:numep,1:numprn) = 0;
SP3Y(1:numep,1:numprn) = 0;
SP3Z(1:numep,1:numprn) = 0;
Clk(1:numep,1:numprn) = 0;

Time = SP3(1:numsat:numep*numsat,1:2);
for j = 1:numprn
    m = 1;
    for i = 1:rowSP3
        if SP3(i,3) == PRN(j)
            SP3X(m,j) = SP3(i,4);
            SP3Y(m,j) = SP3(i,5);
            SP3Z(m,j) = SP3(i,6);
            Clk(m,j) = SP3(i,7);
            m = m+1;
        end
    end
end
if size(SP3X,1) ~= numep
    fprintf('Error:numep\n');
    return
end
remark = [SEP LEP PRN(:)'];

%%%%%%%% RESULT %%%%%%%%
Time;
SP3X = [PRN;SP3X*1000];
SP3Y = [PRN;SP3Y*1000];
SP3Z = [PRN;SP3Z*1000];
Clk = [PRN;Clk];
remark;

%%%%%%%%%% END %%%%%%%%%%