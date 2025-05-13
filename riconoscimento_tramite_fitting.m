clc;
clear;
% close all;

addpath ./funzioni/

k = 0.5;    % N/m
R = 8e-9;  % m
v = 0.22;   % 1

marker_size = 100;

% Inizio

% Calibra lo strumento
[~, slope] = calibra('./dati/zaffiro-2024_10_31-1001pt-5x.txt');

% Carica la curva di forza
[~, ~, zu, Nfu] = load_curva_forza('./dati/map48-ps.txt');

% Rimuovi il background
[Nfu_nob, b] = rimuovi_background(zu, Nfu, max(zu) * 0.80, max(zu));

d = Nfu_nob / slope;
z = zu;

%d = flip(d);
%z = flip(z);

figure;
grid on;
hold on;
legend show; 
scatter(z, d, 'Marker', '.', 'SizeData', marker_size, 'DisplayName','curva DZ [og]');
title('Curva DZ originale vs filtrate');
xlabel('z [nm]');
ylabel('d [nm]');

% --- Derivate ---
n = 15;
[dx, dy] = derivata_locale(z, d, n);
plot(dx, dy, 'DisplayName','\partiald [og]');

% --- Riconoscimento ---

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

xline(z(i_inizio), 'g--', 'DisplayName', 'inizio');
xline(z(i_fine), 'r--', 'DisplayName', 'fine');

% Gira gli indici se serve
i_min = min(i_inizio, i_fine);
i_max = max(i_inizio, i_fine);

% Questi sono i punti minimi e massimi oltre i quali non si va
% Ha senso continuare solo se ci sono abbastanza punti
punti_minimi = 50;
if i_max - i_min < punti_minimi
    fprintf('pochi punti')
    return;
end

%%
% --- Test di calcolo ---

% Non analizzare mai meno di delta_punti (senno' con due punti appena il 
% fit e' perfetto)
delta_punti = punti_minimi;
% Modifica l'inizio e la fine del fit in modo da trovare la regione dove il
% fit e' migliore
sigma_best = +Inf;
sigma_best_start = 0;
sigma_best_stop = 0;
sigma_best_m = 0;
sigma_best_q = 0;

Rsq_best = 0;
Rsq_best_start = 0;
Rsq_best_stop = 0;
Rsq_best_m = 0;
Rsq_best_q = 0;

% Cicla tutti i possibili intervalli di fitting e trova il migliore
for i = i_min:1:(i_max - delta_punti)
    for j = (i + delta_punti):1:i_max
        % Isola la porzione
        d_fit_s = d(i:j);
        z_fit_s = z(i:j);

        % Togli l'offset
        [d_min, i_d_min] = min(d_fit_s);
        z_fit_s = z_fit_s - z_fit_s(i_d_min);
        d_fit_s = d_fit_s - d_min;
        
        % Converti in m
        z_fit_s = z_fit_s * 1e-9;
        d_fit_s = d_fit_s * 1e-9;

        % Calcola h
        h_fit_s = (-z_fit_s) - d_fit_s;

        % D'ora in poi lavora solo con h >= 0
        d2fit = d_fit_s(h_fit_s > 0);
        h2fit = h_fit_s(h_fit_s > 0);

        % Linearizza e fitta con la retta
        d_lin_s = potenza(d2fit, 2/3);

        % La curva linearizzata deve essere sufficientemente ricca di punti
        % senno' non ha senso
        if length(d_lin_s) <= (punti_minimi - 1)
            continue;
        end

        [m, q, sigma, ~, ~, Rsq] = fitta_retta(h2fit, d_lin_s);
    
        if m <= 0 || isnan(m)
            % Sicuramente non va bene
            continue;
        end

        % Ora confronta il risultato del fit
        if sigma < sigma_best
            % Questo e' il miglior fit trovato fin'ora
            sigma_best = sigma;
            % Salva le opzioni del fit
            sigma_best_start = i;
            sigma_best_stop = j;
            sigma_best_m = m;
            sigma_best_q = q;
        end

        % Ora confronta il risultato del fit
        if Rsq > Rsq_best && Rsq <= 1
            % Questo e' il miglior fit trovato fin'ora
            Rsq_best = Rsq;
            % Salva le opzioni del fit
            Rsq_best_start = i;
            Rsq_best_stop = j;
            Rsq_best_m = m;
            Rsq_best_q = q;
        end
    end
end

% Mostra il miglior risultato
figure;
grid on;
hold on;
legend show;
scatter(z, d, 'Marker', '.', 'SizeData', marker_size, 'DisplayName', 'Curva DZ');
xline(z(sigma_best_start), 'g--', 'DisplayName', 'inizio [\sigma]');
xline(z(sigma_best_stop), 'r--', 'DisplayName', 'fine [\sigma]');
xline(z(Rsq_best_start), 'g', 'DisplayName', 'inizio [R^2]');
xline(z(Rsq_best_stop), 'r', 'DisplayName', 'fine [R^2]');
title('Miglior fit trovato - curva originale');
xlabel('z [nm]');
ylabel('d [nm]');

z_fit_s = z(sigma_best_start:sigma_best_stop) * 1e-9;
d_fit_s = d(sigma_best_start:sigma_best_stop) * 1e-9;

[d_min, i_d_min] = min(d_fit_s);
z_fit_s = z_fit_s - z_fit_s(i_d_min);
d_fit_s = d_fit_s - d_min;

h_fit_s = (-z_fit_s) - d_fit_s;

d2fit_s = d_fit_s(h_fit_s > 0);
h2fit_s = h_fit_s(h_fit_s > 0);

d_lin_s = potenza(d2fit_s, 2/3);

%%

figure;
grid on;
hold on;
legend show;
% scatter(h2fit_s, d_lin_s, 'Marker', '.', 'SizeData', marker_size, 'DisplayName', 'Curva D^{2/3}Z [\sigma]');
% plot(h2fit_s, sigma_best_m * h2fit_s + sigma_best_q, 'DisplayName', 'fit lineare [\sigma]');
% title('Miglior fit trovato - curva linearizzata');
xlabel('h [nm]');
ylabel('F^{2/3} [N^{2/3}]');

z_fit_r = z(Rsq_best_start:Rsq_best_stop)* 1e-9;
d_fit_r = d(Rsq_best_start:Rsq_best_stop)* 1e-9;

[d_min, i_d_min] = min(d_fit_r);
z_fit_r = z_fit_r - z_fit_r(i_d_min);
d_fit_r = d_fit_r - d_min;

h_fit_r = (-z_fit_r) - d_fit_r;

d2fit_r = d_fit_r(h_fit_r > 0);
h2fit_r = h_fit_r(h_fit_r > 0);

d_lin_r = potenza(d2fit_r, 2/3);

plot(h2fit_r * 1e9, (Rsq_best_m * h2fit_r + Rsq_best_q), 'DisplayName', 'Linear fit', 'LineWidth', 2);
scatter(h2fit_r * 1e9, d_lin_r, 'Marker', '.', 'SizeData', marker_size, 'DisplayName', 'Linearized curve');


% Calcola E
Erid = (Rsq_best_m ^ 1.5) * 0.75 * k / sqrt(R);
E = Erid * (1 - v^2);

fprintf('E calcolato: %d\n', E);