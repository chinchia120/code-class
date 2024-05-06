%% Static Calculate %%
function output = static_calculate(data)
    avg_error = mean(abs(data));
    std_error = std(abs(data));
    max_error = max(abs(data));
    min_error = min(abs(data));

    output = [avg_error; std_error; max_error; min_error];
end