function [] = helperCorrelation(S1, S2, PRN, OutputName)

% ===== Initial Value
clf;
R = zeros(1, length(S1));

% ===== Cross-Correlation
for i = 1: length(S1)
    R(i) = sum(S1.*S2)/length(S1);
    
    S2 = circshift(S2, 1);
end

% ===== Plot Cross-Correlation Result
plot(R);
hold on;

% ===== Plot Config
if size(PRN) == 1 
    % ===== Find Peak
    [maxR, maxshift] = max(R);
    [minR, minshift] = min(R);
    
    if abs(maxR) > abs(minR); peak = maxR; shift = maxshift;
    else; peak = minR; shift = minshift; end

    % ==== Plot Peak
    plot(shift, peak, '*');
    text(shift+20, peak, sprintf('[%d, %.2f]', shift, peak));

    title(sprintf('Auto-Correlation of PRN %2d', PRN));
else
    title(sprintf('Cross-Correlation of PRN %2d and PRN %2d', PRN));
end 

xlabel('Time Shift');
ylabel('Normalized Correlation');
xlim([1 length(R)]);
grid on;

% ===== Save Figure
saveas(gcf, [OutputName '.fig']);
saveas(gcf, [OutputName '.png']);

end