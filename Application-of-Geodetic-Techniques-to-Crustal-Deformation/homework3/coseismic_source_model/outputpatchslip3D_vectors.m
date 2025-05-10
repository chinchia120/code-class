function [] = outputpatchslip3D_vectors(pm,slip,nve,nf)
%
%	 plotpatchslip1(pm,slip,nve)
%
% plots slip on fault patches on 2-D grid
%
% Input:
%	pm = patchmodel (dislocation parameters)
%	pm(:,1) = length;
%	pm(:,2) = width;
%	pm(:,3) = depth;
%	pm(:,4) = dip;
%	pm(:,5) = strike;
%	pm(:,6) = East Offset;
%	pm(:,7) = North Offset;
%	slip = slip values
%	nve  = number of vertical elements
%

depth=pm(:,3);


%slip components
ss=slip(1:end/2);
ds=slip(end/2+1:end);
ns=sqrt(ss.^2+ds.^2); %net slip

dd1=zeros(size(depth));
dd1(1:nve:end)=0*depth(1:nve:end);

for k=2:nve
   dd1(k:nve:end)=dd1(k-1:nve:end) + pm(1,2);
   
end


y = -[dd1 + pm(:,2), dd1];


x = zeros(size(y));
nhe = size(pm,1)/nve;

% for first nve elements
	x(1:nve,2) = pm(1,1);
for k=2:nhe
	index1 = nve*(k-1);
	index2 = nve*(k-2);
	x( index1+1:index1+nve , :) = ...
	[x(index2+1:index2+nve,2), ...
		 x(index2+1:index2+nve,2) + pm(index1+1,1)*ones(nve,1)];
end


strikevec=[cos((90-pm(:,5))*pi/180) sin((90-pm(:,5))*pi/180)];
dipvec=[-strikevec(:,2) strikevec(:,1)];
widthproject=pm(:,2).*cos(pm(:,4)*pi/180);

xvert1=pm(:,6)-.5*pm(:,1).*cos((90-pm(:,5))*pi/180);
yvert1=pm(:,7)-.5*pm(:,1).*sin((90-pm(:,5))*pi/180);
zvert1=-pm(:,3);

xvert2=pm(:,6)+.5*pm(:,1).*cos((90-pm(:,5))*pi/180);
yvert2=pm(:,7)+.5*pm(:,1).*sin((90-pm(:,5))*pi/180);
zvert2=-pm(:,3);

xvert4=xvert1+dipvec(:,1).*widthproject;
yvert4=yvert1+dipvec(:,2).*widthproject;
zvert4=-pm(:,3)+pm(:,2).*sin(pm(:,4)*pi/180);

xvert3=xvert2+dipvec(:,1).*widthproject;
yvert3=yvert2+dipvec(:,2).*widthproject;
zvert3=-pm(:,3)+pm(:,2).*sin(pm(:,4)*pi/180);

xvert=[xvert1';xvert2';xvert3';xvert4'];
yvert=[yvert1';yvert2';yvert3';yvert4'];
zvert=[zvert1';zvert2';zvert3';zvert4'];

fid=fopen(['gmt_faultplane_x_' int2str(nf) '.gmt'],'w');
fprintf(fid,'%10.4f %10.4f %10.4f %10.4f\r\n',xvert);
fclose(fid);
fid=fopen(['gmt_faultplane_y_' int2str(nf) '.gmt'],'w');
fprintf(fid,'%10.4f %10.4f %10.4f %10.4f\r\n',yvert);
fclose(fid);
fid=fopen(['gmt_faultplane_z_' int2str(nf) '.gmt'],'w');
fprintf(fid,'%10.4f %10.4f %10.4f %10.4f\r\n',zvert);
fclose(fid);
fid=fopen(['gmt_faultslip_' int2str(nf) '.gmt'],'w');
fprintf(fid,'%10.4f %10.4f %10.4f\r\n',[ss;ds;ns]);
fclose(fid);

centersx=mean([xvert1 xvert2 xvert3 xvert4],2);
centersy=mean([yvert1 yvert2 yvert3 yvert4],2);
centersz=mean([zvert1 zvert2 zvert3 zvert4],2);

strikevec=[strikevec zeros(size(strikevec(:,1)))];
dipvec=[dipvec tan(pm(:,4)*pi/180)];
normal=sqrt( dipvec(:,1).^2 + dipvec(:,2).^2 + dipvec(:,3).^2 );
dipvec=dipvec./repmat(normal,1,3);

slipvec=strikevec.*repmat(ss',1,3)+dipvec.*repmat(ds',1,3);

fid=fopen(['gmt_faultslip_vector_' int2str(nf) '.gmt'],'w');
fprintf(fid,'%10.4f %10.4f %10.4f %10.4f %10.4f %10.4f\r\n',[centersx centersy -centersz slipvec(:,1) slipvec(:,2) -slipvec(:,3)]');
fclose(fid);
