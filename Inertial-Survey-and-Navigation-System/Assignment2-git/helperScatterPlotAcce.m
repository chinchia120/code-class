function [] = helperScatterPlotAcce(IMUData, OutputDir)
    scatter(IMUData(:, 1), IMUData(:, 2: end), 'filled');
    title('Accelerometer and Time', 'FontSize', 16);
    xlabel("time (s)", 'FontSize', 14);
    ylabel("Gyro value (m/s^2)", 'FontSize', 14);
    legend('Acce-x', 'Acce-y', 'Acce-z', 'FontSize', 14);
    saveas(gcf, OutputDir);
end

