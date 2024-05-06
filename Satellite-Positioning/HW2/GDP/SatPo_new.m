function satpo = SatPo_new(rTime,PR,CLKsat,TimeArr,XArr,YArr,ZArr,x,d,NA,index)
% if index == 1,satpo = [XArr YArr ZArr]';,return,end
% Compute Satellite position at Transmission Epoch
% rTime = reception time at the receiver
% TimeArr = GPS time array
% PR pseudorange observation 
% XArr,YArr,ZArr = Satellite coordinate Corresponding to TimeArr(km)
% Xr,Yr,Zr = Satellite coordinate at reception time(km)
% Xt,Yt,Zt = Satellite coordinate at transmission time(km)
% x,y,z = Estimated Receiver Position(m)
%
% Written by  Phakphong Homniam

% Original Mathcad source code by Boonsap Witchayangkoon, 2000

global c omega

satpo(1:3) = NA;
Time = rTime-PR/c;
startTime = TimeArr(1,1)-5;
lastTime = TimeArr(size(TimeArr,1),1)+5;
if Time >= startTime & Time <= lastTime
    timeInterval = TimeArr(3,1)-TimeArr(2,1);
    [x1,x2,x3,x4] = XYZ(Time,TimeArr,XArr,d,NA);
    if x4 == 0
        satpo = satpo(:);
        return
    end
    Xt = LG(d,x1,x2,NA);
    [y1,y2,y3,y4] = XYZ(Time,TimeArr,YArr,d,NA);
    Yt = LG(d,y1,y2,NA);
    [z1,z2,z3,z4] = XYZ(Time,TimeArr,ZArr,d,NA);
    Zt = LG(d,z1,z2,NA);


% rTime
% TimeArr
% XArr

%     Xtp = XArr(find(TimeArr == rTime));
%     Ytp = YArr(find(TimeArr == rTime));
%     Ztp = ZArr(find(TimeArr == rTime));
%     
    omegat = omega*PR/c;
    Xtp = Xt*cos(omegat)+Yt*sin(omegat);
    Ytp = Yt*cos(omegat)-Xt*sin(omegat);
    Ztp = Zt;
   
    
    % rho = Geometric distance(m)
    rho = sqrt((Xtp-x(1))^2+(Ytp-x(2))^2+(Ztp-x(3))^2);
    rclk = (PR-(rho-c*CLKsat*10^-6))/c;
else
    fprintf('rTime is out of range in TimeArr:SeeSatPo\n');
    return
end
if (size(XArr,1) ~= size(YArr,1)) | (size(XArr,1) ~= size(ZArr,1)) ... 
        | (size(YArr,1) ~= size(ZArr,1))
    fprintf('Ephemeris Data X Y Z not equal size\n');
    return
end
rho_old = rho;
% for i = 1:30
%     t = rho/c;
%     Time = rTime-t-rclk;
%     
% 
%     
%     stdx = ((Time-x3)/timeInterval)+1;
%     Xt = LG(d,stdx,x2,NA);
%     Yt = LG(d,stdx,y2,NA);
%     Zt = LG(d,stdx,z2,NA);
% 
%     omegat = omega*t;
%     Xtp = Xt*cos(omegat)+Yt*sin(omegat);
%     Ytp =Yt*cos(omegat)-Xt*sin(omegat);
%     Ztp = Zt;
%     rho = sqrt((Xtp-x(1))^2+(Ytp-x(2))^2+(Ztp-x(3))^2);
%     if (abs(rho-rho_old) < 10^-6) ,break,end
%     rho_old = rho;
% end

% convert km -> m
satpo = [Xtp,Ytp,Ztp]';

%%%%%%%%%%END%%%%%%%%%%
    


