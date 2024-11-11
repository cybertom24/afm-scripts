function [m, q, sigma, sigma_m, sigma_q, Rsq] = fitta_retta(x, y)
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