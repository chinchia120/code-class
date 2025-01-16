function [] = GNSSAnalysis(x, y, OutName)
% ===== Initial Value
clf;
meany = mean(y);
meany = repmat(meany, length(x), 1);

% ===== Plot
plot(x, y, 'LineWidth', 2);
hold on;

plot(x, meany, 'LineWidth', 2);
hold off;

% ===== Config
title('Estimated Value');
xlim([x(1) x(end)]);
xlabel('Time Epoch (s)');
ylabel('Estimated X (m)');
legend('Estimated Value', sprintf('Avg = %.4f (m)', meany(1)));
grid minor;

% ===== Save Figure
saveas(gcf, [OutName '.png']);

end

