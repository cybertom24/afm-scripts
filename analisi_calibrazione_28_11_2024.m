clc;
close all;
clear;

addpath ./funzioni
addpath ./app/functions/

% Caratteristiche punta e materiale
k = 0.5;    % [N/m]
R = 35e-9;  % [m]
v = 0.22;   % []

% Caratteristiche mappa
L = 2;      % [um]

% Impostazioni fitting
n = 15;
Rsq_min = 0.98;
b_start = 0.80;

% Recupera la slope di calibrazione
[~, ~, z, Nf] = load_force_curve('./dati/exp111/curve3.txt');
slope = calculate_slope(z, Nf, max(z) * 0.80, +Inf);

%% --- P1 (61.29; 64.84): img46, map48 ---

% Calcola la mappa, convertendo i valori in MPa
Emap = calculate_E_map('./dati/exp111/map8.txt', slope, k, R, v, n, Rsq_min, 0.80) * 1e-6;

% Conta il numero di NaN
numero_NaN = sum(isnan(Emap), 'all');
tot = length(Emap)^2;
fprintf('Numero di errori: %d. Successo: %.2f\n', numero_NaN, ((tot - numero_NaN) * 100 / tot) );

% Mostra l'immagine, la mappa e l'istogramma
figure;

% Carica la mappa delle z (è già in nm)
Hmap = load_height_map('./dati/exp111/img6.txt');
subplot(1, 3, 1);
add_height_map_to_figure(Hmap, L, 'nm', 'Height map of PS-LDPE-12M', bone);

subplot(1, 3, 2);
add_E_map_to_figure(Emap, L, 'MPa', 'Elastic modulus map of PS-LDPE-12M');

% Costruisci e mostra l'istogramma
bin_size = 50;

subplot(1, 3, 3);
grid on;
histogram(Emap, 'DisplayName', 'E', 'BinWidth', bin_size, 'Normalization', 'pdf');
xlabel('E [MPa]');
ylabel('pdf');
title('Elastic modulus distribution of the map of PS-LDPE-12M');

bin_size = 5;
figure;
grid on;
histogram(Emap, 'DisplayName', 'E', 'BinWidth', bin_size, 'Normalization', 'pdf');
xlabel('E [MPa]');
ylabel('pdf');
xlim([0, 200]);
title('Elastic modulus distribution of the map of PS-LDPE-12M - zoom');
