function measCov = helperCalcPositionCovariance(pos,thisDetections,timeScale,emissionSpeed)
    n = numel(thisDetections);
    % Complete Jacobian from position to N TDOAs
    H = zeros(n,3);
    % Covariance of all TDOAs
    S = zeros(n,n);
    for i = 1:n
       e1 = pos - thisDetections{i}.MeasurementParameters(1).OriginPosition(:);
       e2 = pos - thisDetections{i}.MeasurementParameters(2).OriginPosition(:);
       Htdoar1 = (e1'/norm(e1))*timeScale/emissionSpeed;
       Htdoar2 = (e2'/norm(e2))*timeScale/emissionSpeed;
       H(i,:) = Htdoar1 - Htdoar2;
       S(i,i) = thisDetections{i}.MeasurementNoise;
    end
    Pinv = H'/S*H;
    % Z is not measured, use 1 as the covariance
    if Pinv(3,3) < eps
        Pinv(3,3) = 1;
    end
    
    % Insufficient information in TDOA
    if rank(Pinv) >= 3
        measCov = eye(3)/Pinv;
    else
        measCov = inf(3);
    end
    
    % Replace inf with large number
    measCov(~isfinite(measCov)) = 100;
    
    % Return a true symmetric, positive definite matrix for covariance.
    measCov = (measCov + measCov')/2;
end