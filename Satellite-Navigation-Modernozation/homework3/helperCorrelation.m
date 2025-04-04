function [shift] = helperCorrelation(S1, S2, PRN, OutputName)

% ===== Setup
clf;

% ===== Initial Value
R = zeros(1, length(S1));

% ===== Cross-Correlation
for i = 1: length(S1)
    R(i) = sum(S1.*S2)/length(S1);
    
    S2 = circshift(S2, 1);
end

% ===== Plot Cross-Correlation Result
plot(0: length(R)-1, R);
hold on;

% ===== Plot Config
if size(PRN) == 1 
    % ===== Find Peak
    [maxR, maxshift] = max(R);
    [minR, minshift] = min(R);
    
    if abs(maxR) > abs(minR); peak = maxR; shift = maxshift-1;
    else; peak = minR; shift = minshift-1; end

    % ==== Plot Peak
    plot(shift, peak, '*');
    text(shift+20, peak, sprintf('[%d, %.2f]', shift, peak));

    title(sprintf('Auto-Correlation of PRN %2d', PRN));
else
    title(sprintf('Cross-Correlation of PRN %2d and PRN %2d', PRN));
end 

xlabel('Time Shift');
ylabel('Normalized Correlation');
xlim([0 length(R)-1]);
grid on;

% ===== Save Figure
saveas(gcf, [OutputName '.fig']);
saveas(gcf, [OutputName '.png']);

end