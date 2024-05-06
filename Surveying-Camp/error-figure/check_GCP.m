%% Check GCP %%
function output = check_GCP(data_)
    dx_ = data_(3);
    dy_ = data_(4);
    dz_ = data_(5);
    
    if dx_ == 0 && dy_ == 0 && dz_ == 0
        output = true;
    else 
        output = false;
    end
end