function [usebtn,ctype,ptype] = chk_obs2(HA,HB)

ctype = cell(6,1); % code typename
ptype = cell(6,1); % phase typename
k = zeros(6,2);
Gtype = getgtyp(HA.GPS_TYPE(ismember(HA.GPS_TYPE,HB.GPS_TYPE)),3);
Etype = getetyp(HA.GAL_TYPE(ismember(HA.GAL_TYPE,HB.GAL_TYPE)),3);

%% GPS
for jg = 1:length(Gtype),
    switch Gtype{jg}
        case 'GL1'
            k(1,1) = k(1,1) + 1;
            ptype{1} = Gtype{jg};
        case 'GL2'
            k(2,1) = k(2,1) + 1;
            ptype{2} = Gtype{jg};
        case 'GL5'
            k(3,1) = k(3,1) + 1;
            ptype{3} = Gtype{jg};
        case {'GC1C','GC1P'}
            k(1,2) = k(1,2) + 1;
            ctype{1} = Gtype{jg};
        case {'GC2C','GC2P','GC2X'}
            k(2,2) = k(2,2) + 1;
            ctype{2} = Gtype{jg};
        case 'GC5I'
            k(3,2) = k(3,2) + 1;
            ctype{3} = Gtype{jg};
    end
end
%% Galileo
for je = 1:length(Etype),
    switch Etype{je}
        case 'EL1'
            k(4,1) = k(4,1) + 1;
            ptype{4} = Etype{je};
        case 'EL5'
            k(5,1) = k(5,1) + 1;
            ptype{5} = Etype{je};
        case 'EL7'
            k(6,1) = k(6,1) + 1;
            ptype{6} = Etype{je};
        case 'EC1B'
            k(4,2) = k(4,2) + 1;
            ctype{4} = Etype{je};
        case 'EC5I'
            k(5,2) = k(5,2) + 1;
            ctype{5} = Etype{je};
        case 'EC7I'
            k(6,2) = k(6,2) + 1;
            ctype{6} = Etype{je};
    end
end

kk(1:3) = k(1:3,1).*sum(k(1:3,2));
kk(4:6) = k(4:6,1).*sum(k(4:6,2));
usebtn = find(kk);

