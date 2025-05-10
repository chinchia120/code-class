%% Inexact line search
function [step_size_return] = inexact_search(f, point, step_size, gradient, direction, max_iter,up,low)

reduction_rate = 0.5; % fixed reduction_rate
c = rand(1); % fixed c

% hill climbing search
step = step_size;
acceleration = 1.2;
candidate = [-acceleration,-1/acceleration,1/acceleration,acceleration];
cpoint = point;

%hill climb algorithm
p = num2cell(point);
best_score = f(p{:});
sum_step = 0;
close = 1;
for i=1:100
    try_points = cpoint+transpose(candidate*step.*direction);
    new_try = [];
    best = -1;
    for j = 1: size(try_points,1) % 原本輸出為矩陣無法運作
        p = clip(try_points(j,:),up,low);
        ps = num2cell(p);
        new_try = cat(1,new_try,p);
        temp = f(ps{:});
        if(temp < best_score)
            best_score = temp;
            best = j;
        end
    end
    if (best == -1 )
        step= step / acceleration;
    else
        improve = candidate(best)*step .*direction;
        close = norm(improve);
        d_temp = (clip(cpoint+transpose(improve),up,low)-cpoint)./transpose(direction);
        [cpoint,in] = clip(cpoint+transpose(improve),up,low);     
        if(~in) % 若是已經clip 那step size 縮減至被clip的size            
            [M,I] = min(abs(nonzeros(d_temp)));
            a = nonzeros(d_temp);
            if(~isempty(a)) %部分clip住
                step = a(I);
                sum_step = sum_step+step;
            else %完全被clip住
                step= step / acceleration;
                %step = 0;
            end
        else     
            
            sum_step = sum_step+step;
            step = step * candidate(best); % 加速       
        end
    end 
    
    if(close<=10^-3 || step<=10^-5)        
        break;
    end
end
step_size_return = sum_step;