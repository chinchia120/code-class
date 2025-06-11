function [Vbase,Sigbase]=make_baseline_tilt_rates(Vu,Sigu,xy,pm,SegEnds)

%compute triangles
 tri = delaunay(xy(:,1),xy(:,2));
 %remove triangles with small angles
for k=1:size(tri,1)
    v1 = [xy(tri(k,3),1) xy(tri(k,3),2)]-[xy(tri(k,1),1) xy(tri(k,1),2)]; 
    v2 = [xy(tri(k,2),1) xy(tri(k,2),2)]-[xy(tri(k,1),1) xy(tri(k,1),2)];
    a1 = 180/pi*acos( dot(v1/norm(v1),v2/norm(v2)) );
    v1 = [xy(tri(k,1),1) xy(tri(k,1),2)]-[xy(tri(k,2),1) xy(tri(k,2),2)]; 
    v2 = [xy(tri(k,3),1) xy(tri(k,3),2)]-[xy(tri(k,2),1) xy(tri(k,2),2)];
    a2 = 180/pi*acos( dot(v1/norm(v1), v2/norm(v2)) );
    v1 = [xy(tri(k,1),1) xy(tri(k,1),2)]-[xy(tri(k,3),1) xy(tri(k,3),2)]; 
    v2 = [xy(tri(k,2),1) xy(tri(k,2),2)]-[xy(tri(k,3),1) xy(tri(k,3),2)];
    a3 = 180/pi*acos( dot(v1/norm(v1),v2/norm(v2)) );
    
    if abs(a1)<10 | abs(a2)<10 | abs(a3)<10
        index(k)=1;
    else
        index(k)=0;
    end

end
index=logical(index);
tri(index,:)=[];


%form baselines
tri_num = (1:size(tri,1))';
tri_num = repmat(tri_num,3,1);
baselines = [ tri(:,1:2) ; tri(:,2:3) ; [tri(:,1) tri(:,3) ]];  %keep track of triangle number
baselines = sort(baselines,2);

%baseline endpoints
BaseEnds = [xy(baselines(:,1),:) xy(baselines(:,2),:)];

% 
% 

centers_patches = [pm(:,6)-pm(:,2).*cos(pm(:,4)*pi/180).*cos(pm(:,5)*pi/180) pm(:,7)+pm(:,2).*cos(pm(:,4)*pi/180).*sin(pm(:,5)*pi/180)];
PatchEnds = [centers_patches(:,1)+.5*pm(:,1).*cos( (90-pm(:,5))*pi/180) centers_patches(:,2)+.5*pm(:,1).*sin( (90-pm(:,5))*pi/180) centers_patches(:,1)-.5*pm(:,1).*cos( (90-pm(:,5))*pi/180) centers_patches(:,2)-.5*pm(:,1).*sin( (90-pm(:,5))*pi/180)];

%PatchEnds = [pm(:,6)+.5*pm(:,1).*cos( (90-pm(:,5))*pi/180) pm(:,7)+.5*pm(:,1).*sin( (90-pm(:,5))*pi/180) pm(:,6)-.5*pm(:,1).*cos( (90-pm(:,5))*pi/180) pm(:,7)-.5*pm(:,1).*sin( (90-pm(:,5)*pi/180))];

%identify baselines that cross patches (will use model strain rate value at center of baseline)

is_surface = abs(pm(:,3)-pm(:,2).*sin(pm(:,4)*pi/180))<10^-3;
for k=1:size(BaseEnds,1)
    %int = intersectEdges(BaseEnds(k,:), SegEnds(1,:));
    int = intersectEdges(BaseEnds(k,:), PatchEnds(is_surface,:)); 
    crossind(k) = sum(sum(~isnan(int)))>0;
end


%remove any redundant baselines
[baselines, ib, ic] = unique(baselines,'rows');  %baselines(ic) = original baselines
tri_num = tri_num(ib);
BaseEnds = BaseEnds(ib,:);
crossind = crossind(ib);

centers = [(BaseEnds(:,1)+BaseEnds(:,3))/2 (BaseEnds(:,2)+BaseEnds(:,4))/2];


%unit directional vectors
Vec_unit = xy(baselines(:,1),:)-xy(baselines(:,2),:);
L = sqrt(Vec_unit(:,1).^2+Vec_unit(:,2).^2);
Vec_unit = Vec_unit./[L L];  


%dot velocity vectors into unit direction 
Vbase2 = Vu(baselines(:,2));
Vbase1 = Vu(baselines(:,1));
%propagate errors
Sig_base2 = Sigu(baselines(:,2));
Sig_base1 = Sigu(baselines(:,1));


Vbase = Vbase1 - Vbase2;
%propagate error
Sigbase = sqrt(Sig_base2.^2 + Sig_base1.^2);



figure; hold on;  
for k=1:size(BaseEnds,1)
    obs(k)=Vbase(k)/L(k);
    cline([BaseEnds(k,1) BaseEnds(k,3)],[BaseEnds(k,2) BaseEnds(k,4)],[obs(k) obs(k)])
end
for k=1:size(SegEnds,1);  plot([SegEnds(k,1) SegEnds(k,3)],[SegEnds(k,2) SegEnds(k,4)],'k'); end

colorbar
caxis([-1 1])
axis equal

%{
figure; hold on;  
for k=1:size(BaseEnds,1)
    cline([BaseEnds(k,1) BaseEnds(k,3)],[BaseEnds(k,2) BaseEnds(k,4)],single([crossind(k) crossind(k)]))
end
for k=1:size(SegEnds,1);  plot([SegEnds(k,1) SegEnds(k,3)],[SegEnds(k,2) SegEnds(k,4)],'k');


colorbar
caxis([-1 1])
axis equal
%}