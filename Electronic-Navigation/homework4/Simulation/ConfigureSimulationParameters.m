%% ===== Transmitter configuration ===== %%
ShowVisualizations =  true;
WriteWaveformToFile = false;

% Specify the pseudo-random noise (PRN) identification number (ID) for the satellites that are visible at the receiver
PRNIDs = [PRN1, PRN2];

% Specify the number of GPS satellites in the waveform
numSat = size(PRNIDs,2);

% GPS legacy navigation data
% Set this value to 1 to generate the waveform from the first bit of the navigation data. Set this to any other number to generate waveform from the point of interest
% Starting from a random point in this example
NavDataBitStartIndex = 1321;

% Set this value to control the number of navigation data bits in the generated waveform
NumNavDataBits = 20;
    
% Define the received signal properties
% Set the center frequency of the transmission waveform
CenterFrequency = 10e6; % In Hz

% Set the sample rate of the transmission waveform
SampleRate = 38.192e6;  % In samples/sec

%% ===== Channel Configuration ===== %%
% Specify the signal-to-noise ratio (SNR)
SNRs = [-18; -18.5; -19.5; -19]; % In dB

% Delay values
sigdelay = [300.34; 587.21; 425.89; 312.88]; % Number of C/A-code chips delay

% Initialize peak Doppler shift and Doppler rate for each satellite.
peakDoppler = [3589; 4256; 8596; 9568]; % In Hz
dopplerRate = [1000; 500; 700; 500];    % In Hz/sec

%% ===== Receiver Configuration ===== %%
PLLNoiseBandwidth = 90; % In Hz
FLLNoiseBandwidth = 4;  % In Hz
DLLNoiseBandwidth = 1;  % In Hz

% Configure the integration time
IntegrationTime = 1e-3; % In seconds