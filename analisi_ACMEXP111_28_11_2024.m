clc;
close all;
clear;

addpath ./funzioni
addpath ./app/functions/
addpath ./more-colormaps/

set(0, 'DefaultAxesFontSize', 14);
set(0, 'DefaultTextFontSize', 14);

% Caratteristiche punta e materiale
k = 0.5;    % [N/m]
R = 35e-9;  % [m]
v = 0.5;    % []

% Caratteristiche mappa
L = 2;      % [um]

% Impostazioni fitting
n = 15;
Rsq_min = 0.95;
b_start = 0.80;

% Recupera la slope di calibrazione
[~, ~, z, Nf] = load_force_curve('./dati/exp111/curve29.txt');
slope = calculate_slope(z, Nf, max(z) * 0.80, +Inf);

%% --- P1 (61.29; 64.84): img46, map48 ---

% Calcola la mappa, convertendo i valori in MPa
Emap = calculate_E_map('./dati/exp111/map48.txt', slope, k, R, v, n, Rsq_min, 0.80) * 1e-6;

% Conta il numero di NaN
numero_NaN = sum(isnan(Emap), 'all');
tot = length(Emap)^2;
fprintf('Numero di errori: %d. Successo: %.2f\n', numero_NaN, ((tot - numero_NaN) * 100 / tot) );

% Mostra l'immagine, la mappa e l'istogramma
figure;
tiledlayout(1, 2);

% Carica la mappa delle z convertendo in nm
Hmap = load_height_map('./dati/exp111/img46.txt') * 1e3;
nexttile;
add_height_map_to_figure(Hmap, L, 'nm', 'Height map of P_1', slanCM('heat'));

nexttile;
add_E_map_to_figure(Emap, L, 'MPa', 'Elastic modulus map of P_1');

% Costruisci e mostra l'istogramma
bin_size = 100;

figure;
grid on;
histogram(Emap, 'DisplayName', 'E', 'BinWidth', bin_size, 'Normalization', 'pdf');
xlabel('E [MPa]');
ylabel('pdf');
title('E distribution of the map of P_1');
xlim([0 5000]);

%% --- P2 (50.43; 50.89): img49, map50 ---

% Calcola la mappa, convertendo i valori in MPa
Emap = calculate_E_map('./dati/exp111/map50.txt', slope, k, R, v, n, Rsq_min, 0.80) * 1e-6;

% Conta il numero di NaN
numero_NaN = sum(isnan(Emap), 'all');
tot = length(Emap)^2;
fprintf('Numero di errori: %d. Successo: %.2f\n', numero_NaN, ((tot - numero_NaN) * 100 / tot) );

figure;

% Carica la mappa delle z convertendo in nm
Hmap = load_height_map('./dati/exp111/img49.txt') * 1e3;
nexttile;
add_height_map_to_figure(Hmap, L, 'nm', 'Height map of P_2', slanCM('heat'));

nexttile;
add_E_map_to_figure(Emap, L, 'MPa', 'Elastic modulus map of P_2');

% Costruisci e mostra l'istogramma
bin_size = 100;

figure;
grid on;
histogram(Emap, 'DisplayName', 'E', 'BinWidth', bin_size, 'Normalization', 'pdf');
xlabel('E [MPa]');
ylabel('pdf');
title('E distribution of the map of P_2');
xlim([0 5000]);

%% --- P3 (59.29; 45.46): img51, map53 ---

% Calcola la mappa, convertendo i valori in MPa
Emap = calculate_E_map('./dati/exp111/map53.txt', slope, k, R, v, n, Rsq_min, 0.80) * 1e-6;

% Conta il numero di NaN
numero_NaN = sum(isnan(Emap), 'all');
tot = length(Emap)^2;
fprintf('Numero di errori: %d. Successo: %.2f\n', numero_NaN, ((tot - numero_NaN) * 100 / tot) );

figure;

% Carica la mappa delle z convertendo in nm
Hmap = load_height_map('./dati/exp111/img51.txt') * 1e3;
nexttile;
add_height_map_to_figure(Hmap, L, 'nm', 'Height map of P_3', slanCM('heat'));

nexttile;
add_E_map_to_figure(Emap, L, 'MPa', 'Elastic modulus map of P_3');

% Costruisci e mostra l'istogramma
bin_size = 100;

figure;
grid on;
histogram(Emap, 'DisplayName', 'E', 'BinWidth', bin_size, 'Normalization', 'pdf');
xlabel('E [MPa]');
ylabel('pdf');
title('E distribution of the map of P_3');
xlim([0 5000]);

%% --- P4 (56.19; 58.98): img54, map55 ---

% Calcola la mappa, convertendo i valori in MPa
Emap = calculate_E_map('./dati/exp111/map55.txt', slope, k, R, v, n, Rsq_min, 0.80) * 1e-6;

% Conta il numero di NaN
numero_NaN = sum(isnan(Emap), 'all');
tot = length(Emap)^2;
fprintf('Numero di errori: %d. Successo: %.2f\n', numero_NaN, ((tot - numero_NaN) * 100 / tot) );

figure;

% Carica la mappa delle z convertendo in nm
Hmap = load_height_map('./dati/exp111/img54.txt') * 1e3;
nexttile;
add_height_map_to_figure(Hmap, L, 'nm', 'Height map of P_4', slanCM('heat'));

nexttile;
add_E_map_to_figure(Emap, L, 'MPa', 'Elastic modulus map of P_4');

% Costruisci e mostra l'istogramma
bin_size = 100;

figure;
grid on;
histogram(Emap, 'DisplayName', 'E', 'BinWidth', bin_size, 'Normalization', 'pdf');
xlabel('E [MPa]');
ylabel('pdf');
title('E distribution of the map of P_4');
xlim([0 5000]);