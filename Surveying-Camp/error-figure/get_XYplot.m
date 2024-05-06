%% XY Plot %%
function output = get_XYplot(data_, scale_, title_, filename_)
    x_ = data_(:, 1);
    y_ = data_(:, 2);
    dx_ = data_(:, 3);
    dy_ = data_(:, 4);
    
    for i = 1: size(data_, 1)
        if check_GCP(data_(i, :))
            GCP = scatter(data_(i, 1), data_(i, 2), 'filled', "k");
        else
            CP = scatter(data_(i, 1), data_(i, 2), 'filled', "b");
        end
        hold on;
    end
    title(title_);
    xlabel('Easting (m)');
    ylabel('Northing (m)');

    error = quiver(x_, y_, dx_*scale_, dy_*scale_, 0);
    error.ShowArrowHead = 'on';

    xlim([min(x_)-20, max(x_)+20]);
    ylim([min(y_)-20, max(y_)+20]);
    set(gca, 'xticklabel',  get(gca, 'xtick'));
    set(gca, 'yticklabel',  get(gca, 'ytick'));

    scale_str = ['Error Vector (1: ', num2str(scale_), ')'];
    legend([GCP, CP, error], 'GCP', 'CP', scale_str, 'Location', 'northeastoutside');
    
    saveas(gcf, filename_);
    hold off;

    output = [];
end