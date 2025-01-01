%% ========== Setup ========== %%
clc; clear; close all;

%% ========== Select RINEX Observation File ========== %%

[obsfname, obspname] = uigetfile({'*.*'}, 'Please Select RINEX Observation File', pwd);
obsFilePath = [obspname obsfname];
obsData = rinexread(obsFilePath);
[obspath, obsfile, obsext] = fileparts(obsFilePath);

%% ========== Select RINEX Navigation File ========== %%
[navfname, navpname] = uigetfile({'*.*'}, 'Please Select RINEX Navigation File', obspname);
navFilePath = [navpname navfname];
navData = rinexread(navFilePath);
[navpath, navfile, navext] = fileparts(navFilePath);

%% ========== Save Obervation Data ========== %%
% ===== GPS Satellite Constellation
obsDataGPS = obsData.GPS;

% ===== UTC Time to GPS Time
obstime = UTC2GPST(datevec(obsDataGPS.Time));

% ===== Convert to rcvr.dat Format
rcvr.rcvr_tow = obstime(:, 2);
rcvr.svid = obsDataGPS.SatelliteID;
rcvr.pr = obsDataGPS.C1C;
rcvr.carrier_phase = obsDataGPS.L1C;
if isfield(obsDataGPS, 'D2W')
    rcvr.doppler_frequency = obsDataGPS.D2W;
else
    rcvr.doppler_frequency = zeros(size(rcvr.svid));
end
rcvr.snr_dbhz = obsDataGPS.S1C;

rcvrData = [rcvr.rcvr_tow, rcvr.svid, rcvr.pr, rcvr.carrier_phase, rcvr.doppler_frequency, rcvr.snr_dbhz];

% ===== Save Observation Data
writematrix(rcvrData, [obspname obsfile '_rcvr.dat'], 'Delimiter', ' ');

%% ========== Save Navigation Data ========== %%
% ===== GPS Satellite Constellation
navDataGPS = navData.GPS;

% ===== Convert to eph.dat Format
eph.rcvr_tow = navDataGPS.Toe;
eph.svid = navDataGPS.SatelliteID;
eph.toc = eph.rcvr_tow;
eph.toe = eph.rcvr_tow;
eph.af0 = navDataGPS.SVClockBias;
eph.af1 = navDataGPS.SVClockDrift;
eph.af2 = navDataGPS.SVClockDriftRate;
eph.ura = navDataGPS.SVAccuracy;
eph.e = navDataGPS.Eccentricity;
eph.sqrta = navDataGPS.sqrtA;
eph.dn = navDataGPS.Delta_n;
eph.m0 = navDataGPS.M0;
eph.w = navDataGPS.omega;
eph.omg0 = navDataGPS.OMEGA0;
eph.i0 = navDataGPS.i0;
eph.odot = navDataGPS.OMEGA_DOT;
eph.idot = navDataGPS.IDOT;
eph.cus = navDataGPS.Cus;
eph.cuc = navDataGPS.Cuc;
eph.cis = navDataGPS.Cis;
eph.cic = navDataGPS.Cic;
eph.crs = navDataGPS.Crs;
eph.crc = navDataGPS.Crc;
eph.iod = navDataGPS.IODE;

ephData = [eph.rcvr_tow, eph.svid, eph.toc, eph.toe, eph.af0, eph.af1, eph.af2, ...
           eph.ura, eph.e, eph.sqrta, eph.dn, eph.m0, eph.w, eph.omg0, eph.i0, ...
           eph.odot, eph.idot, eph.cus, eph.cuc, eph.cis, eph.cic, eph.crs, eph.crc, eph.iod];

% ===== Save Observation Data
writematrix(ephData, [navpname navfile '_eph.dat'], 'Delimiter', ' ');