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
v = 0.22;   % []

% Caratteristiche mappa
L = 2;      % [um]

% Impostazioni fitting
n = 12;
Rsq_min = 0.95;
b_start = 0.80;

c_limits = [0 3000];

% Recupera la slope di calibrazione
[~, ~, z, Nf] = load_force_curve('./dati/exp111/curve3.txt');
slope = calculate_slope(z, Nf, max(z) * b_start, +Inf);

% Calcola la mappa, convertendo i valori in MPa
Emap = calculate_E_map('./dati/exp111/map8.txt', slope, k, R, v, n, Rsq_min, b_start) * 1e-6;
% salva_mappa_come_vettore(Emap, './output/csv/psldpe-exp111-0_5Nm-400pt-MPa.csv');

% Conta il numero di NaN
numero_NaN = sum(isnan(Emap), 'all');
tot = length(Emap)^2;
fprintf('Numero di errori: %d. Successo: %.2f\n', numero_NaN, ((tot - numero_NaN) * 100 / tot) );

% Mostra l'immagine, la mappa e l'istogramma
fig = figure;
fig.Position(3) = fig.Position(3) * 2; 
drawnow;
tiledlayout(1, 2); % Due subplot affiancati

% Carica la mappa delle z (è già in nm)
nexttile;
Hmap = load_height_map('./dati/exp111/img6.txt');
add_height_map_to_figure(Hmap, L, 'nm', 'Height map', slanCM('heat'));

nexttile;
add_E_map_to_figure(Emap, 'L', L, 'um', 'MPa', 'title', 'Elastic modulus map', 'clim', c_limits);

% Costruisci e mostra l'istogramma
bin_size = 50;

fig = figure;
fig.Position(3) = fig.Position(3) * 2;
tiledlayout(1, 2);

nexttile;
grid on;
histogram(Emap, 'DisplayName', 'E', 'BinWidth', bin_size, 'Normalization', 'count');
xlabel('E [MPa]');
ylabel('count');
title('Elastic modulus distribution');
xlim(c_limits);

bin_size = 5;

nexttile;
grid on;
histogram(Emap, 'DisplayName', 'E', 'BinWidth', bin_size, 'Normalization', 'count');
xlabel('E [MPa]');
ylabel('count');
xlim([0, 200]);
title('Elastic modulus distribution zoomed in');
