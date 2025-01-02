%% ========== Setup ========== %%
% ===== Reference IS-GPS-200M
% https://www.gps.gov/technical/icwg/IS-GPS-200M.pdf

% ===== Setup
clc; close all;
format longG;

% ===== Initial
% RefPose = [-2956554.94163553 5076015.62439893 2476596.00901585];
% RefPose = [-2956517.76926541 5076035.26024164 2476582.34767972]; % Information Building
RefPose = [-2956619.16455631 5075902.22105795  2476625.54446272]; % CKSV

% ===== Read Reference rcvr Data
[Refrcvrfname, Refrcvrpname] = uigetfile({'*_rcvr.dat'}, 'Please Select Reference rcvr.dat File', pwd);
Refrcvr = RcvrDataReader([Refrcvrpname Refrcvrfname]);

% ===== Read Reference eph Data
[Refephfname, Refephpname] = uigetfile({'*_eph.dat'}, 'Please Select Reference eph.dat File', Refrcvrpname);
Refeph = EphDataReader([Refephpname Refephfname]);

% ===== Output Data
OutputFolder = sprintf('OutputFigure');
if ~exist(OutputFolder, 'dir'); mkdir(OutputFolder); end
OutputPrCor = [OutputFolder '/' extractBefore(Refrcvrfname, '_rcvr') '_PrCor.mat'];

%% ========== Align Data ========== %%
[RefrcvrGroup, RefephGroup] = AlignRcvrEph(Refrcvr.Data, Refeph.Data);

%% ========== Compute Pseudorange Correction ========== %%
PrCor = cell(size(RefrcvrGroup, 1), 1);
for i = 1:size(RefrcvrGroup, 1)
    % ===== Satellite Position
    basecor = BaseCoorection(RefrcvrGroup{i}, RefephGroup{i})

    if ~isempty(basecor)
    % ===== Correct Pesudorange
        prTure = sqrt(sum((basecor(:, 5:7)-RefPose).^2, 2));
        prCor = basecor(:, 3) - prTure - basecor(:, 4);
        PrCor{i} = [basecor(:, 1:2) prCor];
    end
end
PrCor = PrCor(~cellfun('isempty', PrCor));

%% ========== Save Correction Position ========== %%
% ===== Save Correction Cell
save(OutputPrCor, 'PrCor');