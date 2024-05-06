clear all;
clc;

%% ------------- ���J�[���ɤξɯ��� --------------- %%
disp(' Loading Data ... ');
load('CK01_out.mat');                                                           % ��J�ɦW

%% ------------------ ��l�Ƴ]�w ------------------- %%
c = 299792458;
usrxyz = [-2956584.492, 5075878.999, 2476667.613];                              % �ۦ��J�w���I�y��(X,Y,X)
ant_h = 1.700;                                                                  % �ۦ��J�ѽu��(m)
usrplh = xyz2llh(usrxyz);                                                       % ��(X,Y,Z)���(Lat,Lon,ht)
usrplh(3) = usrplh(3) + ant_h;                                                  % �N�w���I�y�в��ܤѽu�ۦ줤��
usrxyz = llh2xyz(usrplh);                                                       % ��(Lat,Lon,ht)���(X,Y,Z)

%% ----------------- ���I�w�� ---------------------- %%
disp(' Calculating Position... ');
aEpoch = size(La{1, 1}.NSAT, 2);
for i = 1: aEpoch                                                               % i=1:�̫�@��epoch(�Y���[�������`��)
    delta = [1e-6 1e-6 1e-6 1e-6];                                              % �����ƼW�q��l��
    estusr = [usrxyz 0];                                                        % �w���I�y�лP�����������~�t�_�l��
    maxiter = 10;                                                               % �̤j���N����
    iter = 0;
    clear A y    
    while ((iter < maxiter) && (norm(delta) > 1e-6)),
        for N = 1: La{1, 1}.NSAT(i),                                            % La{1,1}.NSAT(i)����i�Ӯɨ誺�ìP����
            prn = La{1, 1}.IDMAT(i, N+2);                                       % �ìP�s��
            svxyzmat(N, :) = La{1, 1}.SVMAT(N, :, i)                            % �ìP���a�ߦa�T(ECEF)�y��
            Pr  = La{1, 1}.CODE(N, 1, i) + satclkcorr(prn, i);                  % �ìP�ɿ��~�t�勵: Pr=P-cdt
            dxyz = svxyzmat(N, :) - estusr(1: 3);                               % �����ܽìP��ECEF�y�ЦV�q(dx,dy,dz)
            rho0  = norm(dxyz);                                                 % �����ܽìP���Z��
            cxyz = dxyz./rho0;                                                  % �����ܽìP�����V�q
            A(N, :) = [-cxyz, -1];                                              % ���ͳ]�p�x�}A
            y(N, 1) = Pr - (rho0 - estusr(4));                                  % �����[���q�V�qy=Pr-(rho0-cdT)
        end 
        delta = inv(A.'*A)*A.'*y;                                               % Least-squares�p�⥼���ѼƧ勵�q
        estusr = estusr + delta;                                                % ��s�����Ѽ�(�����y�лP�����������~�t)   
        iter = iter + 1;
    end
    Q = inv(A'*A);                                                              % �p��N^-1�x�}
    GDOP(i) = sqrt(Q(1, 1) + Q(2, 2) + Q(3, 3) + Q(4, 4));
    PDOP(i) = sqrt(Q(1, 1) + Q(2, 2) + Q(3, 3));
    TDOP(i) = sqrt(Q(4, 4));
    tllh = xyz2llh(estusr(1: 3));                                               % �w���I�y�Х�(X,Y,Z)���(Lat,Lon,ht)
    R = [-sin(tllh(2)), cos(tllh(2)), 0; 
         -sin(tllh(1))*cos(tllh(2)), -sin(tllh(1))*sin(tllh(2)), cos(tllh(1)); 
         cos(tllh(1))*cos(tllh(2)), cos(tllh(1))*sin(tllh(2)), sin(tllh(1))];   % �����ഫ�x�}R
    QENU = R*Q(1: 3, 1: 3)*R.';
    HDOP(i) = sqrt(QENU(1, 1) + QENU(2, 2));
    VDOP(i) = sqrt(QENU(3, 3));
    enuerr(i,:) = xyz2enu(estusr(1: 3)-usrxyz, usrplh);                         % �p��w��~�t����ܦa���y�Шt
end

%% ---------- �w��~�t���� : ����ڻ~�t(RMSE) ------ %%
de = norm(enuerr(:, 1));                                                        % E��V�w��~�t
dn = norm(enuerr(:, 2));                                                        % N��V�w��~�t
dh = norm(enuerr(:, 3));                                                        % Height��V�w��~�t
%===E====%
meanE = sum(enuerr(:, 1))/i;
RESE = enuerr(:, 1) - meanE;
standardE = ((RESE'*RESE)/(i-1))^0.5;
rmse = sqrt(de*de/i);
%===N====%
meanN = sum(enuerr(:, 2))/i;
RESN = enuerr(:, 2)-meanN;
standardN = ((RESN'*RESN)/(i-1))^0.5;
rmsn = sqrt(dn*dn/i);
%===Height====%
meanH = sum(enuerr(:, 3))/i;
RESH = enuerr(:, 3)-meanH;
standardH = ((RESH'*RESH)/(i-1))^0.5;
rmsu = sqrt(dh*dh/i);

%% --------------- Output txt --------------- %%
file = fopen('CK01_output.txt', 'w');
fprintf(file, 'meanE = %9.6f, standardE =%9.6f, rmse = %9.6f\n', meanE, standardE, rmse);
fprintf(file, 'meanN = %9.6f, standardN =%9.6f, rmsn = %9.6f\n', meanN, standardN, rmsn);
fprintf(file, 'meanH = %9.6f, standardH =%9.6f, rmsu = %9.6f\n', meanH, standardH, rmsu);
fprintf(file, 'GDOP_avg = %5.4f\n', mean(GDOP));
fprintf(file, 'PDOP_avg = %5.4f\n', mean(PDOP));
fprintf(file, 'TDOP_avg = %5.4f\n', mean(TDOP));
fprintf(file, 'HDOP_avg = %5.4f\n', mean(HDOP));
fprintf(file, 'VDOP_avg = %5.4f\n', mean(VDOP));

%% ------------------ ø�� ------------------ %%
%ø(E,N)��V�~�t�� 
figure
subplot(2, 2, 1)
plot(enuerr(:, 1),enuerr(:, 2),'*'), grid
axis square ; axis equal
axis([-20 20 -20 20])
title('GPS Point Positioning Error')
ylabel('north error (m)')
xlabel('east error (m)')
grid on
%ø(Height,�ɶ�)�~�t��
subplot(2, 2, 2)
plot(1: aEpoch, enuerr(:, 3), '*'), grid
axis square
axis([0 aEpoch -30 30])
title('GPS Point Positioning Error')
ylabel('height error (m)')
xlabel('epoch')
grid on
%ø(E,�ɶ�)��V�~�t��
subplot(2, 2, 3)
plot(1: aEpoch, enuerr(:, 1), '*'), grid
axis square
axis([0 aEpoch -30 30])
title('GPS Point Positioning Error')
ylabel('east error (m)')
xlabel('epoch')
grid on
%ø(N,�ɶ�)��V�~�t��
subplot(2, 2, 4)
plot(1: aEpoch, enuerr(:, 2), '*'), grid
axis square
axis([0 aEpoch -30 30])
title('GPS Point Positioning Error')
ylabel('north error (m)')
xlabel('epoch')
grid on
%GDOPø��
figure
subplot(2, 3, 1)
plot(GDOP)
axis([0 aEpoch 0 10])
title('GDOP')
xlabel('epoch')
grid on
%PDOPø��
subplot(2, 3, 2)
plot(PDOP)
axis([0 aEpoch 0 10])
title('PDOP')
xlabel('epoch')
grid on
%TDOPø��
subplot(2, 3, 3)
plot(TDOP)
axis([0 aEpoch 0 10])
title('TDOP')
xlabel('epoch')
grid on
%HDOPø��
subplot(2, 3, 4)
plot(HDOP)
axis([0 aEpoch 0 10])
title('HDOP')
xlabel('epoch')
grid on
%VDOPø��
subplot(2, 3, 5)
plot(VDOP)
axis([0 aEpoch 0 10])
title('VDOP')
xlabel('epoch')
grid on
%% ----------------- end --------------------- %%
