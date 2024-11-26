function [] = helperPlotCACode(CA, PRN, OutputName)

% ===== Plot Figure
for i = 1: size(CA, 1)
    subplot(size(CA, 1), 1, i);
    scatter(1: 10, CA(i, 1: 10), 'blue');
    title(sprintf('PRN %02d', PRN(i)));
    grid on;
end

% ===== Plot Config
xlabel('Chip Number');
ylabel('C/A Code Value');
sgtitle('The First 10 Chips for the C/A Code', 'FontWeight', 'bold');

% ===== Save Figure
saveas(gcf, [OutputName '.fig']);
saveas(gcf, [OutputName '.png']);

end

