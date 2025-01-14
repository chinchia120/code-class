function [] = SagnacEffectAnalysis(SagnacEffect, PRN, OutName)
% ===== Config
figure;

% ===== SagnacEffect
plot(SagnacEffect(:, 1), SagnacEffect(:, 10));

xlabel('Time Epoch (s)');
ylabel('Sagnac Effect (m)');
title(sprintf('Sagnac Effect of PRN %d', PRN));
grid minor;

% ===== Save Figure
saveas(gcf, [OutName '.png']);

end