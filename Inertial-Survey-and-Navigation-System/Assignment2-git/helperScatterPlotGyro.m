function [] = helperScatterPlotGyro(IMUData, OutputDir)
    scatter(IMUData(:, 1), IMUData(:, 2: end), 'filled');
    title('Gyroscope and Time', 'FontSize', 32);
    xlabel("time (s)", 'FontSize', 24);
    ylabel("Gyro value (rad/s)", 'FontSize', 24);

    if size(IMUData, 2) == 2
        legend('Gyro-Z', 'FontSize', 24);
    else
        legend('Gyro-X', 'Gyro-Y', 'Gyro-Z', 'FontSize', 24);
    end

    Pix_SS = get(0, 'screensize');
    width = 1750; height = 875;
    set(gcf, 'position', [(Pix_SS(3)-width)/2, (Pix_SS(4)-height)/2, width, height]);
    % saveas(gcf, [OutputDir, '.fig']);
    saveas(gcf, [OutputDir, '.png']);
end

