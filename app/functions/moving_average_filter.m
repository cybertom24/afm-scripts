function [smooth_x, smooth_y] = moving_average_filter(x, y, n)
    
    % Smooth the x-y signal by a moving average filter with a filter of
    % size n.
    % This will lose n points at the start of the vectors and also n points
    % to the end.
    % Important: x values must be equally spaced
    % ---
    % Arguments
    % x = vector containing the x coordinates of the signal
    % y = vector containing the y coordinates of the signal
    % n = size of the filter
    % Returns
    % smooth_x = vector containing the x coordinates of the smoothed signal
    % smooth_y = vector containing the y coordinates of the smoothed signal

    % Create coefficients' vector in order to calculate the average (point
    % has equal weight)
    coefficients = ones(1, n) / n;
    
    smooth_y = filter(coefficients, 1, y);
    
    % compensate filter's native delay (filter_length - 1) / 2
    fDelay = (length(coefficients) - 1) / 2;
    dx = x(2) - x(1);
    smooth_x = x - dx * fDelay;

    % Discard the first n - 1 points (they are averaged with zeros)
    smooth_x = smooth_x(n:end);
    smooth_y = smooth_y(n:end);
end