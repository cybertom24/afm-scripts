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
function [E, Erid, u_E, u_Erid] = calcola_E_modH_lineare_finestra(z, d, k, R, v)
    
    % Scegli come punto di contatto il minimo
    [d_min, i_min] = min(d);
    z = z - z(i_min);
    d = d - d_min;

    % Segli la z minima
    soglia = -13e-9;

    % Restringi la curva
    d = d(z >= soglia);
    z = z(z >= soglia);
    
    % Calcola l'indentazione
    h = (-z) - d;

    % Calcola la forza
    % F = k * d;

    % Mantieni solo la parte positiva
    d_lin = d(h >= 0);
    h_lin = h(h >= 0);
    
    if length(d_lin) < 2
        E = NaN;
        Erid = NaN;
        u_E = NaN;
        u_Erid = NaN;
        return;
    end

    % Linearizza
    d_lin = potenza(d_lin, 2/3);
    
    % Fitta
    [m, q, sigma, sigma_m] = fitta_retta(h_lin, d_lin);
    
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
end