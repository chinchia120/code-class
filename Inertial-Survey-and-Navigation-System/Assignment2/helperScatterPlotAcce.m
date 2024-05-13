function [] = helperScatterPlotAcce(IMUData, type, OutputDir)
    scatter(IMUData(:, 1), IMUData(:, 2: end), 'filled');
    title(['Accelerometer and Time ', type]);
    xlabel("time (s)");
    ylabel("Acce value (m/s^2)");
    grid on;

    if size(IMUData, 2) == 2
        legend('Acce-Z');
    else
        legend('Acce-X', 'Acce-Y', 'Acce-Z');
    end

    % saveas(gcf, [OutputDir, '.fig']);
    saveas(gcf, [OutputDir, '.png']);
end

