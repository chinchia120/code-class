function [scenario, tdoaPairs, receiverIds] = helperCreateSingleTargetTDOAScenario(numReceivers, sensor_pos, trajectory, velocity)
    % This is a helper function and may be removed or modified in a future release.
    % This function defines the single-target scenario used in the TDOA tracking example.
    len = sqrt((trajectory(1)-trajectory(3))^2 + (trajectory(2)-trajectory(4))^2);
    scenario = trackingScenario('StopTime',len/velocity);
    scenario.UpdateRate = 1;
    
    % theta = linspace(-pi,pi,numReceivers+1);
    % r = 5000;
    % xReceiver = r*cos(theta(1:end-1));
    % yReceiver = r*sin(theta(1:end-1));
    xReceiver = [sensor_pos(:, 1)];
    yReceiver = [sensor_pos(:, 2)];
    
    % The algorithm shown in the example is suitable for 3-D workflows. 
    % Each receiver must be at different height to observe/estimate the z of the object. 
    zReceiver = zeros(1,numReceivers);
    
    for i = 1:numel(xReceiver)
        p = platform(scenario);
        p.Trajectory.Position = [xReceiver(i) yReceiver(i) zReceiver(i)];
    end
    
    % Add target
    target = platform(scenario);
    % target.Trajectory.Position = [-2500 2000 1500*(numReceivers >= 4)];
    % target.Trajectory.Velocity = [150 0 0];
    target.Trajectory.Position = [trajectory(1) trajectory(2) 0];
    [vx, vy, ~] = helperGetVelPos(trajectory, velocity);
    target.Trajectory.Velocity = [vx vy 0];
    
    % PlatformIDs of TDOA calculation pairs. Each row represents the TDOA pair [1 3] means a TDOA is calculated between 1 and 3 with 3 as the reference receiver.
    tdoaPairs = (1:(numReceivers-1))';
    tdoaPairs(:,2) = numReceivers;
    %tdoaPairs = [2, 1; 3, 1; 4, 1]; % Case2 error
    %tdoaPairs = [1, 2; 3, 2; 4, 2];
    %tdoaPairs = [1, 3; 2, 3; 4, 3]; % Case2 error
    %tdoaPairs = [1, 4; 2, 4; 3, 4]; 
    
    receiverIds = 1:numReceivers;
end