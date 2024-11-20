function slope = calculate_slope(x, y, b_start, b_end)
    % Calculates slope value from curve. The slope is fitted in the region
    % -Inf < x <= 0 after the removal of the background.
    % ----
    % Arguments:
    % x = vector containing the curve's x coordinates
    % y = vector containing the curve's y coordinates
    % b_start = x value from which background starts
    % b_end = x value to which background ends
    %
    % Returns:
    % slope = slope calculated from the curve

    [y1, ~] = remove_background(x, y, b_start, b_end);
    
    m = fit_line(x(x > -Inf & x <= 0), y1(x > -Inf & x <= 0));
    slope = abs(m);
end