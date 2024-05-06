function [Z,prn,mat] = getobs2(epochs,typenum,ptn)
% ptn{:,1} for phase
% ptn{:,2} for code
%
global PHASE CODE

a = epochs(1); b = epochs(2);
Z.CODE = []; prn = cell(1,2); mat = cell(1,2);
switch typenum
    case {1,14}    % L1 , E1
        prn{1} = find(any(ptn{1,1}(:,a:b),2));
        mat{1} = ptn{1,1}(prn{1},a:b);
        Z.PHASE{1} = PHASE{1,1}(prn{1},a:b);
        Z.PHASE{2} = PHASE{1,2}(prn{1},a:b);
        prn{2} = find(any(ptn{1,2}(:,a:b),2));
        mat{2} = ptn{1,2}(prn{2},a:b);
        Z.CODE{1} = CODE{1,1}(prn{2},a:b);
        Z.CODE{2} = CODE{1,2}(prn{2},a:b);
        if typenum==14, % L1 , E1
            prn2 = find(any(ptn{4,1}(:,a:b),2));
            mat{1} = cat(1,mat{1},ptn{4,1}(prn2,a:b));
            Z.PHASE{1} = cat(1,Z.PHASE{1},PHASE{4,1}(prn2,a:b));
            Z.PHASE{2} = cat(1,Z.PHASE{2},PHASE{4,2}(prn2,a:b));
            prnc2 = find(any(ptn{4,2}(:,a:b),2));
            mat{2} = cat(1,mat{2},ptn{4,2}(prnc2,a:b));
            Z.CODE{1} = cat(1,Z.CODE{1},CODE{4,1}(prnc2,a:b));
            Z.CODE{2} = cat(1,Z.CODE{2},CODE{4,2}(prnc2,a:b));
            prn{1} = cat(1,prn{1},prn2+200);
            prn{2} = cat(1,prn{2},prnc2+200);
        end
    case 2    % L2
        prn{1} = find(any(ptn{2,1}(:,a:b),2));
        mat{1} = ptn{2,1}(prn{1},a:b);
        Z.PHASE{1} = PHASE{2,1}(prn{1},a:b);
        Z.PHASE{2} = PHASE{2,2}(prn{1},a:b);
        prn{2} = find(any(ptn{2,2}(:,a:b),2));
        mat{2} = ptn{2,2}(prn{2},a:b);
        Z.CODE{1} = CODE{2,1}(prn{2},a:b);
        Z.CODE{2} = CODE{2,2}(prn{2},a:b);
    case {3,35}    % L5 , E5a
        prn{1} = find(any(ptn{3,1}(:,a:b),2));
        mat{1} = ptn{3,1}(prn{1},a:b);
        Z.PHASE{1} = PHASE{3,1}(prn{1},a:b);
        Z.PHASE{2} = PHASE{3,2}(prn{1},a:b);
        prn{2} = find(any(ptn{3,2}(:,a:b),2));
        mat{2} = ptn{3,2}(prn{2},a:b);
        Z.CODE{1} = CODE{3,1}(prn{2},a:b);
        Z.CODE{2} = CODE{3,2}(prn{2},a:b);
        if typenum==35, % L5 , E5a
            prn2 = find(any(ptn{5,1}(:,a:b),2));
            mat{1} = cat(1,mat{1},ptn{5,1}(prn2,a:b));
            Z.PHASE{1} = cat(1,Z.PHASE{1},PHASE{5,1}(prn2,a:b));
            Z.PHASE{2} = cat(1,Z.PHASE{2},PHASE{5,2}(prn2,a:b));
            prnc2 = find(any(ptn{5,2}(:,a:b),2));
            mat{2} = cat(1,mat{2},ptn{5,2}(prnc2,a:b));
            Z.CODE{1} = cat(1,Z.CODE{1},CODE{5,1}(prnc2,a:b));
            Z.CODE{2} = cat(1,Z.CODE{2},CODE{5,2}(prnc2,a:b));
            prn{1} = cat(1,prn{1},prn2+200);
            prn{2} = cat(1,prn{2},prnc2+200);
        end
    case 4    % E2-L1-E1
        prn1 = find(any(ptn{4,1}(:,a:b),2));
        mat{1} = ptn{4,1}(prn1,a:b);
        Z.PHASE{1} = PHASE{4,1}(prn1,a:b);
        Z.PHASE{2} = PHASE{4,2}(prn1,a:b);
        prn2 = find(any(ptn{4,2}(:,a:b),2));
        mat{2} = ptn{4,2}(prn2,a:b);
        Z.CODE{1} = CODE{4,1}(prn2,a:b);
        Z.CODE{2} = CODE{4,2}(prn2,a:b);
        prn{1} = prn1+200;
        prn{2} = prn2+200;
    case 5    % E5a
        prn1 = find(any(ptn{5,1}(:,a:b),2));
        mat{1} = ptn{5,1}(prn1,a:b);
        Z.PHASE{1} = PHASE{5,1}(prn1,a:b);
        Z.PHASE{2} = PHASE{5,2}(prn1,a:b);
        prn2 = find(any(ptn{5,2}(:,a:b),2));
        mat{2} = ptn{5,2}(prn2,a:b);
        Z.CODE{1} = CODE{5,1}(prn2,a:b);
        Z.CODE{2} = CODE{5,2}(prn2,a:b);
        prn{1} = prn1+200;
        prn{2} = prn2+200;
    case 6    % E5b
        prn1 = find(any(ptn{6,1}(:,a:b),2));
        mat{1} = ptn{6,1}(prn1,a:b);
        Z.PHASE{1} = PHASE{6,1}(prn1,a:b);
        Z.PHASE{2} = PHASE{6,2}(prn1,a:b);
        prn2 = find(any(ptn{6,2}(:,a:b),2));
        mat{2} = ptn{6,2}(prn2,a:b);
        Z.CODE{1} = CODE{6,1}(prn2,a:b);
        Z.CODE{2} = CODE{6,2}(prn2,a:b);
        prn{1} = prn1+200;
        prn{2} = prn2+200;
    case 7    % L2-L5 combination
        prn{1} = find(any(ptn{2,1}(:,a:b),2));
        mat{1} = ptn{2,1}(prn{1},a:b);
        Z.PHASE{1} = PHASE{2,1}(prn{1},a:b) - PHASE{3,1}(prn{1},a:b);
        Z.PHASE{2} = PHASE{2,2}(prn{1},a:b) - PHASE{3,2}(prn{1},a:b);
        prn{2} = find(any(ptn{2,2}(:,a:b),2));
        mat{2} = ptn{2,2}(prn{2},a:b);
        Z.CODE{1} = CODE{2,1}(prn{2},a:b);
        Z.CODE{2} = CODE{2,2}(prn{2},a:b);
    case 8    % E5b-E5a combination
        prn1 = find(any(ptn{5,1}(:,a:b),2));
        mat{1} = ptn{5,1}(prn1,a:b);
        Z.PHASE{1} = PHASE{6,1}(prn1,a:b) - PHASE{5,1}(prn1,a:b);
        Z.PHASE{2} = PHASE{6,2}(prn1,a:b) - PHASE{5,2}(prn1,a:b);
        prn2 = find(any(ptn{5,2}(:,a:b),2));
        mat{2} = ptn{5,2}(prn2,a:b);
        Z.CODE{1} = CODE{6,1}(prn2,a:b);
        Z.CODE{2} = CODE{6,2}(prn2,a:b);
        prn{1} = prn1+200;
        prn{2} = prn2+200;
end


