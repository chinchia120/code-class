%%INPUTS:
% m(1) = length  (along strike)
% m(2) = width (down-dip)
% m(3) = depth to down-dip edge (positive value)
% m(4) = dip (degrees)
% m(5) = strike (degrees)
% m(6) = east position of center of down-dip edge
% m(7) = north position of center of down-dip edge
% m(8) = strike-slip (units can be anything -- units of
%        output displacements will be same as slip input units since output
%        displacements scale linearly with slip)
% m(9) = dip-slip 
% m(10) = tensile
% x = 3xn matrix of observation coordinates -- first row x (east), second row y (north),
% third row z (vertical, below surface z is negative)
% mu = shear modulus (only important for stresses -- does not influence displacements)
% nu = Poisson's ratio
%%OUTPUTS:
%U is a 3xn matrix of displacements (first row - east, second row - north, third row - vertical) 
