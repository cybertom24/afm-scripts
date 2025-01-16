function y = custom_power(x, p)
    % Calculates raises element-wise x to the power of p by removing the
    % sign and adding it in later. 
    % This way no complex number are generated.
    % ---
    % Arguments:
    % x = the vector which will be raised to the power
    % p = the exponent of the power
    % Returns:
    % y = the vector x raised element-wise to p
    
    y = sign(x) .* (abs(x) .^ p);
end