function [mu, sigma, x, y] = fitta_istogramma(h, start_mu, start_sigma)
    val = h.Values;
    n = val * 0;
    edges = h.BinEdges;

    for i = 1:1:length(n)
        n(i) = (edges(i) + edges(i+1)) / 2; 
    end

    % scatter(n, val, 'DisplayName', 'Punti istogramma');

    % Fitta con curva gaussiana
    [mu, sigma] = fitta_gaussiana(n, val, start_mu, start_sigma);

    x = 1:1:max(n);
    y = (1/(sigma*sqrt(2*pi))) * exp( -( ((x - mu).^2)/(2*sigma^2) ) );
end