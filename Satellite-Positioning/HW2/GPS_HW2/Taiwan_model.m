% Local model

function TaiwanLM_ZTD=Taiwan_model(DOY,Lat,H)
% MET. coefficient
P_beta=[1015.9 -6.5621];
WtVP_beta=[28.7013 10.5448 3.1547];
T_beta=[-0.8295 44.4101 0.7618 -12.4038];

% MET @geoid
P0 = P_beta(1)-P_beta(2)*cos(2*pi*(DOY-28)./365.25);
t0 = (T_beta(1).*Lat+T_beta(2))-(T_beta(3).*Lat+T_beta(4)).*cos((2*pi.*(DOY-28))/365.25);
e0 = WtVP_beta(1)-WtVP_beta(2).*cos((2*pi.*(DOY-28))./365.25);
% MET @SL
t_SL = t0- H./100*0.65;
factor = H./(18400*(1+t_SL./273));
P_SL = P0./(10.^factor);



ZHD_SL_model = 10^(-6)*15.528*(148.72-488.36./(t_SL+273.16)).*P_SL;
ZWD0_model = 2.2*10^(-3)*(-12.96./(t0+273.16)+371800./(t0+273.16).^2).*e0;
ZWD_SL_model = ZWD0_model.*exp((0-H)./1000./WtVP_beta(3));
TaiwanLM_ZTD = ZHD_SL_model + ZWD_SL_model;