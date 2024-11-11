% Calcola il modulo di Young partendo dalla curva 
% posizione cantilever (z) - deflessione cantilever (d)
% z: [m] vettore contenente la posizione verticale del cantilever
% d: [m] vettore contenente la deflessione del cantilever
% k: [N/m] costante elastica del cantilever
% R: [m] raggio della sfera che conclude la punta della AFM
% v: [ ] coefficiente di poisson. Se non lo si conosce inserire 1
% n: [ ] larghezza finestra per il calcolo della derivata e il conseguente
% riconoscimento della porzione da fittare
% E: [Pa] modulo di Young calcolato
% Erid: [Pa] modulo di Young ridotto (in caso non si conosca v) 
%
% Richieste:
% Il background deve essere già stato rimosso
% La conversione da au a m per d deve essere già stata eseguita

function [E, Erid, u_E, u_Erid] = calcola_E_modH_lineare_riconoscimento(z, d, k, R, v, n)
    
    z = z * 1e9;
    d = d * 1e9;

    % Calcolo della derivata prima
    [dx, dy] = derivata_locale(z, d, n);
    % Calcolo della derivata seconda
    % [dx2, dy2] = derivata_locale(dx, dy, n);
    % Calcolo della derivata terza
    % [dx3, dy3] = derivata_locale(dx2, dy2, n);
    
    % L'inizio della regione di fitting corrisponde al punto di minimo della
    % curva
    [~, i_inizio] = min(d);

    % La fine corrisponde con il punto in cui la punta smette di indentare,
    % ovvero dove la derivata prima raggiunge il -1
    % Prendi il primo valore minore di -1
    sotto_meno1 = dx(dy <= -1);
    [~, i_fine] = min(z);
    if ~isempty(sotto_meno1)
        [~, i] = max(sotto_meno1);
        z_fine = sotto_meno1(i);
        % Trova il punto nel vettore z dove la differenza e' minima
        % Ovvero trova la z(i) piu' simile a z_fine
        [~, i_fine] = min( abs(z - z_fine) );
    end

%{
figure;
grid on;
hold on;
legend show;
scatter(z, d, 'Marker', '.', 'SizeData', 150, 'DisplayName','curva DZ [og]');
title('Curva DZ');
xlabel('z [nm]');
ylabel('d [nm]');
xline(z(i_inizio), 'g--', 'DisplayName', 'inizio');
xline(z(i_fine), 'r--', 'DisplayName', 'fine');
plot(dx, dy, 'DisplayName','\partiald [og]');
plot(dx2, dy2, 'DisplayName','\partial^2d [og]');
plot(dx3, dy3, 'DisplayName','\partial^3d [og]');
%}    
    z = z * 1e-9;
    d = d * 1e-9;
    % Gira gli indici se serve
    i_min = min(i_inizio, i_fine);
    i_max = max(i_inizio, i_fine);

    % Isola la porzione
    d = d(i_min:i_max);
    z = z(i_min:i_max);

    % Togli l'offset
    [d_min, i_d_min] = min(d);
    z = z - z(i_d_min);
    d = d - d_min;

    % Calcola h
    h = (-z) - d;

    % D'ora in poi lavora solo con h >= 0
    d = d(h > 0);
    h = h(h > 0);

    % Linearizza
    d_lin = potenza(d, 2/3);
    h_lin = h;
    
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

    %{
    if E > 100
        figure;
        hold on;
        plot(h_lin, d_lin);
        plot(h_lin, m*h_lin + q);
    end
    %}
end