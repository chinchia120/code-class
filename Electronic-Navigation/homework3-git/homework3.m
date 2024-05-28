%% ========== Setup ========== %%
clc;
clear;
close all;

%% ========== Open Example ========== %%
% openExample('satcom/GPSWaveformGenerationExample');
% openExample('satcom/GPSL1CWaveformGenerationExample');

%% ========== GPS Waveform Generation ========== %%
% To select the content for transmitting over the in-phase and quadrature-phase branches
IBranchContent = "P(Y) + D";
QBranchContent = "C/A + D";

% Specify the satellite PRN index as an integer in the range [1,63]
PRNID = 1;

% Set this value to 1 to generate the waveform from the first bit of the navigation data
NavDataBitStartIndex = 1321;

% Set this value to control the number of navigation data bits in the generated waveform
NumNavDataBits = 1;

% Initialize the data configuration object to generate the CNAV and LNAV data
cnavConfig = HelperGPSNavigationConfig(SignalType = "CNAV", PRNID = PRNID);
lnavConfig = HelperGPSNavigationConfig(SignalType = "LNAV", PRNID = PRNID);
