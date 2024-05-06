function tt = chk_time(t)
% repairs over- and underflow of GPS time

tt = t;
iter=0;
while t > 302400,
    t = t - 604800;
    iter=iter+1;
    if iter > 3, error('Input time should be time of week in seconds'), end
    tt = t;
end
iter=0;
while t < -302400,
    t = t + 604800;
    iter=iter+1;
    if iter > 3, error('Input time should be time of week in seconds'), end
    tt = t;
end
%%%%%%% end chk_time.m  %%%%%%%%%%%%%%%%%
