function [dx, dy] = local_derivative(x, y, n)
    % Computes the first local derivative of the function for every point
    % (x(i), y(i)) inside the interval [i-n; i+n].
    % ----
    % Arguments:
    % x = vector containing the x coordinates of the function
    % y = vector containing the y coordinates of the function
    % Returns:
    % dx = vector containing the x coordinates of the derivative
    % dy = vector containing the y coordinates of the derivative
    %
    % Note: the derivative is shorter than the original function by 2n

    dx = x((n+1):(end-n));
    dy = 0 * dx;
    % For every point fit the points inside the interval [i-n; i+n]
    % and get the angular coefficient 
    for i = (n+1):1:(length(x) - n)
        [m, ~] = fit_line( x((i-n):(i+n)), y((i-n):(i+n)) );
        dy(i-n) = m;
    end
end