%% ========== Setup ========== %%
clc;
clear;
close all;

OutputFolder = sprintf('OutputFigure');
if ~exist([pwd, '\', OutputFolder], 'dir')
    mkdir(OutputFolder);
end

%% ========== Initial Value ========== %%
% Sensor coordinate
pos_sensor0 = [-1000, -1000]; % m
pos_sensor1 = [-1000,  1000]; % m
pos_sensor2 = [ 1000,  1000]; % m
pos_sensor3 = [ 1000, -1000]; % m
pos_sensor = [pos_sensor0; pos_sensor1; pos_sensor2; pos_sensor3];

% TDOA measurement
trajectory1 = [-2000,     0, 2000,    0];
trajectory2 = [-2000, -2000, 2000, 2000];
velocity1 = 50; % m/s
velocity2 = 40; % m/s
noise_avg =  0; % m
noise_var = 16; % m^2

% Creat postion and observation
[~, ~, pos1] = helperGetVelPos(trajectory1, velocity1);
obs1 = helperCreatObservation(pos1, noise_avg, 4);

[~, ~, pos2] = helperGetVelPos(trajectory2, velocity2);
obs2 = helperCreatObservation(pos2, noise_avg, 4);

%% ========== TDOA Simulate Case 1 ========== %%
% Setup scenario with 4 receivers
numReceivers = 4;
[scenario, rxPairs] = helperCreateSingleTargetTDOAScenario(numReceivers, pos_sensor, trajectory1, velocity1);

% Define accuracy in measurements
measNoise = noise_var; % nanoseconds^2

% Display object
display = HelperTDOATrackingExampleDisplay(XLimits=3*[-1e3 1e3],YLimits=3*[-1e3 1e3],LogAccuracy=true,Title="Single Object Tracking");

% Create a GNN tracker
tracker = trackerGNN(FilterInitializationFcn=@helperInitHighSpeedKF,AssignmentThreshold=100);

while advance(scenario)
    % Elapsed time
    time = scenario.SimulationTime;

    % Simulate TDOA detections without false alarms and missed detections
    tdoaDets = helperSimulateTDOA(scenario, rxPairs, measNoise);

    % Get estimated position and position covariance as objectDetection
    % objects
    posDet = helperTDOA2Pos(tdoaDets,true);

    % Update the tracker with position detections
    tracks = tracker(posDet, time);

    % Display results
    display(scenario, rxPairs, tdoaDets, {posDet}, tracks);
end
saveas(gcf, [pwd, '\', OutputFolder, '\TDOA-Case1-track.fig']);
saveas(gcf, [pwd, '\', OutputFolder, '\TDOA-Case1-track.png']);

hold on;
plotDetectionVsTrackAccuracy(display);
hold off;
saveas(gcf, [pwd, '\', OutputFolder, '\TDOA-Case1-accuracy.fig']);
saveas(gcf, [pwd, '\', OutputFolder, '\TDOA-Case1-accuracy.png']);

%% ========== TDOA Simulate Case 2 ========== %%
% Setup scenario with 4 receivers
numReceivers = 4;
[scenario, rxPairs] = helperCreateSingleTargetTDOAScenario(numReceivers, pos_sensor, trajectory2, velocity2);

% Define accuracy in measurements
measNoise = noise_var; % nanoseconds^2

% Display object
display = HelperTDOATrackingExampleDisplay(XLimits=3*[-1e3 1e3],YLimits=3*[-1e3 1e3],LogAccuracy=true,Title="Single Object Tracking");

% Create a GNN tracker
tracker = trackerGNN(FilterInitializationFcn=@helperInitHighSpeedKF,AssignmentThreshold=100);

while advance(scenario)

    % Elapsed time
    time = scenario.SimulationTime;
    % Simulate TDOA detections without false alarms and missed detections
    tdoaDets = helperSimulateTDOA(scenario, rxPairs, measNoise);

    % Get estimated position and position covariance as objectDetection
    % objects
    posDet = helperTDOA2Pos(tdoaDets,true);

    % Update the tracker with position detections
    tracks = tracker(posDet, time);

    % Display results
    display(scenario, rxPairs, tdoaDets, {posDet}, tracks);
end
saveas(gcf, [pwd, '\', OutputFolder, '\TDOA-Case2-track.fig']);
saveas(gcf, [pwd, '\', OutputFolder, '\TDOA-Case2-track.png']);

hold on;
plotDetectionVsTrackAccuracy(display);
hold off;
saveas(gcf, [pwd, '\', OutputFolder, '\TDOA-Case2-accuracy.fig']);
saveas(gcf, [pwd, '\', OutputFolder, '\TDOA-Case2-accuracy.png']);

%% ========== Weighted Least Squares Case 1 ========== %%
scatter(pos1(:, 1), pos1(:, 2));
hold on;
scatter(obs1(:, 1), obs1(:, 2));
hold off;
axis([-2200 2200 -100 100]);
title('Weighted Least Squares Case1 Track', 'FontSize', 16);
xlabel("x [m]", 'FontSize', 14);
ylabel("y [m]", 'FontSize', 14);
grid;
legend("Object Position", "Estimated Position", 'FontSize', 12);

saveas(gcf, [pwd, '\', OutputFolder, '\WLS-Case1-track.fig']);
saveas(gcf, [pwd, '\', OutputFolder, '\WLS-Case1-track.png']);

%% ========== Weighted Least Squares Case 2 ========== %%
scatter(pos2(:, 1), pos2(:, 2));
hold on;
scatter(obs2(:, 1), obs2(:, 2));
hold off;
axis([-2200 2200 -2200 2200]);
title('Weighted Least Squares Case2 Track', 'FontSize', 16);
xlabel("x [m]", 'FontSize', 14);
ylabel("y [m]", 'FontSize', 14);
grid;
legend("Object Position", "Estimated Position", 'FontSize', 12);

saveas(gcf, [pwd, '\', OutputFolder, '\WLS-Case2-track.fig']);
saveas(gcf, [pwd, '\', OutputFolder, '\WLS-Case2-track.png']);

%% ========== Filtering Case 1 ========== %%
% Specify the initial state estimate to have zero velocity
initialState = [trajectory1(1); 0; trajectory1(2); 0];
KF = trackingKF('MotionModel', '2D Constant Velocity', 'State', initialState);

% Create measured positions for the object on a constant-velocity trajectory
dt = 1;

% Predict and correct the state of the object
for k = 1: size(obs1, 1)
    pstates1(k, :) = predict(KF, dt);
    cstates1(k, :) = correct(KF, obs1(k, :));
end

% Plot the tracks
plot(pos1(:,1), pos1(:,2), "k.", pstates1(:,1), pstates1(:,3), "+", cstates1(:,1), cstates1(:,3), "o");
axis([-2200 2200 -100 100]);
title('Filtering Case1 Track', 'FontSize', 16);
xlabel("x [m]", 'FontSize', 14);
ylabel("y [m]", 'FontSize', 14);
grid;
legend("Object position", "Predicted position", "Corrected position", 'FontSize', 12);

saveas(gcf, [pwd, '\', OutputFolder, '\KF-Case1-track.fig']);
saveas(gcf, [pwd, '\', OutputFolder, '\KF-Case1-track.png']);

% ========== Filtering Case 2 ========== %%
% Specify the initial state estimate to have zero velocity
initialState = [trajectory2(1); 0; trajectory2(2); 0];
KF = trackingKF('MotionModel', '2D Constant Velocity', 'State', initialState);

% Create measured positions for the object on a constant-velocity trajectory
dt = 1;

% Predict and correct the state of the object
for k = 1: size(obs2, 1)
    pstates2(k, :) = predict(KF, dt);
    cstates2(k, :) = correct(KF, obs2(k, :));
end

% Plot the tracks
plot(pos2(:,1), pos2(:,2), "k.", pstates2(:,1), pstates2(:,3), "+", cstates2(:,1), cstates2(:,3), "o");
axis([-2200 2200 -2200 2200]);
title('Filtering Case2 Track', 'FontSize', 16);
xlabel("x [m]", 'FontSize', 14);
ylabel("y [m]", 'FontSize', 14);
grid;
legend("Object position", "Predicted position", "Corrected position", 'FontSize', 12);

saveas(gcf, [pwd, '\', OutputFolder, '\KF-Case2-track.fig']);
saveas(gcf, [pwd, '\', OutputFolder, '\KF-Case2-track.png']);