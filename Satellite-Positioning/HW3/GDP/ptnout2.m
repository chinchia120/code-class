function out = ptnout2(obs,pattern)
% Syntax
%   out = ptnout2(observation,pattern)
%
% Input
%   obs     = Carrier-phase or Pseudorange observation.(maxid,epochs)
%   pattern = OK pattern.(ns,epochs)
%             where ns = num. of satelltes, epochs = num. of observations.
%
% Output
%   out = Observation matrix.(25,1,epochs)
%

epochs = size(pattern,2);
out = zeros(25,2,epochs);
% out2 = zeros(25,1,epochs);

obs1 = obs{1};
obs2 = obs{2};
for i = 1:epochs,
%     clear prn1 prn2
%     prn1 = prns(pattern(:,i)~=0);
    dnx = find(pattern(:,i));
    nd = length(dnx);
    if nd
        out(1:nd,1,i) = obs1(dnx,i);
        out(1:nd,2,i) = obs2(dnx,i);
    end
%     prn2 = prns(pattern(:,i)~=0);
%     np = length(prn2);
%     if np
%     end
end
