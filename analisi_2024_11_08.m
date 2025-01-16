clc;
close all;
clear;

addpath ./funzioni
addpath ./app/functions/
addpath ./more-colormaps/

set(0, 'DefaultAxesFontSize', 14);
set(0, 'DefaultTextFontSize', 14);

% Caratteristiche punta e materiale
k = 2.3;    % [N/m]
R = 17e-9;  % [m]
v = 0.5;    % []

% Impostazioni fitting
n = 15;
Rsq_min = 0.95;
b_start = 0.80;

% Recupera la slope di calibrazione
[~, ~, z, Nf] = load_force_curve('./dati/exp84/zaffiro-2024_11_08-ACM.txt');
slope = calculate_slope(z, Nf, max(z) * 0.80, +Inf);

%% --- ACM EXP84 ---

% Calcola la mappa, convertendo i valori in MPa
Emap = calculate_E_map('./dati/exp84/map68.txt', slope, k, R, v, n, Rsq_min, 0.80);
Emap = Emap * 1e-6;

% Conta il numero di NaN
numero_NaN = sum(isnan(Emap), 'all');
tot = length(Emap)^2;
fprintf('Numero di errori: %d. Successo: %.2f\n', numero_NaN, ((tot - numero_NaN) * 100 / tot) );

% Mostra l'immagine, la mappa e l'istogramma
figure;
tiledlayout(1, 2);

% Carica la mappa delle z convertendo in nm
Hmap = load_height_map('./dati/exp84/img66.txt');
nexttile;
add_height_map_to_figure(Hmap, 2, 'nm', 'Height map 2x2 {\mu}m^2', slanCM('heat'));

nexttile;
add_E_map_to_figure(Emap, 2, 'MPa', 'Elastic modulus map 2x2 {\mu}m^2');
clim([0 prctile(Emap(:), 99)]);

% ---

% Calcola la mappa, convertendo i valori in MPa
Emap = calculate_E_map('./dati/exp84/map71.txt', slope, k, R, v, n, Rsq_min, 0.80);
Emap = Emap * 1e-6;

% Conta il numero di NaN
numero_NaN = sum(isnan(Emap), 'all');
tot = length(Emap)^2;
fprintf('Numero di errori: %d. Successo: %.2f\n', numero_NaN, ((tot - numero_NaN) * 100 / tot) );

% Mostra l'immagine, la mappa e l'istogramma
figure;
tiledlayout(1, 2);

% Carica la mappa delle z convertendo in nm
Hmap = load_height_map('./dati/exp84/img69.txt') * 1e3;
nexttile;
add_height_map_to_figure(Hmap, 10, 'nm', 'Height map 10x10 {\mu}m^2', slanCM('heat'));

nexttile;
add_E_map_to_figure(Emap, 10, 'MPa', 'Elastic modulus map 10x10 {\mu}m^2');
clim([0 prctile(Emap(:), 99)]);

%% --- ISO EXP85 ---

% Calcola la mappa, convertendo i valori in MPa
Emap = calculate_E_map('./dati/exp84/map76.txt', slope, k, R, v, n, Rsq_min, 0.80);
Emap = Emap * 1e-6;

% Conta il numero di NaN
numero_NaN = sum(isnan(Emap), 'all');
tot = length(Emap)^2;
fprintf('Numero di errori: %d. Successo: %.2f\n', numero_NaN, ((tot - numero_NaN) * 100 / tot) );

% Mostra l'immagine, la mappa e l'istogramma
figure;
tiledlayout(1, 2);

% Carica la mappa delle z convertendo in nm
Hmap = load_height_map('./dati/exp84/img75.txt') * 1e3;
nexttile;
add_height_map_to_figure(Hmap, 2, 'nm', 'Height map 2x2 {\mu}m^2', slanCM('heat'));

nexttile;
add_E_map_to_figure(Emap, 2, 'MPa', 'Elastic modulus map 2x2 {\mu}m^2');
clim([0 prctile(Emap(:), 99)]);

% ---

% Calcola la mappa, convertendo i valori in MPa
Emap = calculate_E_map('./dati/exp84/map79.txt', slope, k, R, v, n, Rsq_min, 0.80);
Emap = Emap * 1e-6;

% Conta il numero di NaN
numero_NaN = sum(isnan(Emap), 'all');
tot = length(Emap)^2;
fprintf('Numero di errori: %d. Successo: %.2f\n', numero_NaN, ((tot - numero_NaN) * 100 / tot) );

% Mostra l'immagine, la mappa e l'istogramma
figure;
tiledlayout(1, 2);

% Carica la mappa delle z convertendo in nm
Hmap = load_height_map('./dati/exp84/img77.txt') * 1e3;
nexttile;
add_height_map_to_figure(Hmap, 10, 'nm', 'Height map 10x10 {\mu}m^2', slanCM('heat'));

nexttile;
add_E_map_to_figure(Emap, 10, 'MPa', 'Elastic modulus map 10x10 {\mu}m^2');
clim([0 prctile(Emap(:), 99)]);