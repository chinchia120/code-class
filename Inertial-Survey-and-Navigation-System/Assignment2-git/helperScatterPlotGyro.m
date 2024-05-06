function [] = helperScatterPlotGyro(IMUData, OutputDir)
    scatter(IMUData(:, 1), IMUData(:, 2: end), 'filled');
    title('Gyroscope and Time', 'FontSize', 16);
    xlabel("time (s)", 'FontSize', 14);
    ylabel("Gyro value (rad/s)", 'FontSize', 14);
    legend('Gyro-x', 'Gyro-y', 'Gyro-z', 'FontSize', 14);
    saveas(gcf, OutputDir);
end

