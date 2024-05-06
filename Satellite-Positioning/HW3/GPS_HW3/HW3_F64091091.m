clc;
clear all; 
close all;
%% ----- make new folder ----- %%
[status, msg, msgID] = mkdir('picture');

%% ----- import data ----- %%
load('CN11toCK01.mat');                                                % �ۦ��JInput�ɦW
refxyz = [-2956512.954, 5076009.984, 2476577.501];                     % �ۦ��J�Ѧү��w���y�Э�(X,Y,Z)
usrxyz = [-2956584.492, 5075878.999, 2476667.613];                     % �ۦ��J�ݴ����w���y�Э�(X,Y,Z)(�����w��~�t��)
ref_ant_h = 0.000;                                                     % �ۦ��J�Ѧү��ѽu��
usr_ant_h = 1.700;                                                     % �ۦ��J�ݴ����ѽu��

refplh = xyz2llh(refxyz);
refplh(3) = refplh(3) + ref_ant_h;
refxyz = llh2xyz(refplh);
usrplh = xyz2llh(usrxyz);
usrplh(3) = usrplh(3) + usr_ant_h;
usrxyz = llh2xyz(usrplh);

%% ----- differential positioning ----- %%
disp(' Performing Differential Positioning ... ');
for ep = 1: size(La{1,1}.NSAT(:))
   if La{1, 1}.NSAT(ep) >= 4
       n = La{1,1}.NSAT(ep);                                           % n=�ìP����
       for u = 1: n
           prn = La{1,1}.IDMAT(ep,u+2);
           svenu = xyz2enu(La{1, 1}.SVMAT(u, :, ep)-usrxyz, usrplh);
           el(prn) = (180/pi)*atan(svenu(3)/norm(svenu(1:2)));
           obs(u,:) = [La{1,1}.CODE(u, 1, ep), La{1, 1}.CODE(u, 2, ep)];
           svids(u,:) = [prn,prn];
       end             
       [ddPR, ddprns] = build2d(n, svids, obs, el);                    % ddPR=�G���t���q�X�[���qPkl_12(�V�q)
       clear svmat drho newo;
       for v = 1: length(ddprns)
           prn = ddprns(v);
           if v == 1
               rhok1 = norm(La{1, 1}.SVMAT(v, :, ep) - refxyz);        % �D�n�ìP�P�Ѧү����Z��
               svmat(1, :) = La{1, 1}.SVMAT(v, :, ep);
           else
               rhol1 = norm(La{1, 1}.SVMAT(v, :, ep) - refxyz);        % ���n�ìP�P�Ѧү����Z��
               drho(v-1) = rhok1 - rhol1;                              % �H�W��ضZ�����t��(�V�q)
               svmat(v, :) = La{1, 1}.SVMAT(v, :, ep);
           end
       end
       
       if length(ddPR) >= 3
           estusr = usrxyz;
           m = length(ddPR);                                           % m=�G���t���q�X�[���q���Ӽ�
           svref = svmat(1, :);                                        % �D�n�ìP�y��
           svdif = svmat(2: end, :);                                   % ���n�ìP�y��
           maxiter = 10;
           iter = 0;
           clear A P y;      
           D = [ones(m, 1), -1*diag(ones(1, m)), -1*ones(m, 1), diag(ones(1, m))];
           P = inv(D*D');                                              % �p���v�x�}P(m by m) (�`�N�ݭn�g�L�~�t�Ǽ�)
           while (iter < maxiter && (iter == 0 || norm(x) > 1e-3))
                for u = 1:m  
                    dk0 = svref(1, :) - estusr;                        % �ݴ����_�l�ȦܥD�n�ìP���V�q
                    dl0 = svdif(u, :) - estusr;                        % �ݴ����_�l�Ȧܦ��n�ìP���V�q             
                    rhok0 = norm(dk0);                                 % �ݴ����_�l�ȦܥD�n�ìP���Z��
                    rhol0 = norm(dl0);                                 % �ݴ����_�l�Ȧܦ��n�ìP���Z��
                    O = ddPR(u) - drho(u);                             % O=Okl_12
                    y(u,1) = O - (-rhok0+rhol0);                       % �[�J�@�Ӥ������[���q�V�qy
                    A(u,:) = [dk0/rhok0 - dl0/rhol0];                  % �[�J�@�C�����ܳ]�p�x�}A  
                end
                x = inv(A'*P*A)*A'*P*y;                                % Least-squares�p��ݴ����_�l�Ȫ��勵�q
                estusr = estusr + x';                                  % ��s�ݴ����y��   
                iter = iter + 1;
           end
       end
       enuerr(ep, :) = xyz2enu(estusr(1: 3)-usrxyz, usrplh);           % �p��w��~�t����ܦa���y�Шt��
   end
end

%% ----- calculate precision and RMS ----- %%
de = norm(enuerr(:, 1));                                               % E��V�w��~�t
dn = norm(enuerr(:, 2));                                               % N��V�w��~�t                
dh = norm(enuerr(:, 3));                                               % Height��V�w��~�t          
meanE = sum(enuerr(:, 1))/ep;
RESE = enuerr(:, 1)-meanE;
standardE = ((RESE'*RESE)/(ep-1))^0.5;
rmse = sqrt(de*de/ep);

meanN = sum(enuerr(:, 2))/ep;
RESN = enuerr(:, 2)-meanN;
standardN = ((RESN'*RESN)/(ep-1))^0.5;
rmsn = sqrt(dn*dn/ep);

meanH = sum(enuerr(:, 3))/ep;
RESH = enuerr(:, 3)-meanH;
standardH = ((RESH'*RESH)/(ep-1))^0.5;
rmsu = sqrt(dh*dh/ep);

%% ----- output txt ----- %%
file = fopen('CN11toCK01_output.txt', 'w');
fprintf(file, '%%%% ----- Differential Positioning Summary ----- %%%%\n\n');
fprintf(file, 'meanE = %6.6f, standardE = %6.6f, rmse = %6.6f\n', meanE, standardE, rmse);
fprintf(file, 'meanN = %6.6f, standardN = %6.6f, rmsn = %6.6f\n', meanN, standardN, rmsn);
fprintf(file, 'meanH = %6.6f, standardH = %6.6f, rmsu = %6.6f\n\n', meanH, standardH, rmsu);

fprintf(file, '2D error = %6.6f(m), 3D error = %6.6f(m)\n', sqrt(rmse^2+rmsn^2), sqrt(rmse^2+rmsn^2+rmsu^2));

%% ----- make plot ----- %%
figure(1);
subplot(2, 2, 1);
plot(enuerr(:, 1), enuerr(:, 2), '*'), grid;
axis('square');
axis('equal');
axis([-2 2 -2 2]);
title(' DGPS Positioning Error ');
ylabel('dn (m)');
xlabel('de (m)');

subplot(2, 2, 2);
plot(1: ep, enuerr(:, 3), '*'), grid;
axis([1 ep -5 5]);
title(' DGPS Positioning Error');
ylabel('du (m)');
xlabel('epochs');

subplot(2, 2, 3);
plot(1: ep, enuerr(:, 1), '*'), grid;
axis([1 ep -2 2]);
title(' DGPS Positioning Error');
ylabel('de (m)');
xlabel('epochs');

subplot(2, 2, 4);
plot(1: ep, enuerr(:, 2), '*'), grid;
axis([1 ep -2 2 ]);
title(' DGPS Positioning Error');
ylabel('dn (m)');
xlabel('epochs');

%% ----- save plot ----- %%
saveas(gcf, './picture//DGPS_Positioning_Error.png');

disp(' End of Differential Positioning ... ');