function [x_i, i, df] = trova_valore_piu_simile(x, val)
    diff = abs(x - val);
    % df is the minimum distance, ind is the index of the minimum distance
    [df,i] = min(diff); 
    x_i = x(i);
end