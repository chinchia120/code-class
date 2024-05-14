function [N, B] = helperAllanVarModel(IMUData, type, OutputDir)
    %% Allan Variance Calculation
    % Initial value
    omega = IMUData;    
    Fs = 50;
    t0 = 1/Fs;
    theta = cumsum(omega, 1)*t0;
    maxNumM = 1000;
    L = size(theta, 1);
    maxM = 2.^floor(log2(L/2));
    m = logspace(log10(1), log10(maxM), maxNumM).';
    m = ceil(m); % m must be an integer.
    m = unique(m); % Remove duplicates.
    tau = m*t0;

    avar = zeros(numel(m), 1);
    for i = 1:numel(m)
        mi = m(i);
        avar(i,:) = sum((theta(1+2*mi:L) - 2*theta(1+mi:L-mi) + theta(1:L-2*mi)).^2, 1);
    end
    avar = avar ./ (2*tau.^2 .* (L - 2*m));
    adev = sqrt(avar);
    
    % Show Figure
    loglog(tau, adev);
    title(['Allan Deviations of ', type]);
    xlabel('\tau');
    ylabel('\sigma(\tau)');
    grid on;

    % Save figure
    % saveas(gcf, [OutputDir, 'Allan-Deviations.fig']);
    saveas(gcf, [OutputDir, 'Allan-Deviations.png']);

    %% Random Walk
    % Find the index where the slope of the log-scaled Allan deviation is equal to the slope specified
    slope = -0.5;
    logtau = log10(tau);
    logadev = log10(adev);
    dlogadev = diff(logadev) ./ diff(logtau);
    [~, i] = min(abs(dlogadev - slope));

    % Find the y-intercept of the line
    b = logadev(i) - slope*logtau(i);

    % Determine the angle random walk coefficient from the line
    logN = slope*log(1) + b;
    N = 10^logN;
    tauN = 1;
    lineN = N ./ sqrt(tau);

    %% Bias Instability
    % Find the index where the slope of the log-scaled Allan deviation is equal to the slope specified
    slope = 0;
    logtau = log10(tau);
    logadev = log10(adev);
    dlogadev = diff(logadev) ./ diff(logtau);
    [~, i] = min(abs(dlogadev - slope));

    % Find the y-intercept of the line.
    b = logadev(i) - slope*logtau(i);

    % Determine the bias instability coefficient from the line
    scfB = sqrt(2*log(2)/pi);
    logB = b - log10(scfB);
    B = 10^logB;
    tauB = tau(i);
    lineB = B * scfB * ones(size(tau));

    %% Plot the Result
    % Show figure
    tauParams = [tauN, tauB];
    params = [N, scfB*B];
    loglog(tau, adev, tau, [lineN, lineB], '--', tauParams, params, 'o');
    title(['Allan Deviation with Noise Parameters of ', type]);
    xlabel('\tau');
    ylabel('\sigma(\tau)');

    if type == "Gyroscope"
        legend('$\sigma (rad/s)$', '$\sigma_N ((rad/s)/\sqrt{Hz})$', '$\sigma_B (rad/s)$', 'Interpreter', 'latex');
    else
        legend('$\sigma (m/s^2)$', '$\sigma_N ((m/s)/\sqrt{Hz})$', '$\sigma_B (m/s^2)$', 'Interpreter', 'latex');
    end
    
    text(tauParams, params, {'N', '0.664B'})
    grid on;

    % Save figure
    % saveas(gcf, [OutputDir, 'Noise-Parameters.fig']);
    saveas(gcf, [OutputDir, 'Noise-Parameters.png']);
end