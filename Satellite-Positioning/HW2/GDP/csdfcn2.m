function [okpat,nsats,mat] = csdfcn2(Z,lamda,nostop,tolm)
 %% 衛星觀測量週波脫落偵測副函式(Cycle slip detection function)
% Syntax
%   [okpat,nsats,mat] = csdfcn2(Z,lamda,nostop,tolm)
%                      or 
%   [okpat,nsats] = csdfcn2(Z,lamda,nostop,tolm)
%
% Input
%   Z      = Carrier-PHase and Pseudo-Range at one session
%   lamda  = Wavelength of observation.
%   nostop = minimum epochs of continuity.
%   tolm   = threshold of cycle slip in meter.
%
% Output
%   okpat = Cycle slip pattern.
%   nsats = total number of satellite.
%   mat   = Cycle slip pattern.(without continuity detection)
% 

if nargin < 4,error('insufficient number of input arguments'),end

[ns,epochs] = size(Z.PHASE{1});
ok = zeros(ns,epochs,2);
mat = zeros(ns,epochs);
ifirst = zeros(ns,1); ilast = zeros(ns,1);

% 週波脫落偵測
for sta = 1:2,
    for i = 1:ns,
        if any(Z.PHASE{sta}(i,:))==0,continue,end
        ifirst(i) = find(Z.PHASE{sta}(i,:),1,'first');
        ilast(i) = find(Z.PHASE{sta}(i,:),1,'last');
        m = 0; p = 0;
        ok(i,ifirst(i),sta) = 1;
        for j = (ifirst(i)+1):(ilast(i)-m),
            k = j + m;
            if k > ilast(i),break,end
            if ((ilast(i)-m)-(ifirst(i)+1))<0,continue,end
            if (Z.CODE{sta}(i,k)==0) || (Z.PHASE{sta}(i,k)==0),
                m = m + 1;
                p = p + 1; continue
            end
            if (Z.CODE{sta}(i,k-1)==0) || (Z.PHASE{sta}(i,k-1)==0),
                p = p + 1; continue
            end
            dc = Z.CODE{sta}(i,k) - Z.CODE{sta}(i,k-1);
            dpm = ( Z.PHASE{sta}(i,k) - Z.PHASE{sta}(i,k-1) )*lamda;
            if p > 0, ok(i,k-1,sta)=1; p=0;end
            if (abs(dc-dpm) < tolm),
                ok(i,k,sta) = 1;
            else
                ok(i,k,sta) = 2;  % Cycle Slip
            end
        end % epochs loop
    end % ns loop
end % station loop

% 兩測站週波脫落偵測結果
mat(:,:) = ok(:,:,1).*ok(:,:,2);
subpos = ismember(mat,4);
mat(subpos) = 2;
save MM mat ok
% 刪除兩週波脫落間觀測量少於nostop之筆數
for i = 1:ns, % 第 i 顆衛星
    if any(mat(i,:))==0,continue,end
    index = find(mat(i,:)==2);  % =2代表週波脫落
    if any(index),
        nslp = length(index);
        s2 = index(1);
        % section 1
        if s2 < nostop,
            mat(i,1:s2-1) = 0;
            mat(i,s2) = 1;
        else
            xx = find(mat(i,1:s2)==0,1,'last');
            if any(xx) && (s2-xx-1) < nostop,  % 1...012 --> 1...001
                mat(i,xx:s2-1) = 0;
                mat(i,s2) = 1;
            end
        end
        % section 2
        for j = 2:nslp,
            a = index(j-1); b = index(j);
            if (b-a) < nostop,             % 21112 --> 00001
                mat(i,a:b-1) = 0;
                mat(i,b) = 1;
            else
                yy = find(mat(i,a:b)==0);
                if any(yy),
                    c = yy(1);
                    d = yy(end);
                    if (c-1) < nostop,     % 210...2 --> 000...2
                        mat(i,a:a+c-2) = 0;
                    end
                    if (b-a-d) < nostop,   % 2...012 --> 2...001
                        mat(i,a+d:b-1) = 0;
                        mat(i,b) = 1;
                    end
                end
            end
        end % j=2:nslp
        % section 3
        e2 = index(nslp);
        if (epochs-e2+1) < nostop,
            mat(i,e2:end) = 0;
        else
            zz = find(mat(i,e2:end)==0,1,'first');
            if any(zz) && ((zz-1) < nostop),   % 210...1 --> 000...1
                mat(i,e2:e2+zz-2) = 0;
            end
        end
    end
end

% 偵測連續觀測量
save MM2 mat
okpat = continuity(mat,nostop);
% okpat = mat;

% 計算每筆衛星顆數
temp = okpat;
temp(ismember(temp,2)) = 1;
nsats = sum(temp,1);

