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
function [E, Erid] = calcola_E_modH(z, d, k, R, v)
    % Calcola l'indentazione (h) [m]
    h = (-z) - d;
    
    % Calcola il modulo di Young solo se è stato possibile indentare
    % In caso contrario restituisci NaN
    %if max(h) <= 0
      %E = NaN;
      %Erid = NaN;
      %return;
    %end
    
    % Calcola la forza (f) [N]
    f = k * d;

    % Linearizza la forza
    f_lin = potenza(f, 2/3);

    % Fitta la parte lineare e recupera S
    % Parti a fittare a metà tra il punto in cui la forza raggiunge il valore minimo
    % e il punto in cui assume il valore massimo
    % Trova valore minimo
    % [f_contatto, i_contatto] = min(f_lin);

    %[S, q] = fitta_retta_parziale_xy(h, f_lin, h(i_contatto), Inf, f_contatto, Inf);
    %[S, q] = fitta_retta_parziale_xy(h, f_lin, 0, Inf, 0, Inf);
    
    % Prendi i primi 4 punti
    [S, q] = fitta_retta(h( 1:5 ), f_lin( 1:5 ));
    
    % Se la S risulta negativa vuol dire che c'è stato un problema con il calcolo
    % Ritorna quindi NaN
    if S <= 0
      E = NaN;
      Erid = NaN;
      return;
    end
    
    % Calcola E ridotto
    Erid = (S ^ 1.5) * 0.75 / sqrt(R);

    % Calcola E
    E = Erid * (1 - v^2);
end