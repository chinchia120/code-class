function [] = SagnacEffectAnalysis(SagnacEffect, PRN, OutName)
% ===== Sagnac Effect
plot(SagnacEffect(:, 1), SagnacEffect(:, 10));

xlabel('Time Epoch (s)');
ylabel('Sagnac Effect (m)');
xlim([SagnacEffect(1, 1) SagnacEffect(end, 1)]);
title(sprintf('Sagnac Effect of PRN %d', PRN));
grid minor;

% ===== Save Figure
saveas(gcf, [OutName '.png']);

end