function [] = RelativisticEffectsStcAnalysis(RelativisticEffectsStc, PRN, OutName)
% ===== Config
figure;

% ===== Relativistic Effect Stc
plot(RelativisticEffectsStc(:, 1), RelativisticEffectsStc(:, 11));

xlabel('Time Epoch (s)');
ylabel('Relativistic Effect Stc (m)');
title(sprintf('Relativistic Effect Stc of PRN %d', PRN));
grid minor;

% ===== Save Figure
saveas(gcf, [OutName '.png']);

end