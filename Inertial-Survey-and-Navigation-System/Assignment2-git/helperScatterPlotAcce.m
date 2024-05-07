function [] = helperScatterPlotAcce(IMUData, type, OutputDir)
    scatter(IMUData(:, 1), IMUData(:, 2: end), 'filled');
    title(['Accelerometer and Time ', type], 'FontSize', 32);
    xlabel("time (s)", 'FontSize', 24);
    ylabel("Acce value (m/s^2)", 'FontSize', 24);
    grid on;

    if size(IMUData, 2) == 2
        legend('Acce-Z', 'FontSize', 24);
    else
        legend('Acce-X', 'Acce-Y', 'Acce-Z', 'FontSize', 24);
    end

    Pix_SS = get(0, 'screensize');
    width = 1750; height = 875;
    set(gcf, 'position', [(Pix_SS(3)-width)/2, (Pix_SS(4)-height)/2, width, height]);
    % saveas(gcf, [OutputDir, '.fig']);
    saveas(gcf, [OutputDir, '.png']);
end

