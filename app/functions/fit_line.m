function [m, q, Rsq, sigma, sigma_m, sigma_q] = fit_line(x, y)
    % Fits a line to a series of x-y points using the minimum square method
    % ----
    % Arguments:
    % x = vector containing the points' x coordinates
    % y = vector containing the points' y coordinates
    %
    % Returns:
    % m = line's angular coefficient
    % q = line's known therm
    % Rsq = fitting's R^2
    % sigma = fitting's standard deviation
    % sigma_m = standard deviation of m
    % sigma_m = standard deviation of q
    
    x_mean = mean(x);
    y_mean = mean(y);
    sxx = sum( (x - x_mean) .^ 2 );
    sxy = sum( (x - x_mean) .* (y - y_mean) );
    m = sxy / sxx;
    q = y_mean - m * x_mean;

    Sres = sum( (y - (m*x + q)) .^ 2 );
    Stot = sum( (y - y_mean) .^ 2 );

    sigma = sqrt( Sres / (length(x) - 2)  );
    sigma_m = sigma / sqrt( sxx );
    sigma_q = sigma * sqrt( sum( x .^ 2 ) / (length(x) * sxx) );

    Rsq = 1 - Sres / Stot;
end