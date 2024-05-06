function [] = helperScatterPlotAcce(IMUData, OutputDir)
    scatter(IMUData(:, 1), IMUData(:, 2: end), 'filled');
    title('Accelerometer and Time', 'FontSize', 16);
    xlabel("time (s)", 'FontSize', 14);
    ylabel("Acce value (m/s^2)", 'FontSize', 14);
    legend('Acce-X', 'Acce-Y', 'Acce-Z', 'FontSize', 14);

    Pix_SS = get(0, 'screensize');
    width = 1750; height = 875;
    set(gcf, 'position', [(Pix_SS(3)-width)/2, (Pix_SS(4)-height)/2, width, height]);
    saveas(gcf, OutputDir);
end

