clear;
clc;
%% ------------- make new folder ------------- %%
%[status, msg, msgID] = mkdir('picture');

%% ---------------- load data ---------------- %%
disp(' Loading Data ... ');
load('CK01_out.mat');                                                       % �ۦ��JInput�ɦW

%% -------------- initial value -------------- %%
c = 299792458;
f1 = 154*10.23e6;
f2 = 120*10.23e6;

%% --- ionosphere free linear combination ---- %%
a1 = 1 / (1-(f2^2)/(f1^2));
a2 = 1 - a1;

%% -------------- initial value -------------- %%
usrxyz = [-2956584.492, 5075878.999, 2476667.613];                          % �ۦ��J�I��w���y��(X,Y,Z)(�����w��~�t��)
ant_h = 1.700;                                                              % �ۦ��J�ѽu��(m)
usrplh = xyz2llh(usrxyz);                                                   % �N(X,Y,Z)�ର(lat,lon,ht)=(�n�סB�g�סB��y��)
usrplh(3) = usrplh(3) + ant_h;                                              % �N�I��y����ܤѽu�ۦ줤�߮y��
usrxyz = llh2xyz(usrplh);                                                   % �A�N(lat,lon,ht)�ର(X,Y,Z)

%% ------------ point positioning ------------ %%
disp(' Calculating Position... ');

aEpoch = size(La{1,1}.NSAT, 2);
for i = 1: aEpoch                                                           % for i=1:�̫�@��epoch(�Y���[�����Ƥ��`��)
    delta = [1e-6 1e-6 1e-6 1e-6];                                          % �����ƼW�q��l��
    estusr = [usrxyz 0];                                                    % �w���I�y�лP�����������~�t���_�l��
    maxiter = 10;                                                           % �̤j���N����
    iter = 0;
    clear A y;    
    if La{1,1}.NSAT(i) >= 4                                                 % �ìP���ƻݤj��ε���4���~����U�����j��
        while ((iter < maxiter) && (norm(delta) > 1e-6))             
            for N = 1: La{1,1}.NSAT(i)                                      % La{1,1}.NSAT(i)����i�Ӯɨ誺�ìP����
                prn = La{1,1}.IDMAT(i, N+2);                                % �ìPPRN�s��
                svxyzmat(N, :) = La{1,1}.SVMAT(N, :, i);                    % �ìP���a�ߦa�T(ECEF)�y��(dx,dy,dz)
                svenu = xyz2enu(svxyzmat(N, :)-usrxyz, usrplh);             % �p��ìP�۹�������a���y��(de,dn,du)
                el = (180/pi) * atan(svenu(3)/norm(svenu(1: 2)));           % �p��ìP�۹�����������
                Pr1 = La{1, 1}.CODE(N, 1, i) + satclkcorr(prn, i);          % �ìP�ɿ��~�t�勵: Pr1=P1-cdt
                Pr2 = La{1, 2}.CODE(N, 1, i) + satclkcorr(prn, i);          % �ìP�ɿ��~�t�勵: Pr2=P2-cdt

%% ---------- ionospheric modelling ---------- %%
                %Pr3 = a1*Pr1 + a2*Pr2;                                     % ��o�L�q���h�u�ʲզX(ion-free)�q�X�[���q

%% ---------- tropospheric effects ----------- %%
                tropd = mhopfld(el, usrplh(3)/1000, 1015.4, 24.4, 50, 40.8/1000, 40.8/1000, 40.8/1000);                                         
                Pr = Pr1 - tropd;                                           % ��o�勵��y�h����᪺�q�X�[���q
                               
                % el     [degree]     �[���ɨ誺�ìP����
                % hsta   [km]         �������{
                % p      [mbar]       �j�����O
                % tcel   [celsius]    �ū�
                % hum    [%]          ���
                % hp     [km]         �q�����O�B�����{
                % htkel  [km]         �q���ū׳B�����{
                % hhum   [km]         �q����׳B�����{   

                dxyz = svxyzmat(N,:) - estusr(1:3);                         % �����ܽìP��ECEF�y�ЦV�q(dx,dy,dz)
                rho0 = norm(dxyz);                                          % �����ܽìP���Z��
                cxyz = dxyz./rho0;                                          % �����ܽìP�����V�q

%% --- designed matrix and observed matrix --- %%
                A(N, :) = [-cxyz, -1];                                      % ���ͳ]�p�x�}A
                y(N, 1) = Pr - (rho0 - estusr(4));                          % �����[���q�V�q: y=Pr-(rho0-cdT)

            end

%% --------- calculate and iteration --------- %%
                delta = inv(A.'*A)*A.'*y;                                   % Least-squares�p�⥼���Ѽƪ��勵�q
                estusr = estusr + delta;                                    % ��s�����Ѽ�(�����y�лP�����������~�t)
                iter = iter + 1;
        end    

      Q = inv(A'*A);                                                        % �p��N^-1�x�}(�k�x�}���f�x�})

%% - calculate GDOP, PDOP, TDOP, HDOP, VDOP -- %%
      GDOP(i) = sqrt(Q(1, 1) + Q(2, 2) + Q(3, 3) + Q(4, 4));
      PDOP(i) = sqrt(Q(1, 1) + Q(2, 2) + Q(3, 3));
      TDOP(i) = sqrt(Q(4, 4));
      tllh = xyz2llh(usrxyz);                                               % �N�I��w���y�Х�(X,Y,Z)���(Lat,Lon,ht)
      R = [-sin(tllh(2)), cos(tllh(2)), 0; 
           -sin(tllh(1))*cos(tllh(2)), -sin(tllh(1))*sin(tllh(2)), cos(tllh(1)); 
            cos(tllh(1))*cos(tllh(2)), cos(tllh(1))*sin(tllh(2)), sin(tllh(1))];                                                             
      QENU = R*Q(1: 3, 1: 3)*R.';
      HDOP(i) = sqrt(QENU(1, 1) + QENU(2, 2));
      VDOP(i) = sqrt(QENU(3, 3));

    enuerr(i,:) = xyz2enu(estusr(1:3)-usrxyz,usrplh);                       % �p��w��~�t����ܦa���y�Шt��
    rx_clk_err(i,1)= estusr(4);                                             % �N�����������~�t�s�Jrx_clk_err(i,1)
    end
end

%% ------- calculate precision and RMS ------- %%
de = norm(enuerr(:,1));                                                     % E��V�w��~�t
dn = norm(enuerr(:,2));                                                     % N��V�w��~�t
dh = norm(enuerr(:,3));                                                     % Height��V�w��~�t

%% -------------------- E -------------------- %%
meanE = sum(enuerr(:,1))/i;
RESE = enuerr(:,1)-meanE;
standardE = ((RESE'*RESE)/(i-1))^0.5;
rmse = sqrt( de*de/i);

%% -------------------- N -------------------- %%
meanN = sum(enuerr(:,2))/i;
RESN = enuerr(:,2)-meanN;
standardN = ((RESN'*RESN)/(i-1))^0.5;
rmsn = sqrt( dn*dn/i);

%% ------------------ Height ------------------ %%
meanH = sum(enuerr(:,3))/i;
RESH = enuerr(:,3)-meanH;
standardH = ((RESH'*RESH)/(i-1))^0.5;
rmsu = sqrt( dh*dh/i);

%% ---------------- output txt ---------------- %%
file = fopen('CK01_output_tropospheric.txt', 'w');
fprintf(file, 'meanE = %9.6f, standardE =%9.6f, rmse = %9.6f\n', meanE, standardE, rmse);
fprintf(file, 'meanN = %9.6f, standardN =%9.6f, rmsn = %9.6f\n', meanN, standardN, rmsn);
fprintf(file, 'meanH = %9.6f, standardH =%9.6f, rmsu = %9.6f\n\n', meanH, standardH, rmsu);

fprintf(file, 'GDOP_avg = %5.4f\n', mean(GDOP));
fprintf(file, 'PDOP_avg = %5.4f\n', mean(PDOP));
fprintf(file, 'TDOP_avg = %5.4f\n', mean(TDOP));
fprintf(file, 'HDOP_avg = %5.4f\n', mean(HDOP));
fprintf(file, 'VDOP_avg = %5.4f\n\n', mean(VDOP));

fprintf(file, '2D error = %9.6f, 3D error = %9.6f\n', sqrt(rmse^2+rmsn^2), sqrt(rmse^2+rmsn^2+rmsu^2));
fprintf(file, 'UERE_H = %9.6f, UERE_EN = %9.6f, UERE_ENH = %9.6f\n', sqrt(rmsu^2)/mean(VDOP), sqrt(rmse^2+rmsn^2)/mean(HDOP), sqrt(rmse^2+rmsn^2+rmsu^2)/mean(GDOP));

%% --------------- output plot ---------------- %%

%% ------------- (E, N) direction ------------- %%
figure
subplot(2,2,1)
plot(enuerr(:,1),enuerr(:,2),'*'),grid
axis square ; axis equal
axis([-20 20 -20 20])
title('GPS Point Positioning Error')
ylabel('north error (m)')
xlabel('east error (m)')
grid on

%% --------- (Height, Time) direction --------- %%
subplot(2,2,2)
plot(1:aEpoch,enuerr(:,3),'*'),grid
axis square
axis([0 aEpoch -30 30])
title('GPS Point Positioning Error')
ylabel('height error (m)')
xlabel('epoch')
grid on

%% ------------ (E, Time) direction ----------- %%
subplot(2,2,3)
plot(1:aEpoch,enuerr(:,1),'*'),grid
axis square
axis([0 aEpoch -30 30])
title('GPS Point Positioning Error')
ylabel('east error (m)')
xlabel('epoch')
grid on

%% ------------ (N, Time) direction ----------- %%
subplot(2,2,4)
plot(1:aEpoch,enuerr(:,2),'*'),grid
axis square
axis([0 aEpoch -30 30])
title('GPS Point Positioning Error')
ylabel('north error (m)')
xlabel('epoch')
grid on

%% ----------------- save plot ---------------- %%
saveas(gcf, './picture//positioning_error_tropospheric.png');

%% ----------------- GDOP plot ---------------- %%
figure
subplot(2,3,1)
plot(GDOP)
axis([0 aEpoch 0 10])
title('GDOP')
xlabel('epoch')
grid on

%% ----------------- PDOP plot ---------------- %%
subplot(2,3,2)
plot(PDOP)
axis([0 aEpoch 0 10])
title('PDOP')
xlabel('epoch')
grid on

%% ----------------- TDOP plot ---------------- %%
subplot(2,3,3)
plot(TDOP)
axis([0 aEpoch 0 10])
title('TDOP')
xlabel('epoch')
grid on

%% ----------------- HDOP plot ---------------- %%
subplot(2,3,4)
plot(HDOP)
axis([0 aEpoch 0 10])
title('HDOP')
xlabel('epoch')
grid on

%% ----------------- VDOP plot ---------------- %%
subplot(2,3,5)
plot(VDOP)
axis([0 aEpoch 0 10])
title('VDOP')
xlabel('epoch')
grid on

%% ----------------- save plot ---------------- %%
saveas(gcf, './picture//DOP_tropospheric.png');