clc;
% close all;
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
Rsq_min = 0.90;
b_start = 0.80;

% Impostazioni istogramma
bin_size = 100;
h_limits = [0 3000];
c_limits = [0 3000];

% Recupera la slope di calibrazione
[~, ~, z, Nf] = load_force_curve('./dati/exp111/curve29.txt');
slope = calculate_slope(z, Nf, max(z) * b_start, +Inf);

% Calcola la mappa, convertendo i valori in MPa
Emap = calculate_E_map('./dati/exp111/map48.txt', slope, k, R, v, n, Rsq_min, b_start) * 1e-6;
name = salva_Emap(Emap, './output/test', k, R, v, n, Rsq_min, b_start, 'L', L, 'um', 'MPa', 'name', 'acm exp111 p1');

% Mostra l'immagine, la mappa e l'istogramma
fig = figure;
fig.Position(3) = fig.Position(3) * 2; 
drawnow;
tiledlayout(1, 2);

% Carica la mappa delle z convertendo in nm
Hmap = load_height_map('./dati/exp111/img46.txt') * 1e3;
nexttile;
add_height_map_to_figure(Hmap, L, 'nm', 'Height map of P_1', slanCM('heat'));

nexttile;
add_E_map_to_figure(Emap, 'L', L, 'um', 'MPa', 'title', 'Elastic modulus map of P_1', 'clim', c_limits);

salva_figure(gcf, './output/test', ['maps ' name]);

% Costruisci e mostra l'istogramma
figure;
grid on;
hold on;
histogram(Emap, 'DisplayName', 'E', 'BinWidth', bin_size, 'Normalization', 'count');
xlabel('E [MPa]');
ylabel('count');
title('E distribution of the map of P_1');
xlim(h_limits);

salva_figure(gcf, './output/test', ['hist ' name]);