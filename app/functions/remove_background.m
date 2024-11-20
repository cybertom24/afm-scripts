function [y1, b] = remove_background(x, y, x_start, x_end)
    % Removes background from the curve.
    % Background is fitted between x_start and x_end.
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

    [m, q] = fit_line_partial(x, y, x_start, x_end);
    b = m*x + q;
    y1 = y - b;
end