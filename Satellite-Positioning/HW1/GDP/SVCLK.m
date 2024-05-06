function [AnsCLK,ExClkArr] = SVCLK(rTime,TimeArr,ClkArr,PseudoRange,d,NA)

% Computes Satellite clock correction using LG
% rTime = reception time,sec
% TimeArr = GPS time,sec
% PseudoRange = GPS Observation Data,meters
% ClkArr = Clk correction array corresponding TimeArr
%
% Written by  Phakphong Homniam

% Original Mathcad source code by Boonsap Witchayangkoon, 2000

global c

t = PseudoRange/c;
if d == 0
    [stdX,XtractClkArr,index,ExClkArr] = XCLK(rTime,TimeArr,ClkArr,3,NA);
    if index == 0
        AnsCLK = NA;
        ExClkArr = NA;
        return
    end
    AnsClkArr = ExClkArr;
    ExClkArr;
    return
end
[stdX,XtractClkArr,index,ExClkArr] = XCLK(rTime-t,TimeArr,ClkArr,d,NA); %rTime-t接收儀時間減回去
if index == 0
    AnsCLK = NA;
    ExClkArr = NA;
    return
end
AnsCLK = LG(d,stdX,XtractClkArr,NA);

AnsCLK;
ExClkArr;

%%%%%%%%%%END%%%%%%%%%%