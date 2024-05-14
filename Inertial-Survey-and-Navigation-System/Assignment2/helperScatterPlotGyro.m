function [] = helperScatterPlotGyro(IMUData, type, OutputDir)
    scatter(IMUData(:, 1), IMUData(:, 2: end), 'filled');
    title(['Gyroscope and Time ', type]);
    xlabel("time (s)");
    ylabel("gyro value (rad/s)");
    grid on;

    if size(IMUData, 2) == 2
        legend('Gyro-Z');
    else
        legend('Gyro-X', 'Gyro-Y', 'Gyro-Z');
    end
    
    % saveas(gcf, [OutputDir, '.fig']);
    saveas(gcf, [OutputDir, '.png']);
end

