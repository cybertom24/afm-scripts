% Calcola il modulo di Young partendo dalla curva 
% posizione cantilever (z) - deflessione cantilever (d)
% z: [m] vettore contenente la posizione verticale del cantilever
% d: [m] vettore contenente la deflessione del cantilever
% k: [N/m] costante elastica del cantilever
% R: [m] raggio della sfera che conclude la punta della AFM
% v: [ ] coefficiente di poisson. Se non lo si conosce inserire 1
% n: [ ] larghezza finestra per il calcolo della derivata e il conseguente
% riconoscimento della porzione da fittare
% p: [ ] larghezza minima della porzione da fittare indicata come numero di
% punti campionati all'interno di essa
% E: [Pa] modulo di Young calcolato
% Erid: [Pa] modulo di Young ridotto (in caso non si conosca v) 
%
% Richieste:
% Il background deve essere già stato rimosso
% La conversione da au a m per d deve essere già stata eseguita
function [E, Erid, u_E, u_Erid] = calcola_E_modH_lineare_fitting(z, d, k, R, v, n, p)
    
    % Ritrasforma in nm (spero si possa togliere prima o poi)
    % z = z * 1e9;
    % d = d * 1e9;
    
    % Calcola la derivata prima
    [dz, dd] = derivata_locale(z, d, n);

    % L'inizio della regione di fitting corrisponde al punto di minimo della
    % curva
    [~, i_inizio] = min(d);

    % La fine corrisponde con il punto in cui la punta smette di indentare,
    % ovvero dove la derivata prima raggiunge il -1
    % Prendi il primo valore minore di -1
    sotto_meno1 = dz(dd <= -1);
    [~, i_fine] = min(z);
    if ~isempty(sotto_meno1)
        [~, i] = max(sotto_meno1);
        z_fine = sotto_meno1(i);
        % Trova il punto nel vettore z dove la differenza e' minima
        % Ovvero trova la z(i) piu' simile a z_fine
        [~, i_fine] = min( abs(z - z_fine) );
    end

    % Gira gli indici se serve
    i_min = min(i_inizio, i_fine);
    i_max = max(i_inizio, i_fine);

    % Questi sono i punti minimi e massimi oltre i quali non si va
    % Ha senso continuare solo se ci sono abbastanza punti
    if i_max - i_min < p
        % Segna che il fit non è andato a buon fine
        E = NaN;
        Erid = NaN;
        u_E = NaN;
        u_Erid = NaN;
        return;
    end

    % Non analizzare mai meno di delta_punti (senno' con due punti appena il 
    % fit e' perfetto)
    delta_punti = p;
    % Modifica l'inizio e la fine del fit in modo da trovare la regione dove il
    % fit e' migliore. Utilizza Rsq come parametro per riconoscere il
    % miglior fit.
    
    best = 0;
    best_start = 0;
    best_stop = 0;
    best_m = 0;
    best_q = 0;

    % Cicla tutti i possibili intervalli di fitting e trova il migliore
    for i = i_min:1:(i_max - delta_punti)
        for j = (i + delta_punti):1:i_max
            % Isola la porzione
            d_fit = d(i:j);
            z_fit = z(i:j);

            % Togli l'offset
            [d_min, i_d_min] = min(d_fit);
            z_fit = z_fit - z_fit(i_d_min);
            d_fit = d_fit - d_min;

            % Converti in m
            % z_fit = z_fit * 1e-9;
            % d_fit = d_fit * 1e-9;

            % Calcola h
            h_fit = (-z_fit) - d_fit;

            % D'ora in poi lavora solo con h >= 0
            d2fit = d_fit(h_fit > 0);
            h2fit = h_fit(h_fit > 0);

            % Linearizza e fitta con la retta
            d_lin = potenza(d2fit, 2/3);

            % La curva linearizzata deve essere sufficientemente ricca di punti
            % senno' non ha senso
            if length(d_lin) <= (p - 1)
                continue;
            end

            [m, q, ~, ~, ~, Rsq] = fitta_retta(h2fit, d_lin);

            if m <= 0 || isnan(m)
                % Sicuramente non va bene
                continue;
            end

            % Ora confronta il risultato del fit
            if Rsq > best && Rsq <= 1
                % Questo e' il miglior fit trovato fin'ora
                best = Rsq;
                % Salva le opzioni del fit
                best_start = i;
                best_stop = j;
                best_m = m;
                best_q = q;
            end
        end
    end

    % Ora che è stato trovato il miglior fit calcola il modulo elastico
    % Se nessun fit è stato trovato, segna tutto come NaN e concludi la
    % funzione.

    if best == 0
        E = NaN;
        Erid = NaN;
        u_E = NaN;
        u_Erid = NaN;
        return;
    end

    % Calcola E
    Erid = (best_m ^ 1.5) * 0.75 * k / sqrt(R);
    E = Erid * (1 - v^2);
    u_Erid = 0; %9/8 * sqrt(best_m/R) * best_sigma_m;
    u_E = 0; % u_Erid * (1 - v^2);
end