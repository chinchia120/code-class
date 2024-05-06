function storerinob(rinexfilename,matfilename)
%STORERINOB   Program to load a RINEX2 observation (measurement data)
%             file and store the data in a MATLAB file format (MAT-file)
%
%   storerinob(rinexfilename,matfilename)
%
%  INPUTS
%  rinexfilename = Name of the ASCII text file containing the
%             RINEX2-formatted observation (measurement) data 
%  matfilename = filename for the MAT-file which will be created
%                If matfilename='day258ob' then a MAT-file will
%                be created called:  day258ob.mat
%
%  NOTE: make sure to put the names in single 
%  quotation marks (e.g.,  storerinob('stkr2581.02o','day258ob')
%
%
load globalname
eval(['global ' name_v2{:,3}])
%
loadrinexob(rinexfilename)
%
matlab_info.savetime = datestr(now);
matlab_info.version  = version;
%
save(matfilename)
