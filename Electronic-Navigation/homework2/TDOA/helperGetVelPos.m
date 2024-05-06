function [vx, vy, pos] = helperGetVelPos(trajectory, velocity)
    len = sqrt((trajectory(1)-trajectory(3))^2 + (trajectory(2)-trajectory(4))^2);
    vx = velocity*(abs(trajectory(1)-trajectory(3)))/len;
    vy = velocity*(abs(trajectory(2)-trajectory(4)))/len;

    if trajectory(1) == trajectory(3)
        pos_y = trajectory(2): vy: trajectory(4);
        pos_x = zeros(1, size(pos_y, 2));
    elseif trajectory(2) == trajectory(4)
        pos_x = trajectory(1): vx: trajectory(3);
        pos_y = zeros(1, size(pos_x, 2));
    else
        pos_x = trajectory(1): vx: trajectory(3);
        pos_y = trajectory(2): vy: trajectory(4);
    end
    pos = [pos_x; pos_y]';
end

