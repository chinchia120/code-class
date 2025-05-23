function [X,resnorm,residual,exitflag,output,lambda]=lsqlin(C,d,A,b,Aeq,beq,lb,ub,X0,options,varargin)
%LSQLIN Constrained linear least squares.
%   X=LSQLIN(C,d,A,b) solves the least-squares problem
%
%           min  0.5*(NORM(C*x-d)).^2       subject to    A*x <= b
%            x
%
%   where C is m-by-n.
%
%   X=LSQLIN(C,d,A,b,Aeq,beq) solves the least-squares
%   (with equality constraints) problem:
%
%           min  0.5*(NORM(C*x-d)).^2    subject to 
%            x                               A*x <= b and Aeq*x = beq
%
%   X=LSQLIN(C,d,A,b,Aeq,beq,LB,UB) defines a set of lower and upper
%   bounds on the design variables, X, so that the solution  
%   is in the range LB <= X <= UB. Use empty matrices for 
%   LB and UB if no bounds exist. Set LB(i) = -Inf if X(i) is unbounded 
%   below; set UB(i) = Inf if X(i) is unbounded above.
%
%   X=LSQLIN(C,d,A,b,Aeq,beq,LB,UB,X0) sets the starting point to X0.
%
%   X=LSQLIN(C,d,A,b,Aeq,beq,LB,UB,X0,OPTIONS) minimizes with the default 
%   optimization parameters replaced by values in the structure OPTIONS, an 
%   argument created with the OPTIMSET function.  See OPTIMSET for details. 
%   Used options are Display, Diagnostics, TolFun, LargeScale, MaxIter, 
%   JacobMult, PrecondBandWidth, TypicalX, TolPCG, and MaxPCGIter. Currently, only
%   'final' and 'off' are valid values for the parameter Display ('iter'
%   is not available).
%
%   X=LSQLIN(C,d,A,b,Aeq,beq,LB,UB,X0,OPTIONS,P1,P2,...) passes the 
%   problem-dependent parameters P1,P2,... directly to the JMFUN function
%   when OPTIMSET('JacobMult',JMFUN) is set. JMFUN is provided by the user. 
%   Pass empty matrices for A, b, Aeq, beq, LB, UB, XO, OPTIONS, to use the 
%   default values.
%
%   [X,RESNORM]=LSQLIN(C,d,A,b) returns the value of the squared 2-norm of the
%   residual: norm(C*X-d)^2.
%
%   [X,RESNORM,RESIDUAL]=LSQLIN(C,d,A,b) returns the residual: C*X-d.
%
%   [X,RESNORM,RESIDUAL,EXITFLAG] = LSQLIN(C,d,A,b) returns an EXITFLAG that 
%   describes the exit condition of LSQLIN.  
%   If EXITFLAG is:
%      > 0 then LSQLIN converged with a solution X.
%      0   then the maximum number of iterations was exceeded (only occurs
%           with large-scale method).
%      < 0 then the problem is unbounded, infeasible, or 
%           LSQLIN failed to converge with a solution X. 
%
%   [X,RESNORM,RESIDUAL,EXITFLAG,OUTPUT] = LSQLIN(C,d,A,b) returns a structure
%   OUTPUT with the number of iterations taken in OUTPUT.iterations,
%   the type of algorithm used in OUTPUT.algorithm, the number of conjugate
%   gradient iterations (if used) in OUTPUT.cgiterations, and a measure of
%   first order optimality (if used) in OUPUT.firstorderopt.
%
%   [x,RESNORM,RESIDUAL,EXITFLAG,OUTPUT,LAMBDA]=LSQLIN(C,d,A,b) returns the 
%   set of Lagrangian multipliers LAMBDA, at the solution: LAMBDA.ineqlin 
%   for the linear inequalities C, LAMBDA.eqlin for the linear equalities Ceq, 
%   LAMBDA.lower for LB, and LAMBDA.upper for UB.

%   Copyright 1990-2001 The MathWorks, Inc. 
%   $Revision: 1.26 $  $Date: 2001/04/05 00:21:48 $
%   Mary Ann Branch 9-30-96.

defaultopt = struct('Display','final','Diagnostics','off',...
   'TolFun',100*eps,...
   'LargeScale','on','MaxIter',200,...
   'JacobMult',[],... % empty by default
   'PrecondBandWidth',0,'TypicalX','ones(numberOfVariables,1)',...
   'TolPCG',0.1,'MaxPCGIter','max(1,floor(numberOfVariables/2))');

% If just 'defaults' passed in, return the default options in X
if nargin==1 & nargout <= 1 & isequal(C,'defaults')
   X = defaultopt;
   return
end

if nargin < 2, error('LSQLIN requires two input arguments');end

% Handle missing arguments
if nargin < 10, options = [];
   if nargin < 9, X0 = []; 
      if nargin < 8, ub=[]; 
         if nargin < 7, lb = []; 
            if nargin < 6, beq =[]; 
               if nargin < 5, Aeq = [];
                  if nargin < 4, b = [];
                     if nargin < 3, A = [];
                     end, end, end, end, end, end, end, end
% Set up constant strings
medium =  'medium-scale: active-set';
large = 'large-scale: trust-region reflective Newton'; 
unconstrained = 'slash';

if nargout > 5
   computeLambda = 1;
else 
   computeLambda = 0;
end
% Options setup
largescale = isequal(optimget(options,'LargeScale',defaultopt,'fast'),'on');
diagnostics = isequal(optimget(options,'Diagnostics',defaultopt,'fast'),'on');
mtxmpy = optimget(options,'JacobMult',defaultopt,'fast');
if isequal(mtxmpy,'atamult')
   warnstr = sprintf('%s\n%s\n%s\n', ...
      'Potential function name clash with a Toolbox helper function:',...
      'Use a name besides ''atamult'' for your JacobMult function to',...
      'avoid errors or unexpected results.');
   warning(warnstr)
end
switch optimget(options,'Display',defaultopt,'fast')
case {'off','none'}
   verbosity = 0;
case 'iter'
   verbosity = 2;
case 'final'
   verbosity = 1;
otherwise
   verbosity = 1;
end

% Set the constraints up: defaults and check size
[nineqcstr,numberOfVariables]=size(A);
[neqcstr,numberOfVariableseq]=size(Aeq);
ncstr = nineqcstr + neqcstr;

if isempty(C) | isempty(d)
   error('The first two arguments to LSQLIN cannot be empty matrices.')
else
   numberOfVariables = max([size(C,2),numberOfVariables]); % In case C is empty
end

[rows,cols]=size(C);
if length(d) ~= rows
   error('The number of rows in C must be equal to the length of d.');
end

if length(b) ~= size(A,1)
   error('The number of rows in A must be equal to the length of b.');
end

if isempty(X0), X0=zeros(numberOfVariables,1); end
if isempty(A), A=zeros(0,numberOfVariables); end
if isempty(b), b=zeros(0,1); end
if isempty(Aeq), Aeq=zeros(0,numberOfVariables); end
if isempty(beq), beq=zeros(0,1); end


% Set d, b and X to be column vectors
d = d(:);
b = b(:);
beq = beq(:);
X0 = X0(:);

[X0,lb,ub,msg] = checkbounds(X0,lb,ub,numberOfVariables);
if ~isempty(msg)
   exitflag = -1;
   [resnorm,residual,exitflag,output,lambda]=deal([]);
   X=X0; 
   if verbosity > 0
      disp(msg)
   end
   return
end

% Test if C is all zeros or empty
if  norm(C,'inf')==0 | isempty(C)
   C=0; 
end

caller = 'lsqlin';

% Test for constraints
if isempty([Aeq;A]) & isempty([beq;b]) & all(isinf([lb;ub]))
    output.algorithm = unconstrained;
    % If interior-point chosen and no A,Aeq and C isn't short and fat, then call sllsbox   
elseif largescale & (isempty([A;Aeq])) & (rows >= cols)
    output.algorithm = large;
else
    if largescale 
        if (rows < cols)
            warnstr = sprintf('%s\n%s\n', ...
                'Large-scale method requires at least as many equations as variables ',...
                '    in C matrix; switching to medium-scale method.');
        else % ~isempty([A;Aeq]))
            warnstr = sprintf('%s\n%s\n', ...
                'Large-scale method can handle bound constraints only; ',...
                '    switching to medium-scale method.');
        end
        warning(warnstr);
    end
    output.algorithm = medium;
end


if diagnostics > 0
   % Do diagnostics on information so far
   gradflag = []; hessflag = []; line_search=[];
   constflag = 0; gradconstflag = 0; non_eq=0;non_ineq=0;
   lin_eq=size(Aeq,1); lin_ineq=size(A,1); XOUT=ones(numberOfVariables,1);
   funfcn{1} = [];ff=[]; GRAD=[];HESS=[];
   confcn{1}=[];c=[];ceq=[];cGRAD=[];ceqGRAD=[];
   msg = diagnose('lsqlin',output,gradflag,hessflag,constflag,gradconstflag,...
      line_search,options,defaultopt,XOUT,non_eq,...
      non_ineq,lin_eq,lin_ineq,lb,ub,funfcn,confcn,ff,GRAD,HESS,c,ceq,cGRAD,ceqGRAD);
end


switch output.algorithm;
case 'slash'
   X = C\d;
   residual = C*X-d;
   resnorm = sum(residual.*residual);
   lambda = [];
   exitflag = 1;
   output.iterations = 0;
   output.algorithm = unconstrained;
case 'large-scale: trust-region reflective Newton'; 
   [X,resnorm,residual,output.firstorderopt,output.iterations,output.cgiterations,ex,lambda]=...
      sllsbox(C,d,lb,ub,X0,verbosity,options,defaultopt,varargin{:});
   output.algorithm = large;
   
   if ex == 4
      exitflag = 0;
   elseif ex == 5
      exitflag = -1;
   elseif ex > 0
      exitflag = 1;
   else
      exitflag = -1;
   end
case 'medium-scale: active-set'
   if largescale & ( issparse(A) | issparse(C) | issparse(Aeq) )% asked for sparse
      warnstr = sprintf('%s\n%s\n', ...
         'This problem formulation not yet available for sparse matrices.',...
         'Converting to full to solve.');
      warning(warnstr);
   end
   [X,lambdaqp,exitflag,output]= ...
      qpsub(full(C),d,[full(Aeq);full(A)],[beq;b],lb,ub,X0,neqcstr,verbosity,caller,ncstr,numberOfVariables,options,defaultopt);
   output.algorithm = medium;  
   residual = C*X-d;
   resnorm = sum(residual.*residual);
   if verbosity > 0 & isequal(output.algorithm,medium)
      if ( exitflag==0 | exitflag ==1 )
         %disp('Optimization terminated successfully.');   
      end
      if ( exitflag == 2)
         % do some sort of check here to see how unreliable
         disp('Optimization completed.'); 
      end
   end
   
end

if isequal(output.algorithm , medium)
   llb = length(lb); 
   lub = length(ub);
   lambda.lower = zeros(llb,1);
   lambda.upper = zeros(lub,1);
   arglb = ~isinf(lb); lenarglb = nnz(arglb);
   argub = ~isinf(ub); lenargub = nnz(argub);
   lambda.eqlin = lambdaqp(1:neqcstr,1);
   lambda.ineqlin = lambdaqp(neqcstr+1:neqcstr+nineqcstr,1);
   lambda.lower(arglb) = lambdaqp(neqcstr+nineqcstr+1:neqcstr+nineqcstr+lenarglb);
   lambda.upper(argub) = lambdaqp(neqcstr+nineqcstr+lenarglb+1:neqcstr+nineqcstr+lenarglb+lenargub);
   output.firstorderopt=[];
   output.cgiterations =[];
elseif isequal(output.algorithm,'slash')
   lambda.lower = [];
   lambda.upper = [];
   lambda.ineqlin = [];
   lambda.eqlin = [];
   output.firstorderopt=[];
   output.cgiterations =[];
end
