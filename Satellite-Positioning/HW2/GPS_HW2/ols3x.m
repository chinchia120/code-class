function estusr = ols3x(obsvec,svpos,initpos,tol)
%
%	estusr = ols3x(obsvec,svpos,initpos,tol)
% ======================================================================
%   PURPOSE :
%	Compute position from satellite positions and ranges
%   via ordinary least squares.
% ======================================================================
%   PARAMETER  I/O    DESCRIPTION
% ----------------------------------------------------------------------
%   obsvec      I   - measurement array for O-c.
%   svpos(i,:)  I   - cartesian coordinate of satellite i,
%                     in user defined cartesian coordinates.
%                     svpos(1,:) for reference satellite
%   initpos     I   - optional argument with default value = 0.
%                     Initial 'estimate' user x, y, and z coordinates.
%   tol         I   - optional argument with default value = 1e-3.
%                     tolerance value used to determine
%                     convergence of iterative solution.
%   estusr      O   - estimated user x, y, and z coordinates.
% ======================================================================
%   NOTE :
%   all three elements of estusr are in the same units as 
%   those used in range.
% ======================================================================
%	Copyright (c) 2006 by yaoyun
%	All Rights Reserved.
%
if nargin < 4, tol = 1e-3; end
if nargin < 3, initpos = [0 0 0]; end
if nargin < 2, error('insufficient number of input arguments'), end
[m,n] = size(initpos);
if m > n, estusr = initpos'; else, estusr = initpos; end
if length(estusr) < 3,
   error('must define at least 3 dimensions in initpos')
end
nd = length(obsvec);
svref = svpos(1,:);
svdif = svpos(2:end,:);
ddr=[1 1 1];
maxiter=10;
iter=0;
while ((iter < maxiter) & (norm(ddr) > tol)),
    for u = 1:nd,
        dk = svref(1,:) - estusr;
        dl = svdif(u,:) - estusr;
   	    rk0 = norm(dk);
   	    rl0 = norm(dl);
        A(u,:) = [-(dl./rl0-dk./rk0)];
	    L(u,1) = obsvec(u) - (rl0 - rk0);
    end,
    ddr = A\L;
    estusr = estusr + ddr';
    iter = iter + 1;
end

