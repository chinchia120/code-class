clear all
for i = 1:18,
    el = i*5;
    tropd = mhopfld(el,0.06,1013,20,50,0,0,0);
    ele(i) = el;
    tropcorr(i) = tropd;
end
ele'
tropcorr'