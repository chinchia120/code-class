function [BaseEnds_ll]=xy2ll_BaseEnds(BaseEnds,ll_org)

latdt=111.325;

for k=1:size(BaseEnds,1)
    londt=cos(ll_org(1,1)*pi/180)*latdt;
    BaseEnds_ll(k,1)=BaseEnds(k,1)/londt+ll_org(1,2);
    BaseEnds_ll(k,3)=BaseEnds(k,3)/londt+ll_org(1,2);
    BaseEnds_ll(k,2)=BaseEnds(k,2)/latdt+ll_org(1,1);
    BaseEnds_ll(k,4)=BaseEnds(k,4)/latdt+ll_org(1,1);
end