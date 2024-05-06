function [] = scatter_plot(X_, Y_, Title_, FigureName_)    
    % ---------- Subplot 1 ---------- %
    subplot(3, 1, 1);
    scatter(X_, Y_(:, 1), '.', 'b');

    title([Title_, ' of Direction X'], 'FontSize', 16);
    xlabel('Time', 'FontSize', 14);
    ylabel('Residual (m)', 'FontSize', 14);
    
    % ---------- Subplot 2 ---------- %
    subplot(3, 1, 2);
    scatter(X_, Y_(:, 2), '.', 'r');

    title([Title_, ' of Direction Y'], 'FontSize', 16);
    xlabel('Time', 'FontSize', 14);
    ylabel('Residual (m)', 'FontSize', 14);
    
    % ---------- Subplot 3 ---------- %
    subplot(3, 1, 3);
    scatter(X_, Y_(:, 3), '.', 'k');

    title([Title_, ' of Direction Z'], 'FontSize', 16);
    xlabel('Time', 'FontSize', 14);
    ylabel('Residual (m)', 'FontSize', 14);
    
    % ---------- Save Figure ---------- %
    Pix_SS = get(0, 'screensize');
    width = 1750; height = 875;
    set(gcf, 'position', [(Pix_SS(3)-width)/2, (Pix_SS(4)-height)/2, width, height]);
    saveas(gcf, FigureName_);
end
