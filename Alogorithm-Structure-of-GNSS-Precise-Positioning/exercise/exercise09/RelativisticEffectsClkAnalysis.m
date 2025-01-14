function [] = RelativisticEffectsCLKAnalysis(RelativisticEffectsCLK, PRN, OutName)
% ===== Relativistic Effect CLK
plot(RelativisticEffectsCLK(:, 1), RelativisticEffectsCLK(:, 12));

xlabel('Time Epoch (s)');
ylabel('Relativistic Effect CLK (m)');
xlim([RelativisticEffectsCLK(1, 1) RelativisticEffectsCLK(end, 1)]);
title(sprintf('Relativistic Effect CLK of PRN %d', PRN));
grid minor;

% ===== Save Figure
saveas(gcf, [OutName '.png']);

end