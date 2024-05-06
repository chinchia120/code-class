function result = repNaN(NaNmat,value)

% Find & replace NaN or zero with value ie. 999999.999999
% 
% %%%%%%%%%% HELP %%%%%%%%%%
% 
% result = repNaN(NaNmat,value)
% 
% Input Data
% NaNmat = matrix filled with NaN
% value = value to replace
% 
% Output Data
% result = matrix without NaN
% 
% Written by  Phakphong Homniam


%%%%%%%%%% BEGIN %%%%%%%%%%

find_NaN = isnan(NaNmat);

index = find(find_NaN == 1);
NaNmat(index) = value;

indexzero = find(NaNmat == 0)
NaNmat(indexzero) = value;

%%%%%%%% RESULT %%%%%%%

result = NaNmat;

fprintf('Replacing NaN or zero with %f.\n',value);

%%%%%%%%%% END %%%%%%%%%%

