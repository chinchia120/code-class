function [out,slog] = continuity(mat,nostop,tol)
% 觀測量連續性之編修
% Syntax
%   out = continuity(mat,nostop)
%
% Input 
%   mat = information matrix after cycle slip detection.(ns,epochs)
%   nostop = minimum epochs of continuity.
%   tol = threshold.
%
% Output
%   out = output matrix.(ns,epochs)
%         where ns = num. of satelltes, epochs = num. of observations.
%

if nargin<3, tol=0; end

[ns,epochs] = size(mat);
out = zeros(ns,epochs);
slog = [];
% 刪除存在連續觀測量 < nostop 之筆數
for i = 1:ns,
    if any(mat(i,:))==0,continue,end
    clear ds de
    dndx = find(mat(i,:)<=tol & mat(i,:) > 0);
    if any(dndx), mat(i,dndx) = 0; end
    index = find(mat(i,:)>tol);  % 矩陣mat可能存在非1數值(週波脫落)
    n = length(index);
    di = zeros(1,n); dii = zeros(1,n);
    for j = 2:n,
        di(j) = index(j) - index(j-1);
        dii(j-1) = index(j) - index(j-1);
    end
    ds = find(di~=1);   % 起始筆數
    de = find(dii~=1);  % 結束筆數
    ks = 0;
    for k = 1:length(ds),
        a = index(ds(k)); b = index(de(k));
        if (b-a+1) < nostop,
            mat(i,a:b) = 0;
        else
            ks = ks + 1;
            slog(ks,:) = [a,b];
        end
    end
end
out(:,:) = mat;

%% 刪除存在連續觀測量 < nostop 之筆數
% for i = 1:ns,
%     if any(mat(i,:))==0,continue,end
%     index = find(mat(i,:)>tol);  % 矩陣mat可能存在非1數值(週波脫落)
%     n = length(index);
%     cnt = 1; 
%     depo(cnt) = index(1);
%     k = index(1);  % first epoch
%     for j = 2:n,
%         k = k + 1;
%         if index(j)==k,
%             cnt = cnt + 1;
%             depo(cnt) = index(j);
%         else
%             if cnt < nostop, mat(i,depo) = 0; end
%             clear depo
%             cnt = 1;
%             depo(cnt) = index(j);
%             k = index(j);
%         end
%         if (j == n) && (cnt < nostop),
%             mat(i,depo) = 0;
%         end
%     end
% end
% out(:,:) = mat;

