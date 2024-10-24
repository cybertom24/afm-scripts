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
function [E, Erid, u_E, u_Erid] = calcola_E_modH_lineare(z, d, k, R, v)
    
    % Sposta la curva in modo che quando d = 0 anche z = 0
    % Ragiona solo dopo il minimo
    % Il problema è che non so se i valori sono in crescendo o in diminuendo
    [d_min, i_min] = min(d);
    [z_min, i_end] = min(z);

    % Le z sono in ordine decrescente
    if i_min > i_end
        % Le z sono in ordine crescente
        % Scambio
        temp = i_min;
        i_min = i_end;
        i_end = temp;
    end

    d = d(i_min:i_end);
    z = z(i_min:i_end);

    % Trova i punti in cui y cambia segno (da positivo a negativo o viceversa)
    x_zero = NaN;
    for i = 1:length(d) - 1
        y1 = d(i);
        y2 = d(i+1);
    
        if y1 * y2 < 0  % Cambia segno tra y1 e y2
            x1 = z(i);
            x2 = z(i+1);
        
            % Interpolazione lineare
            x_zero = x1 - y1 * (x2 - x1) / (y2 - y1);
            y_zero = 0;
        end
    end

    if isnan(x_zero) || (sum(d > 0, 'all') < 4)
        % Se la ricerca è fallita oppure ci sono troppo pochi elementi per
        % eseuire un fit fai lo shift scegliendo come punto quello
        % intermedio
        i_medio = floor((i_end + i_min) / 2);
        x_zero = z(i_medio);
        y_zero = d(i_medio);
    end

    % Shifta ora tutto in modo che quando d = 0 anche z = 0
    z = z - x_zero;
    d = d - y_zero;
    
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

    if E < 100e6
        figure;
        plot(h_lin, d_lin);
        hold on;
        plot(h_lin, m*h_lin + q);
        zero = 0;
    end
end