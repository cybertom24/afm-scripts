% Calcola il modulo di Young partendo dalla curva 
% posizione cantilever (z) - deflessione cantilever (d)
% z: [m] vettore contenente la posizione verticale del cantilever
% d: [m] vettore contenente la deflessione del cantilever
% k: [N/m] costante elastica del cantilever
% R: [m] raggio della sfera che conclude la punta della AFM
% v: [ ] coefficiente di poisson. Se non lo si conosce inserire 1
% E: [Pa] modulo di Young calcolato
% Erid: [Pa] modulo di Young ridotto (in caso non si conosca v) 
%
% Richieste:
% Il background deve essere già stato rimosso
% La conversione da au a m per d deve essere già stata eseguita
function [E, Erid, u_E, u_Erid] = calcola_E_modH_lineare_simple(z, d, k, R, v)
    
    % Prendi solo la parte di curva dopo lo zero
    d = d(z <= 0);
    z = z(z <= 0);

    % Fai in modo che in z = 0 anche d = 0
    d = d - d(z == 0);

    figure;
    plot(z, d);

    % Calcola h
    h = (-z) - d;
    
    hold on;
    plot(z, h);
    plot(h, d);

    % Linearizza
    d_lin = potenza(d, 2/3);
    
    % Fitta
    [m, q, sigma, sigma_m] = fitta_retta(h, d_lin);
    
    if m <= 0
      E = NaN;
      Erid = NaN;
      u_E = NaN;
      u_Erid = NaN;
      return;
    end

    % Calcola E
    Erid = (m ^ 1.5) * 0.75 * k / sqrt(R);
    E = Erid * (1 - v^2);
    u_Erid = 9/8 * sqrt(m/R) * sigma_m;
    u_E = u_Erid * (1 - v^2);

    if 1 == 1% E < 100e6
        figure;
        plot(h, d_lin);
        hold on;
        plot(h, m*h + q);
        zero = 0;
    end
end