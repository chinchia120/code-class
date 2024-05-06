%  sndemo50.m  Loading and storing RINEX2 ephemeris and observation files
%
%clear all
%storerinnav('stkr2581.02n','stkr2581nav')
clear all
tic
%storerinob('CK010810.06o','CK01081ob')
storerinob('sv050810.06o','sv050810ob')
% storerinob('sv060810.06o','sv060810ob')
% storerinob('sv052900.06o','sv052900ob')
% storerinob('sv062900.06o','sv062900ob')
% storerinob('sima2132.06o','sima213ob')
% storerinob('spp10510.05o','spp10510ob')
% storerinob('spp20510.05o','spp20510ob')
toc
