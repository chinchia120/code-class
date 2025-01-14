function [] = RelativisticEffectsSTCAnalysis(RelativisticEffectsSTC, PRN, OutName)
% ===== Relativistic Effect STC
plot(RelativisticEffectsSTC(:, 1), RelativisticEffectsSTC(:, 11));

xlabel('Time Epoch (s)');
ylabel('Relativistic Effect STC (m)');
xlim([RelativisticEffectsSTC(1, 1) RelativisticEffectsSTC(end, 1)]);
title(sprintf('Relativistic Effect STC of PRN %d', PRN));
grid minor;

% ===== Save Figure
saveas(gcf, [OutName '.png']);

end