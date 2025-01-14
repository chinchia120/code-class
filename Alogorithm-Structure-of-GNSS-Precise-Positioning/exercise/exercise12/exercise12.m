%% ========== Setup ========== %%
% ===== Setup
clc; clear; close all;

% ===== Creat Output Folder
OutputFolder = sprintf('OutputFigure');
if ~exist(OutputFolder, 'dir'); mkdir(OutputFolder); end

% ===== Initial Value
CKSV = [-2956619.417 5075902.173 2476625.484];
we = 7.2921151467*10^-5;
c = 299792458;
GM = 3.986005 * 10^14;

UTCTime = struct2array(load('GPSTime.mat'));
Sat_Pos = struct2array(load('CKSV_final_20230101.mat'));
Sat_Vel = struct2array(load('GVel_ecef.mat'));

%% ========== Convert Time ========== %%
TimeEpoch = UTCTime(:, 4)*3600 + UTCTime(:, 5)*60 + UTCTime(:, 6);

%% ========== Satellite Information ========== %%
% PRN_Info: [TimeEpoch SatPosX SatPosY SatPosZ SatVelX SatVelY SatVelZ PseudoRange TravelTime SagnacEffect RelativisticEffectsStc RelativisticEffectsCLK]

PRN_Info = cell(size(Sat_Pos, 1), 1);
for PRN = 1: size(Sat_Pos, 1)
    % ===== Position
    Pos = Sat_Pos(PRN, :, :);
    Pos = reshape(Pos, [size(Pos, 2:3)])';

    % ===== Velocity
    Vel = Sat_Vel(PRN, :, :);
    Vel = reshape(Vel, [size(Vel, 2:3)])';

    % ===== PseudoRange
    pr = sqrt(sum((Pos-CKSV).^2, 2));

    % ===== Travel Time
    t = pr / c;

    % ===== Sagnac Effect
    SagnacEffect = zeros(length(TimeEpoch), 1);
    theta = we * t;
    rot = RotationZ(theta);
    
    for time  = 1: length(rot)
        CKSV_Rot = rot{time}*CKSV';
        CKSV_Diff = CKSV_Rot - CKSV';
        SagnacEffect(time) = sqrt(sum(CKSV_Diff.^2));
    end

    % ===== Relativistic Effects STC
    rs = sqrt(sum(Pos.^2, 2));
    rr = sqrt(sum(CKSV.^2));
    REL_STC = 2*GM/c^2 * log((rs+rr+pr)./(rs+rr-pr));

    % ===== Relativistic Effects CLK
    REL_CLK = -2/c^2 * sum(Pos.*Vel, 2);

    % ===== PRN Information
    PRN_Info{PRN} = [TimeEpoch Pos Vel pr t SagnacEffect REL_STC REL_CLK];
end

%% ========== Correction Plot ========== %%
for PRN = 1: length(PRN_Info)
    SagnacEffectAnalysis(PRN_Info{PRN}, PRN, sprintf([OutputFolder '/Sagnac_PRN%d'], PRN));
    RelativisticEffectsSTCAnalysis(PRN_Info{PRN}, PRN, sprintf([OutputFolder '/RelSTC_PRN%d'], PRN));
    RelativisticEffectsCLKAnalysis(PRN_Info{PRN}, PRN, sprintf([OutputFolder '/RelCLK_PRN%d'], PRN));
end