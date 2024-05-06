function [observation] = helperCreatObservation(pos, avg, var)
    random_ = (avg + var*randn(size(pos, 1), 2));
    observation = pos+random_;
end

