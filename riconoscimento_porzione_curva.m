clc;
clear;
close all;

addpath ./funzioni/

k = 0.5;    % N/m
R = 8e-9;  % m
v = 0.22;   % 1

marker_size = 100;

% Inizio

% Calibra lo strumento
[~, slope] = calibra('./dati/zaffiro-2024_10_31-1001pt-5x.txt');

% Carica la curva di forza
[zu, Nfu, ~, ~] = load_curva_forza('./dati/map48-ldpe.txt');

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
% xlim([-10 100]);

% n = 10;
% [dx, dy] = derivata_locale(z, d, n);

% plot(dx, dy, 'DisplayName','\partiald');

% --- Moving Average Filter ---
% Seleziona quanto grande costruire il filtro
filter_length = 20;
% Crea il vettore dei coefficienti
% Costruito in questo modo assegna a ciascun punto considerato lo stesso
% peso e quindi calcola la media.
coefficients = ones(1, filter_length) / filter_length;
% Esegui il filtraggio
d_mov_avg = filter(coefficients, 1, d);
% Compensa il ritardo di (filter_length - 1) / 2
fDelay = (length(coefficients) - 1) / 2;
z_mov_avg = z + fDelay/filter_length;

% plot(z_mov_avg, d_mov_avg, 'DisplayName','curva DZ [moving average]');

% --- Savitzky-Golay Filter ---
%{
% Filtra il segnale indicando l'ordine del polinomio
filter_length = 21;
filter_order = 3;
d_sg_3 = sgolayfilt(d, filter_order, filter_length);
plot(z, d_sg_3, 'DisplayName','curva DZ [SG 3\circ]');

filter_order = 4;
d_sg_4 = sgolayfilt(d, filter_order, filter_length);
plot(z, d_sg_4, 'DisplayName','curva DZ [SG 4\circ]');

filter_order = 5;
d_sg_5 = sgolayfilt(d, filter_order, filter_length);
plot(z, d_sg_5, 'DisplayName','curva DZ [SG 5\circ]');
%}

% --- Derivate ---
n = 15;
[dx, dy] = derivata_locale(z, d, n);
% [dx_mov_avg, dy_mov_avg] = derivata_locale(z_mov_avg, d_mov_avg, n);

plot(dx, dy, 'DisplayName','\partiald [og]');
% plot(dx_mov_avg, dy_mov_avg, 'DisplayName','\partiald [mov avg]');

[dx2, dy2] = derivata_locale(dx, dy, n);
% [dx2_mov_avg, dy2_mov_avg] = derivata_locale(dx_mov_avg, dy_mov_avg, n);

plot(dx2, dy2, 'DisplayName','\partial^2d [og]');
% plot(dx2_mov_avg, dy2_mov_avg, 'DisplayName','\partial^2d [mov avg]');

[dx3, dy3] = derivata_locale(dx2, dy2, n);
plot(dx3, dy3, 'DisplayName','\partial^3d [og]');

% --- Riconoscimento ---

% L'inizio della regione di fitting corrisponde al punto di minimo della
% curva
[~, i_inizio] = min(d);

%{
% L'inizio della regione di fitting corrisponde al punto di minimo della
% derivata terza, che indica quando inizia l'inflessione della derivata
% seconda che a sua volta e' posizionata sulla deflessione della derivata
% prima che rappresenta la regione nella quale la curva si sta modificando
[~, i_d3_min] = min(dy3);
z_inizio = dx3(i_d3_min);
% Trova il punto nel vettore z dove la differenza e' minima
% Ovvero trova la z(i) piu' simile a z_inizio
[~, i_inizio] = min( abs(z - z_inizio) );
xline(z(i_inizio), 'g--', 'DisplayName', 'inizio');
%}

%{
% La fine corrisponde con il punto in cui la punta smette di indentare,
% ovvero dove e' presente il massimo della derivata seconda
[~, i2_fine] = max(dy2);
z_fine = dx2(i2_fine);
% Trova il punto nel vettore z dove la differenza e' minima
% Ovvero trova la z(i) piu' simile a z_fine
[~, i_fine] = min( abs(z - z_fine) );
%}

% La fine corrisponde con il punto in cui la punta smette di indentare,
% ovvero dove la derivata prima raggiunge il -1
% Prendi il primo valore minore di -1
sotto_meno1 = dx(dy <= -1);
[~, i] = max(sotto_meno1);
z_fine = sotto_meno1(i);
[~, i_fine] = min(z);
if ~isempty(sotto_meno1)
    [~, i] = max(sotto_meno1);
    z_fine = sotto_meno1(i);
    % Trova il punto nel vettore z dove la differenza e' minima
    % Ovvero trova la z(i) piu' simile a z_fine
    [~, i_fine] = min( abs(z - z_fine) );
end

%{
% La fine corrisponde al punto in cui la derivata 3 assume il valore
% massimo, segnalando il completamento del picco della derivata seconda che
% segnala la fine dell'inflessione della curva
[~, i_d3_max] = max(dy3);
z_fine = dx3(i_d3_max);
% Trova il punto nel vettore z dove la differenza e' minima
% Ovvero trova la z(i) piu' simile a z_inizio
[~, i_fine] = min( abs(z - z_fine) );
xline(z(i_fine), 'r--', 'DisplayName', 'fine');
%}

xline(z(i_inizio), 'g--', 'DisplayName', 'inizio');
xline(z(i_fine), 'r--', 'DisplayName', 'fine');
%%
% --- Test di calcolo ---

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

figure;
grid on;
hold on;
legend show;
scatter(z, d, 'Marker', '.', 'SizeData', marker_size, 'DisplayName','curva DZ');
title('Curva DZ ristretta alla porzione da fittare');
xlabel('z [nm]');
ylabel('d [nm]');

% Converti in m
z = z * 1e-9;
d = d * 1e-9;

% Calcola h
h = (-z) - d;

figure;
grid on;
hold on;
legend('show', 'location', 'northwest');
scatter(z, h, 'Marker', '.', 'SizeData', marker_size, 'DisplayName','curva ZH');
title('Curva ZH');
xlabel('z [m]');
ylabel('h [m]');

% D'ora in poi lavora solo con h >= 0
d = d(h > 0);
h = h(h > 0);

% Linearizza e fitta con la retta
d_lin = potenza(d, 2/3);

[m, q, sigma, sigma_m] = fitta_retta(h, d_lin);
    
if m <= 0
   E = NaN;
   Erid = NaN;
   u_E = NaN;
   u_Erid = NaN;
   fprintf('Errore\n')
   return;
end

figure;
grid on;
hold on;
legend('show', 'location', 'northwest');
scatter(h, d_lin, 'DisplayName', 'curva DH linearizzata', 'Marker', '.', 'SizeData', marker_size);
% scatter(h2fit, f2fit, 'DisplayName','curva FH linearizzata da fittare');
plot(h, h*m + q, 'DisplayName','fit');
title('Porzione di curva DH linearizzata');
xlabel('h [m]');
ylabel('d^{2/3} [m^{2/3}]');    

% Calcola E
Erid = (m ^ 1.5) * 0.75 * k / sqrt(R);
E = Erid * (1 - v^2);
u_Erid = 9/8 * sqrt(m/R) * sigma_m;
u_E = u_Erid * (1 - v^2);