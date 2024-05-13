function [tau, adev, N, B] = AllanVar(t0, data, maxNumM)
    theta = cumsum(data, 1)*t0;
    L = size(theta, 1);
    maxM = 2.^floor(log2(L/2));
    m = logspace(log10(1), log10(maxM), maxNumM).';
    m = ceil(m);	% m must be an integer
    m = unique(m);	% Remove duplicates
    tau = m*t0;

    avar = zeros(numel(m), 1);
    for i = 1:numel(m)
        mi = m(i);
        avar(i,:) = sum((theta(1+2*mi:L) - 2*theta(1+mi:L-mi) + theta(1:L-2*mi)).^2, 1);
    end
    avar = avar ./ (2*tau.^2 .* (L - 2*m));
    adev = sqrt(avar);

    %% Random Walk
    % Find the index where the slope of the log-scaled Allan deviation is equal to the slope specified.
    slope = -0.5;
    logtau = log10(tau(tau<100)); % tau smaller than 10e2
    logadev = log10(adev(tau<100));
    dlogadev = diff(logadev) ./ diff(logtau);
    [~, i] = min(abs(dlogadev - slope));

    % Find the y-intercept of the line.
    b = logadev(i) - slope*logtau(i);
    
    % Determine the angle random walk coefficient from the line.
    logN = slope*log(1) + b;
    N = 10^logN;

    %% Bias Instability
    % Find the index where the slope of the log-scaled Allan deviation is equal to the slope specified.
    slope = 0;
    logtau = log10(tau(tau>1 & tau<1000)); % tau between 10e0 and 10e3
    logadev = log10(adev(tau>1 & tau<1000));
    dlogadev = diff(logadev) ./ diff(logtau);
    nearslope = abs(dlogadev- slope) < sqrt(1/maxNumM); % select slope < (1/sampling density)
    [j, ~] = find(nearslope==true);
    [~, i] = min(logadev(j));

    % Find the y-intercept of the line.
    b = logadev(j(i)) - slope*logtau(j(i));

    % Determine the bias instability coefficient from the line.
    scfB = sqrt(2*log(2)/pi);
    logB = b - log10(scfB);
    B = 10^logB;

end