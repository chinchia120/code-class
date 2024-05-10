function [tau,adev,N,K,B,tauB] = AllanVar(t0,data,maxNumM,rw_tau_lim,rrw_tau_lim,b_tau_lim)
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
    selected_tau = tau(tau<rw_tau_lim);
    selected_adev = adev(tau<rw_tau_lim);
    logtau = log10(selected_tau); 
    logadev = log10(selected_adev);
    dlogadev = diff(logadev) ./ diff(logtau);
    [~, i] = min(abs(dlogadev - slope));

    % Find the y-intercept of the line.
    b = logadev(i) - slope*logtau(i);
    
    % Determine the angle random walk coefficient from the line.
    logN = slope*log(1) + b;
    N = 10^logN;
    %% Rate Random Walk
    % Find the index where the slope of the log-scaled Allan deviation is equal
    % to the slope specified.
    slope = 0.5;
    selected_tau = tau(tau>rrw_tau_lim);
    selected_adev = adev(tau>rrw_tau_lim);
    logtau = log10(selected_tau);
    logadev = log10(selected_adev);
    dlogadev = diff(logadev) ./ diff(logtau);
    [~, i] = min(abs(dlogadev - slope));
    
    % Find the y-intercept of the line.
    b = logadev(i) - slope*logtau(i);
    
    % Determine the rate random walk coefficient from the line.
    logK = slope*log10(3) + b;
    K = 10^logK;
    %% Bias Instability
    % Find the index where the slope of the log-scaled Allan deviation is equal to the slope specified.
    slope = 0;
    selected_tau = tau(b_tau_lim(1)<tau & tau<b_tau_lim(2));
    selected_adev = adev(b_tau_lim(1)<tau & tau<b_tau_lim(2));
    logtau = log10(selected_tau); 
    logadev = log10(selected_adev);
    dlogadev = diff(logadev) ./ diff(logtau);
    nearslope = abs(dlogadev- slope) < sqrt(1/maxNumM); % select slope < (1/sampling density)
    [j, ~] = find(nearslope==true);
    [~, i] = min(logadev(j));

    % Find the y-intercept of the line.
    b = logadev(j(i)) - slope*logtau(j(i));
    tauB = selected_tau(j(i));

    % Determine the bias instability coefficient from the line.
    scfB = sqrt(2*log(2)/pi);
    logB = b - log10(scfB);
    B = 10^logB;
end