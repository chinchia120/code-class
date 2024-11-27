function [] = helperPlotCACode(CA, PRN, chip, OutputName)

% ===== Setup
clf;

% ===== Initial Value
chips = repmat(1:chip, 2, 1);
chips = chips((2: end));

% ===== Plot Figure
for i = 1: size(CA, 1)
    % ===== Subplot with Different PRN 
    subplot(size(CA, 1), 1, i);

    % ===== Plot Square Wave
    for j = 2: length(chips)
        if chips(j-1) ~= chips(j); plot([chips(j-1) chips(j)], [CA(i, chips(j-1)) CA(i, chips(j-1))], 'red', LineWidth=2);
        else; plot([chips(j-1) chips(j)], [CA(i, chips(j-2)) CA(i, chips(j-1))], 'red', LineWidth=2); end
        
        hold on;
    end

    % ===== Plot Signal Value
    scatter(1: chip, CA(i, 1: chip), 'blue', LineWidth=2);
    hold on;

    % ===== Subplot Config
    title(sprintf('PRN %02d', PRN(i)));
    xlim([1 chip]);
    ylim([0 1]);
    grid on;
end

% ===== Plot Config
main = axes('visible', 'off');
main.XLabel.Visible='on';
main.YLabel.Visible='on';
xlabel(main,'Chip Number');
ylabel(main,'C/A Code Value');
sgtitle(sprintf('The First %02d Chips for the C/A Code', chip));

% ===== Save Figure
saveas(gcf, [OutputName '.fig']);
saveas(gcf, [OutputName '.png']);

end