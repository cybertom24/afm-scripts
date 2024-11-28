clc;
close all;
clear;

addpath ./funzioni
addpath ./app/functions/

% Caratteristiche punta e materiale
k = 0.5;    % [N/m]
R = 35e-9;  % [m]
v = 0.5;    % []

% Caratteristiche mappa
L = 2;      % [um]

% Impostazioni fitting
n = 15;
Rsq_min = 0.90;
b_start = 0.80;

% Recupera la slope di calibrazione
[~, ~, z, Nf] = load_force_curve('./dati/exp111/curve3.txt');
slope = calculate_slope(z, Nf, max(z) * 0.80, +Inf);

%% --- P1 (56.5; 59.5): img46, map48 ---

% Calcola la mappa, convertendo i valori in MPa
Emap = calculate_E_map('./dati/exp111/map14.txt', slope, k, R, v, n, Rsq_min, 0.80) * 1e-6;

% Conta il numero di NaN
numero_NaN = sum(isnan(Emap), 'all');
tot = length(Emap)^2;
fprintf('Numero di errori: %d. Successo: %.2f\n', numero_NaN, ((tot - numero_NaN) * 100 / tot) );

% Mostra l'immagine, la mappa e l'istogramma
figure;

% Carica la mappa delle z convertendo in nm
Hmap = load_height_map('./dati/exp111/img12.txt') * 1e3;
subplot(1, 3, 1);
add_height_map_to_figure(Hmap, L, 'nm', 'Height map of P_1', bone);

subplot(1, 3, 2);
add_E_map_to_figure(Emap, L, 'MPa', 'Elastic modulus map of P_1');

% Costruisci e mostra l'istogramma
bin_size = 200;

subplot(1, 3, 3);
grid on;
histogram(Emap, 'DisplayName', 'E', 'BinWidth', bin_size, 'Normalization', 'pdf');
xlabel('E [MPa]');
ylabel('pdf');
title('Elastic modulus distribution of the map of P_1');

%% --- P2 (56.5; 46.5): img49, map50 ---

% Calcola la mappa, convertendo i valori in MPa
Emap = calculate_E_map('./dati/exp111/map17.txt', slope, k, R, v, n, Rsq_min, 0.80) * 1e-6;

% Conta il numero di NaN
numero_NaN = sum(isnan(Emap), 'all');
tot = length(Emap)^2;
fprintf('Numero di errori: %d. Successo: %.2f\n', numero_NaN, ((tot - numero_NaN) * 100 / tot) );

figure;

% Carica la mappa delle z convertendo in nm
Hmap = load_height_map('./dati/exp111/img15.txt') * 1e3;
subplot(1, 3, 1);
add_height_map_to_figure(Hmap, L, 'nm', 'Height map of P_2', bone);

subplot(1, 3, 2);
add_E_map_to_figure(Emap, L, 'MPa', 'Elastic modulus map of P_2');

% Costruisci e mostra l'istogramma
bin_size = 20;

subplot(1, 3, 3);
grid on;
histogram(Emap, 'DisplayName', 'E', 'BinWidth', bin_size, 'Normalization', 'pdf');
xlabel('E [MPa]');
ylabel('pdf');
title('Elastic modulus distribution of the map of P_2');

%% --- P3 (64; 61): img51, map53 ---

% Calcola la mappa, convertendo i valori in MPa
Emap = calculate_E_map('./dati/exp111/map20.txt', slope, k, R, v, n, Rsq_min, 0.80) * 1e-6;

% Conta il numero di NaN
numero_NaN = sum(isnan(Emap), 'all');
tot = length(Emap)^2;
fprintf('Numero di errori: %d. Successo: %.2f\n', numero_NaN, ((tot - numero_NaN) * 100 / tot) );

figure;

% Carica la mappa delle z convertendo in nm
Hmap = load_height_map('./dati/exp111/img18.txt') * 1e3;
subplot(1, 3, 1);
add_height_map_to_figure(Hmap, L, 'nm', 'Height map of P_3', bone);

subplot(1, 3, 2);
add_E_map_to_figure(Emap, L, 'MPa', 'Elastic modulus map of P_3');

% Costruisci e mostra l'istogramma
bin_size = 20;

subplot(1, 3, 3);
grid on;
histogram(Emap, 'DisplayName', 'E', 'BinWidth', bin_size, 'Normalization', 'pdf');
xlabel('E [MPa]');
ylabel('pdf');
title('Elastic modulus distribution of the map of P_3');

%% --- P4 (64.5; 47): img54, map55 ---

% Calcola la mappa, convertendo i valori in MPa
Emap = calculate_E_map('./dati/exp111/map23.txt', slope, k, R, v, n, Rsq_min, 0.80) * 1e-6;

% Conta il numero di NaN
numero_NaN = sum(isnan(Emap), 'all');
tot = length(Emap)^2;
fprintf('Numero di errori: %d. Successo: %.2f\n', numero_NaN, ((tot - numero_NaN) * 100 / tot) );

figure;

% Carica la mappa delle z convertendo in nm
Hmap = load_height_map('./dati/exp111/img21.txt') * 1e3;
subplot(1, 3, 1);
add_height_map_to_figure(Hmap, L, 'nm', 'Height map of P_4', bone);

subplot(1, 3, 2);
add_E_map_to_figure(Emap, L, 'MPa', 'Elastic modulus map of P_4');

% Costruisci e mostra l'istogramma
bin_size = 100;

subplot(1, 3, 3);
grid on;
histogram(Emap, 'DisplayName', 'E', 'BinWidth', bin_size, 'Normalization', 'pdf');
xlabel('E [MPa]');
ylabel('pdf');
title('Elastic modulus distribution of the map of P_4');