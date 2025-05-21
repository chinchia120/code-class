%% clip function
function [v,tag] = clip(x,up,low)
    if(or(isempty(up),isempty(low)))
        tag = 0;
        v = x;
    else
        too_big = find(x>up);
        too_small = find(x<low);
        x(too_big) = up(too_big);
        x(too_small) = low(too_small);
        if(isempty(too_big)&&isempty(too_small))
            tag = 1;
        else
            tag = 0;
        end
        v = x;
    end
end