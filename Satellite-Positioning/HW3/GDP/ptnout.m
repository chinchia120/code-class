function [sat,csd,nsat] = ptnout(prns,tow,pattern)
% Syntax
%   [sat,csd,nsat] = ptnout(prns,tow,pattern)
%
% Input
%   prns    = PRN number vector.
%   tow     = GPS time of week in second
%   pattern = OK pattern.(ns,epochs)
%             where ns = num. of satelltes, epochs = num. of observations.
%
% Output
%   sat  = Satellites information matrix.(epochs,27)
%   csd  = Cycle slip information matrix.(epochs,27)
%   nsat = Number of satellite.(1,epochs)
%

epochs = length(tow);
sat  = zeros(epochs,27);
csd  = zeros(epochs,27);
nsat = zeros(1,epochs);

csd(:,1:2) = [tow;tow]';
for i = 1:epochs,
    % 輸出週波脫落資訊
%     clear prn1 prn2
    prn1 = prns(pattern(:,i)==2);
    np = length(prn1);
    if np,
        csd(i,2:np+2) = [(tow(i)+tow(i-1))/2,prn1'];
    end
    % 輸出衛星資訊
    sat(i,1:2) = csd(i,1:2);
    prn2 = prns(pattern(:,i)~=0);
    nsat(i) = length(prn2);
    if nsat(i),
        sat(i,3:nsat(i)+2) = prn2(:);
    end
end

