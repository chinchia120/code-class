function [] = RelativisticEffectsClkAnalysis(RelativisticEffectsClk, PRN, OutName)
% ===== Config
figure;

% ===== Relativistic Effect Stc
plot(RelativisticEffectsClk(:, 1), RelativisticEffectsClk(:, 12));

xlabel('Time Epoch (s)');
ylabel('Relativistic Effect Clk (m)');
title(sprintf('Relativistic Effect Clk of PRN %d', PRN));
grid minor;

% ===== Save Figure
saveas(gcf, [OutName '.png']);
end

