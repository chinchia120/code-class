function [] = helperAllanVarPlot(AllanData, type, OutputDir)
    [avar,tau] = allanvar(AllanData, 'octave', 50);
    loglog(tau, avar);
    title(['Allan Variance ', type], 'FontSize', 32);
    xlabel('\tau', 'FontSize', 24);
    ylabel('\sigma^2(\tau)', 'FontSize', 24);
    grid on;

    Pix_SS = get(0, 'screensize');
    width = 1750; height = 875;
    set(gcf, 'position', [(Pix_SS(3)-width)/2, (Pix_SS(4)-height)/2, width, height]);
    % saveas(gcf, [OutputDir, '.fig']);
    saveas(gcf, [OutputDir, '.png']);
end