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
function [E, Erid, u_E, u_Erid] = calcola_E_da_FH_kontomaris(f, h, R, v)
    % Fitta con una funzione a * x ^ b
    % Parti a fittare dal minimo
    % Trascina però la funzione verso l'alto in modo che il minimo corrisponda con lo zero
    % Trova il minimo
    [f_min, i_min] = min(f);
    h_min = h(i_min);
    % Porta le y a 0
    f = f - f_min;
    % Shifta le x in modo che quando f = 0 anche h = 0
    h = h - h_min;

    % D'ora in poi lavora solo con h >= 0
    f = f(h > 0);
    h = h(h > 0);

    %figure;
    %hold on;
    %grid on;
    %legend show;
    %plot(h, f);
    
    % Fitta con il modello di potenza
    % Esecuzione del fitting con vincoli: b >= 1
    [fitted_curve, gof, out] = fit(h, f, 'power1', 'Lower', [-Inf 1], 'StartPoint', [0 0]);

    % Recupera i risultati del fit
    a = fitted_curve.a;
    b = fitted_curve.b;
    sigma = gof.rmse;

    % Se b risulta diversa da 1.5 vuol dire che il modello non è giusto
    % Ritorna quindi NaN
    max_error = 0.1;
    if abs(b - 1.5) > max_error
      E = NaN;
      Erid = NaN;
      u_E = NaN;
      u_Erid = NaN;
      return;
    end

    %plot(h, (a * (h.^b)), 'DisplayName',['a: ' num2str(a) ' - b: ' num2str(b)]);

    % Equazione 29 Kontomaris 2022
    c1 =  1.01400;
    c2 = -0.09059;
    c3 = -0.09431;
    rc = (R * ( c1 * sqrt(h/R) + c2 * (h/R) + c3 * ((h/R) .^ 2) ));

    % Avendo calcolato rc, posso unire le eq. 25, 26 e 29 per ottenere E
    %E = (1 - v^2) * (a * b / 2) * ( (h .^ (b - 1)) ./ rc );
    
    f_fit = a * (h.^b);

    % Consigliato da Kontomaris 2017
    Erid = (f_fit ./ (rc .* h)) * b / 2;
    
    %figure;
    %hold on;
    %grid on;
    %legend show;
    %plot(h, Erid, 'DisplayName','con fit');
    %plot(h, (f ./ (rc .* h)) * b / 2, 'DisplayName','senza fit');
    %xlabel('h [m]');
    %ylabel('Erid [Pa]');

    % Mia versione di Kontomaris 2017
    % Erid_k2017_mio = (a * b / 2) * max(h) ^ (b - 1) / max(rc)
    % Dal modello Hertziano, mia versione
    %Erid = 3/4 * a / sqrt(R);
    %E = (1 - v^2) * Erid;
    %u_E = 0;
    %u_Erid = 0;
    %return;
    
    % Calcola l'incertezza sul valore di Erid
    % (vedi propagazione dell'incertezza sul fit)
    u_Erid = ((b / 2) * sigma) ./ (rc .* h);
    
    % Rimuovi quando h = 0 ed rc = 0
    u_Erid = u_Erid((h > 0) & (rc > 0));
   
    %figure;
    %grid on;
    %hold on;
    %scatter(Erid, u_Erid);
    %title('u_Erid in funzione di Erid');
    
    % Calcola Erid solo quando u_Erid è minore
    [u_Erid_min, i_min] = min(u_Erid);
    
    Erid = Erid(i_min);
    u_Erid = u_Erid_min;

    % Se Erid o uErid dovessero essere negativi, ritorna NaN
    if Erid < 0 || u_Erid < 0
      E = NaN;
      Erid = NaN;
      u_E = NaN;
      u_Erid = NaN;
      return;
    end
    
    E = Erid * (1 - v^2);

    % Dato che si assume u(v) = 0, per trovare u(E) basta moltiplicare per
    % (1 - v^2)
    u_E = (1 - v^2) * u_Erid;
end