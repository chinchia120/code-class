function varargout = helperTDOA2Pos(tdoaDets, reportDetection)
    % This function uses the spherical intersection algorithm to find the object position from the TDOA detections assumed to be from the same object.
    % This function assumes that all TDOAs are measured with respect to the same reference sensor. 
    % [pos, posCov] = helperTDOA2Pos(tdoaDets) returns the estimated position and position uncertainty covariance.
    % posDetection = helperTDOA2Pos(tdoaDets, true) returns the estimate position and uncertainty covariance as an objectDetection object. 
    
    if nargin < 2
        reportDetection = false;
    end
    
    % Collect scaling information
    params = helperGetGlobalParameters;
    emissionSpeed = params.EmissionSpeed;
    timeScale = params.TimeScale;
    
    % Location of the reference receiver
    referenceLoc = tdoaDets{1}.MeasurementParameters(2).OriginPosition(:);
    
    % Formulate the problem. See [1] for more details
    d = zeros(numel(tdoaDets),1);
    delta = zeros(numel(tdoaDets),1);
    S = zeros(numel(tdoaDets),3);
    for i = 1:numel(tdoaDets)
        receiverLoc = tdoaDets{i}.MeasurementParameters(1).OriginPosition(:);
        d(i) = tdoaDets{i}.Measurement*emissionSpeed/timeScale;
        delta(i) = norm(receiverLoc - referenceLoc)^2 - d(i)^2;
        S(i,:) = receiverLoc - referenceLoc;
    end
    
    % Pseudo-inverse of S
    Swstar = pinv(S);
    
    % Assemble the quadratic range equation
    STS = (Swstar'*Swstar);
    a = 4 - 4*d'*STS*d;
    b = 4*d'*STS*delta;
    c = -delta'*STS*delta;
    
    Rs = zeros(2,1);
    % Imaginary solution, return a location outside coverage
    if b^2 < 4*a*c 
        varargout{1} = 1e10*ones(3,1);
        varargout{2} = 1e10*eye(3);
        return;
    end
    
    % Two range values
    Rs(1) = (-b + sqrt(b^2 - 4*a*c))/(2*a);
    Rs(2) = (-b - sqrt(b^2 - 4*a*c))/(2*a);
    
    % If one is negative, use the positive solution
    if prod(Rs) < 0
        Rs = Rs(Rs > 0);
        pos = 1/2*Swstar*(delta - 2*Rs(1)*d) + referenceLoc;
    else % Use range which minimize the error
        xs1 = 1/2*Swstar*(delta - 2*Rs(1)*d);
        xs2 = 1/2*Swstar*(delta - 2*Rs(2)*d);
        e1 = norm(delta - 2*Rs(1)*d - 2*S*xs1);
        e2 = norm(delta - 2*Rs(2)*d - 2*S*xs2);
        if e1  > e2
            pos = xs2 + referenceLoc;
        else
            pos = xs1 + referenceLoc;
        end
    end
    
    % If required, compute the uncertainty in the position
    if nargout > 1 || reportDetection
        posCov = helperCalcPositionCovariance(pos,tdoaDets,timeScale,emissionSpeed);
    end
    
    if reportDetection
        varargout{1} = objectDetection(tdoaDets{1}.Time,pos,'MeasurementNoise',posCov);
    else
        varargout{1} = pos;
        if nargout > 1
            varargout{2} = posCov;
        end
    end
    
end
