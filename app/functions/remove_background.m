function [y1, b] = remove_background(x, y, x_start, x_end)
    % Removes background from the curve.
    % Background is fitted between x_start and x_end.
    % If both x_start and x_end are the same Inf, the last (if +Inf) or
    % first (if -Inf) value is treated as background and it is removed
    % ----
    % Arguments:
    % x = vector containing the curve's x coordinates
    % y = vector containing the curve's y coordinates
    % x_start = x value from which background starts
    % x_end = x value to which background ends
    %
    % Returns:
    % y1 = vector containing the curve's y coordinates without the fitted
    % background
    % b = vector containing the y coordinates of the fitted background
    % 
    % Note: y = y1 + y
        
    if isinf(x_start) && x_start == x_end
        if x_start == +Inf
            % Treat the last value as background
            [~, i] = max(x);
        else
            % Treat the first value as background
            [~, i] = min(x);
        end
        % The background is a straight line
        m = 0;
        q = x(i);
    else
        [m, q] = fit_line_partial(x, y, x_start, x_end);
    end
    
    b = m*x + q;
    y1 = y - b;
end