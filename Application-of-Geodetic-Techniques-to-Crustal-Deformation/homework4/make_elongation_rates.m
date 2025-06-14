function [Vbase,Sigbase]=make_elongation_rates(Ve,Vn,Sige,Sign,baselines,Vec_unit,L,BaseEnds,SegEnds)

%dot velocity vectors into unit direction 
Vbase2 = Ve(baselines(:,2)).*Vec_unit(:,1) + Vn(baselines(:,2)).*Vec_unit(:,2);
Vbase1 = Ve(baselines(:,1)).*Vec_unit(:,1) + Vn(baselines(:,1)).*Vec_unit(:,2);
%propagate errors
Sig_base2 = sqrt(Vec_unit(:,1).^2.*Sige(baselines(:,2)).^2 + Vec_unit(:,2).^2.*Sign(baselines(:,2)).^2);
Sig_base1 = sqrt(Vec_unit(:,1).^2.*Sige(baselines(:,1)).^2 + Vec_unit(:,2).^2.*Sign(baselines(:,1)).^2);


Vbase = Vbase1 - Vbase2;
%propagate error
Sigbase = sqrt(Sig_base2.^2 + Sig_base1.^2);

%{
figure; hold on;  
for k=1:size(BaseEnds,1)
    obs(k)=Vbase(k)/L(k);
    cline([BaseEnds(k,1) BaseEnds(k,3)],[BaseEnds(k,2) BaseEnds(k,4)],[obs(k) obs(k)])
end
for k=1:size(SegEnds,1);  plot([SegEnds(k,1) SegEnds(k,3)],[SegEnds(k,2) SegEnds(k,4)],'k'); end

colorbar
caxis([-1 1])
axis equal
%}