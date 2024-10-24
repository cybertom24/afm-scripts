function [m, q, sigma, sigma_m, sigma_q] = fitta_retta_parziale(x, y, x_start, x_end)
    % x_start deve essere sempre minore di x_end
    temp = x_start;
    x_start = min(x_start, x_end);
    x_end = max(temp, x_end);
    
    % Restringi il dominio di fitting
    x2fit = x(x >= x_start & x <= x_end);
    y2fit = y(x >= x_start & x <= x_end);

    [m, q, sigma, sigma_m, sigma_q] = fitta_retta(x2fit, y2fit);
end