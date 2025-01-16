clc;
clear;
close all;

addpath ./funzioni/

k = 0.5;    % N/m
R = 35e-9;  % m
v = 0.5;   % 1

marker_size = 100;

% Inizio

% Calibra lo strumento
% [~, slope] = calibra('./dati/zaffiro_DZ_2024_10_24_801pt_2mspt.txt');
% [~, slope] = calibra('./dati/zaffiro-2024_10_31-1001pt-5x.txt');
% slope = 350;
[~, slope] = calibra('./dati/exp111/curve29.txt');

% Carica la curva di forza
% [~, ~, zu, Nfu] = load_curva_forza('./dati/curva-ldpe.txt');
% [~, ~, zu, Nfu] = load_curva_forza('./dati/map48-ps.txt');
% [~, ~, zu, Nfu] = load_curva_forza('./dati/zaffiro-2024_10_31-1001pt-5x.txt');
[~, ~, z_og, Nf] = load_force_curve('./dati/exp111/curve-map48.txt');

% [~, ~, z_old, Nf_old] = load_force_curve('./dati/curva-ACM-12_07_2024.txt');
%z_og = linspace(min(z_old), max(z_old), 401);
%Nf = interp1(z_old, Nf_old, z_og, 'spline');

% Rimuovi il background
[Nf_nob, b] = rimuovi_background(z_og, Nf, max(z_og) * 0.80, max(z_og));

d_og = Nf_nob / slope * 1e-9;
z_og = z_og * 1e-9;

%d_og = flip(d_og);
%z_og = flip(z_og);

figure;
grid on;
hold on;
legend show; 
scatter(z_og, d_og, 'Marker', '.', 'SizeData', marker_size, 'DisplayName','curva DZ [og]');
title('Curva DZ originale vs filtrate');
xlabel('z [m]');
ylabel('d [m]');

% Ripulisci il grafico
% Gira i vettori se è necessario
[~, i_max] = max(d_og);
[~, i_min] = min(d_og);

if i_max < i_min
    d_og = flip(d_og);
    z_og = flip(z_og);
end

% --- Moving Average Filter ---
% Seleziona quanto grande costruire il filtro
filter_length = 10;
% Crea il vettore dei coefficienti
% Costruito in questo modo assegna a ciascun punto considerato lo stesso
% peso e quindi calcola la media.
coefficients = ones(1, filter_length) / filter_length;
% Esegui il filtraggio
d_mov_avg = filter(coefficients, 1, d_og);
% Compensa il ritardo di (filter_length - 1) / 2
fDelay = (length(coefficients) - 1) / 2;
z_mov_avg = z_og + abs(z_og(1) - z_og(2)) * fDelay;

plot(z_mov_avg, d_mov_avg, 'DisplayName','curva DZ [ripulita]');

% D'ora in poi lavora sul segnale ripulto
z = z_mov_avg;
d = d_mov_avg;

% --- Derivate ---
n = 15;
[dx, dy] = derivata_locale(z, d, n);
plot(dx, dy * 1e-9, 'DisplayName','\partiald * 10^{-9} [og]');

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

% Questi sono i punti minimi e massimi oltre i quali non si va
% Ha senso continuare solo se ci sono abbastanza punti

h_max = 0.10 * R;
delta_z = abs(z(1) - z(2));
punti_minimi = h_max / delta_z;

if abs(i_inizio - i_fine) < punti_minimi
    fprintf('pochi punti')
    return;
end

% Flippa i vettori se gli indici sono al contrario
if i_inizio > i_fine
    i_fine = length(z) + 1 - i_fine;
    i_inizio = length(z) + 1 - i_inizio;
    
    z = flip(z);
    d = flip(d); 
end

% Cerchia i punti che ci interessano
scatter(z(i_inizio:i_fine), d(i_inizio:i_fine), 'Marker', 'o', 'SizeData', marker_size, 'DisplayName','Intervallo da fittare');
% --- Test di calcolo ---

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

for i = i_inizio:1:(i_fine - punti_minimi)
    % i indica l'indice di partenza per l'intervallo
    % Isola la porzione
    d_fit = d(i:i_fine);
    z_fit = z(i:i_fine);
    
    % Togli l'offset
    d_fit = d_fit - d_fit(1);
    z_fit = z_fit - z_fit(1);

    % Calcola l'indentazione
    h_fit = (-z_fit) - d_fit;
    
    % h(1) = 0 mentre h(i_max) = h_max. Trova quel punto
    [~, i_max] = min(abs(h_fit - h_max));
    
    % Restringi ancora l'intervallo
    h2fit = h_fit(1:i_max);
    d2fit = d_fit(1:i_max);
    
    %{
    figure;
    grid on;
    hold on;
    legend show;
    scatter(z_fit, d_fit, 'Marker', '.', 'SizeData', marker_size, 'DisplayName','curva DZ [tagliata]');
    scatter(z_fit, h_fit, 'Marker', '.', 'SizeData', marker_size, 'DisplayName','curva HZ [tagliata]');
    scatter(z_fit(1:i_max), h2fit, 'Marker', 'o', 'SizeData', marker_size, 'DisplayName','intervallo H');
    scatter(z_fit(1:i_max), d2fit, 'Marker', 'o', 'SizeData', marker_size, 'DisplayName','intervallo D');
    scatter(h2fit, d2fit, 'Marker', '.', 'SizeData', marker_size, 'DisplayName', 'curva DH');
    xline(z_fit(i_max), 'DisplayName', 'h = h_{max}');
    title('Curva DZ originale vs filtrate');
    xlabel('z [m]');
    ylabel('d [m]');
    %}

    % Non prendere nulla che abbia meno del 90% dei punti minimi (non
    % avrebbe senso, vorrebbe dire che ha indentato di più di quello di cui
    % z è avanzata)
    if length(h2fit) < 0.9 * punti_minimi
        continue;
    end

    % Linearizza
    d_lin = potenza(d2fit, 2/3);

    % Fitta
    [m, q, sigma, ~, ~, Rsq] = fitta_retta(h2fit, d_lin);
    
    %{
    figure;
    grid on;
    hold on;
    legend show;
    scatter(h2fit, d_lin, 'Marker', '.', 'SizeData', marker_size, 'DisplayName', 'Curva D^{2/3}Z');
    plot(h2fit, m * h2fit + q, 'DisplayName', 'fit lineare');
    title('Curva linearizzata e fit');
    xlabel('h [m]');
    ylabel('d^{2/3} [m^{2/3}]');
    %}

    if m <= 0 || isnan(m)
        % Sicuramente non va bene
        fprintf('m non valido\n');
        continue;
    end

    % Ora confronta il risultato del fit
    if sigma < sigma_best
        % Questo e' il miglior fit trovato fin'ora
        sigma_best = sigma;
        % Salva le opzioni del fit
        sigma_best_start = i;
        sigma_best_stop = i_max;
        sigma_best_m = m;
        sigma_best_q = q;
    end

    % Ora confronta il risultato del fit
    if Rsq > Rsq_best && Rsq <= 1
        % Questo e' il miglior fit trovato fin'ora
        Rsq_best = Rsq;
        % Salva le opzioni del fit
        Rsq_best_start = i;
        Rsq_best_stop = i_max;
        Rsq_best_m = m;
        Rsq_best_q = q;
    end
end

% Mostra il miglior risultato
figure;
grid on;
hold on;
legend show;
scatter(z, d, 'Marker', '.', 'SizeData', marker_size, 'DisplayName', 'Curva DZ');
xline(z(sigma_best_start), 'g--', 'DisplayName', 'inizio [\sigma]');
xline(z(sigma_best_stop + sigma_best_start - 1), 'r--', 'DisplayName', 'fine [\sigma]');
xline(z(Rsq_best_start), 'g', 'DisplayName', 'inizio [R^2]');
xline(z(Rsq_best_stop + Rsq_best_start - 1), 'r', 'DisplayName', 'fine [R^2]');
title('Miglior fit trovato - curva originale');
xlabel('z [nm]');
ylabel('d [nm]');

z_fit_s = z(sigma_best_start:(sigma_best_stop + sigma_best_start - 1));
d_fit_s = d(sigma_best_start:(sigma_best_stop + sigma_best_start - 1));

z_fit_s = z_fit_s - z_fit_s(1);
d_fit_s = d_fit_s - d_fit_s(1);

h_fit_s = (-z_fit_s) - d_fit_s;

d_lin_s = potenza(d_fit_s, 2/3);

figure;
grid on;
hold on;
legend show;
scatter(h_fit_s, d_lin_s, 'Marker', '.', 'SizeData', marker_size, 'DisplayName', 'Curva D^{2/3}Z [\sigma]');
plot(h_fit_s, sigma_best_m * h_fit_s + sigma_best_q, 'DisplayName', 'fit lineare [\sigma]');
title('Miglior fit trovato - curva linearizzata');
xlabel('h [m]');
ylabel('d^{2/3} [m^{2/3}]');

z_fit_r = z(Rsq_best_start:(Rsq_best_stop + Rsq_best_start - 1));
d_fit_r = d(Rsq_best_start:(Rsq_best_stop + Rsq_best_start - 1));

z_fit_r = z_fit_r - z_fit_r(1);
d_fit_r = d_fit_r - d_fit_r(1);

h_fit_r = (-z_fit_r) - d_fit_r;

d_lin_r = potenza(d_fit_r, 2/3);

scatter(h_fit_r, d_lin_r, 'Marker', '.', 'SizeData', marker_size, 'DisplayName', 'Curva D^{2/3}Z [R^2]');
plot(h_fit_r, Rsq_best_m * h_fit_r + Rsq_best_q, 'DisplayName', 'fit lineare [R^2]');

% Calcola E
Erid = (sigma_best_m ^ 1.5) * 0.75 * k / sqrt(R);
E = Erid * (1 - v^2);

fprintf('(sigma) E calcolato: %d\n', E);

Erid = (Rsq_best_m ^ 1.5) * 0.75 * k / sqrt(R);
E = Erid * (1 - v^2);

fprintf('(Rsq) E calcolato: %d\n', E);

close all;

figure;
grid on;
hold on;
legend('show', 'location', 'north');
xlabel('z [nm]');
ylabel('d [nm]');
scatter(z_og * 1e9, d_og * 1e9, 'DisplayName', 'original force curve', 'Marker', '.', 'SizeData', 200);
plot(z * 1e9, d * 1e9, 'DisplayName', 'denoised force curve', 'LineWidth', 2);
plot(dx * 1e9, dy, 'DisplayName', 'local derivative', 'LineWidth', 2);
% plot(z * 1e9, gradient(d) ./ gradient(z), 'DisplayName', '{\partial}F', 'LineWidth', 2)

xline(z(i_inizio) * 1e9, 'k--', 'DisplayName', 'start region', 'LineWidth', 2);
xline(z(i_fine) * 1e9, 'k--', 'DisplayName', 'end region', 'LineWidth', 2);

xline(z(Rsq_best_start) * 1e9, 'k', 'DisplayName', 'start fit', 'LineWidth', 2);
xline(z(Rsq_best_stop + Rsq_best_start - 1) * 1e9, 'k', 'DisplayName', 'end fit', 'LineWidth', 2);

figure;
grid on;
hold on;
legend show;
xlabel('h [nm]');
ylabel('F^{2/3} [nN^{2/3}]');

scatter(h_fit_r * 1e9, d_lin_r * (k * 1e9)^(2/3), 'Marker', '.', 'SizeData', marker_size, 'DisplayName', 'linearized curve', 'SizeData', 200);
plot(h_fit_r * 1e9, (Rsq_best_m * h_fit_r + Rsq_best_q) * (k * 1e9)^(2/3), 'DisplayName', 'linear fit', 'LineWidth', 2);