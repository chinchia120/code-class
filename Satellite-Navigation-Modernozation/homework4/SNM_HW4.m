%% ========== Setup ========== %%
% ===== Setup
clc; clear; close all;

% ===== Creat Output Folder
OutputFolder = sprintf('OutputFigure');
if ~exist(OutputFolder, 'dir'); mkdir(OutputFolder); end

% ===== Initial Value
c = 299792458;              % the speed of light (m/s)
w = 7.2921151467 * 10^-5;   % earth rotation rate
GM = 3.986005 * 10^14;      % gravitation constant
F = -4.442807633 * 10^-10;  % relativistic correction term constant
X0 = [-2950000; 5070000; 2470000];

%% ========== Problem ========== %%
% ===== Read Data
rcvr = RcvrDataReader('DataFile_hw4/rcvr.dat');
eph = EphDataReader('DataFile_hw4/eph.dat');


