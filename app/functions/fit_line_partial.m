function [m, q, Rsq, sigma, sigma_m, sigma_q] = fit_line_partial(x, y, x_start, x_end)
    % Fits a line to a series of x-y points using the minimum square method
    % Only a subset that satisfies x_start <= x < x_end is fitted.
    % ----
    % Arguments:
    % x = vector containing the points' x coordinates
    % y = vector containing the points' y coordinates
    % x_start = value of x from which begin the fit
    % x_end = value of x to which end the fit
    %
    % Returns:
    % m = line's angular coefficient
    % q = line's known therm
    % Rsq = fitting's R^2
    % sigma = fitting's standard deviation
    % sigma_m = standard deviation of m
    % sigma_m = standard deviation of q


    % x_start must be less than  x_end
    temp = x_start;
    x_start = min(x_start, x_end);
    x_end = max(temp, x_end);
    
    % Restringi il dominio di fitting
    x2fit = x(x >= x_start & x <= x_end);
    y2fit = y(x >= x_start & x <= x_end);

    [m, q, Rsq, sigma, sigma_m, sigma_q] = fit_line(x2fit, y2fit);
end