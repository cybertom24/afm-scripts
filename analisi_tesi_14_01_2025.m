clc;
close all;
clear;

addpath ./funzioni
addpath ./app/functions/
addpath ./more-colormaps/

set(0, 'DefaultAxesFontSize', 14);
set(0, 'DefaultTextFontSize', 14);

% Caratteristiche punta e materiale
k = 4.5;      % [N/m]
R = 35e-9;  % [m]
v = 0.5;    % []

% Caratteristiche mappa
L = 2;      % [um]

% Impostazioni fitting
n = 2;
Rsq_min = 0.95;
b_start = 0.80;

% Impostazioni istogramma
h_limits = [0 3000];
bin_size = (h_limits(2) - h_limits(1)) / 50;

% Recupera la slope di calibrazione
[~, ~, z, Nf] = load_force_curve('./dati/exp84-tesi/curve-sapphire-ACM.txt');
slope_ACM = calculate_slope(z, Nf, max(z) * b_start, +Inf);

[~, ~, z, Nf] = load_force_curve('./dati/exp84-tesi/curve-sapphire-ISO.txt');
slope_ISO = calculate_slope(z, Nf, max(z) * b_start, +Inf);

%% Calibrazione

Emap = calculate_E_map('./dati/exp84-tesi/map60.txt', slope_ISO, k, R, 0.22, n, Rsq_min, b_start) * 1e-6;

fig = figure;
fig.Position(1) = 0;
fig.Position(2) = 0;
fig.Position(3) = 2 * fig.Position(3);
fig.Position(4) = 2 * fig.Position(4);
drawnow;
tiledlayout(2, 2);

% Carica la mappa delle z convertendo in nm
Hmap = load_height_map('./dati/exp84-tesi/scan59.txt');
nexttile;
add_height_map_to_figure(Hmap, L, 'nm', 'Height map - PS-LDPE', slanCM('heat'));

nexttile;
add_E_map_to_figure(Emap, 'L', L, 'um', 'MPa', 'title', 'Elastic modulus map - PS-LDPE', 'clim', h_limits);

nexttile;
grid on;
hold on;
axis square;
legend show;
title('E distribution of PS-LDPE');
xlabel('E [MPa]');
ylabel('count');
histogram(Emap, 'DisplayName', 'E', 'BinWidth', bin_size, 'Normalization', 'count');

%% ISO

% 72-74
Emap = calculate_E_map('./dati/exp84-tesi/map74.txt', slope_ISO, k, R, v, n, Rsq_min, b_start) * 1e-6;

fig = figure;
fig.Position(1) = 0;
fig.Position(2) = 0;
fig.Position(3) = 2 * fig.Position(3);
fig.Position(4) = 2 * fig.Position(4);
drawnow;
tiledlayout(2, 2);

% Carica la mappa delle z convertendo in nm
Hmap = load_height_map('./dati/exp84-tesi/scan72.txt');
nexttile;
add_height_map_to_figure(Hmap, L, 'nm', 'Height map - ISO (72)', slanCM('heat'));

nexttile;
add_E_map_to_figure(Emap, 'L', L, 'um', 'MPa', 'title', 'Elastic modulus map - ISO (74)', 'clim', h_limits);

nexttile;
grid on;
hold on;
axis square;
legend show;
title('E distribution of ISO (74)');
xlabel('E [MPa]');
ylabel('count');
histogram(Emap, 'DisplayName', 'E', 'BinWidth', bin_size, 'Normalization', 'count');
xlim(h_limits);

% 77 - 79, 80, 81
Emap79 = calculate_E_map('./dati/exp84-tesi/map79.txt', slope_ISO, k, R, v, n, Rsq_min, b_start) * 1e-6;
Emap80 = calculate_E_map('./dati/exp84-tesi/map80.txt', slope_ISO, k, R, v, n, Rsq_min, b_start) * 1e-6;
Emap81 = calculate_E_map('./dati/exp84-tesi/map81.txt', slope_ISO, k, R, v, n, Rsq_min, b_start) * 1e-6;

fig = figure;
fig.Position(1) = 0;
fig.Position(2) = 0;
fig.Position(3) = 2 * fig.Position(3);
fig.Position(4) = 2 * fig.Position(4);
drawnow;
tiledlayout(2, 2);

% Carica la mappa delle z convertendo in nm
Hmap = load_height_map('./dati/exp84-tesi/scan77.txt');
nexttile;
add_height_map_to_figure(Hmap, L, 'nm', 'Height map - ISO (77)', slanCM('heat'));

nexttile;
add_E_map_to_figure(Emap79, 'L', L, 'um', 'MPa', 'title', 'Elastic modulus map - ISO (79)', 'clim', h_limits);

nexttile;
add_E_map_to_figure(Emap80, 'L', L, 'um', 'MPa', 'title', 'Elastic modulus map - ISO (80)', 'clim', h_limits);

nexttile;
grid on;
hold on;
axis square;
legend show;
title('E distribution of ISO (79, 80, 81)');
xlabel('E [MPa]');
ylabel('count');
histogram(Emap79, 'DisplayName', 'E 79', 'BinWidth', bin_size, 'Normalization', 'count');
histogram(Emap80, 'DisplayName', 'E 80', 'BinWidth', bin_size, 'Normalization', 'count');
histogram(Emap81, 'DisplayName', 'E 81', 'BinWidth', bin_size, 'Normalization', 'count');
xlim(h_limits);

figure;
add_E_map_to_figure(Emap81, 'L', L, 'um', 'MPa', 'title', 'Elastic modulus map - ISO (81)', 'clim', h_limits);

%% ACM

% 92-93
Emap = calculate_E_map('./dati/exp84-tesi/map93.txt', slope_ACM, k, R, v, n, Rsq_min, b_start) * 1e-6;

fig = figure;
fig.Position(1) = 0;
fig.Position(2) = 0;
fig.Position(3) = 2 * fig.Position(3);
fig.Position(4) = 2 * fig.Position(4); 
drawnow;
tiledlayout(2, 2);

% Carica la mappa delle z convertendo in nm
Hmap = load_height_map('./dati/exp84-tesi/scan92.txt');
nexttile;
add_height_map_to_figure(Hmap, L, 'nm', 'Height map - ACM (92)', slanCM('heat'));

nexttile;
add_E_map_to_figure(Emap, 'L', L, 'um', 'MPa', 'title', 'Elastic modulus map - ACM (93)', 'clim',  h_limits);

nexttile
grid on;
hold on;
axis square;
legend show;
title('E distribution of ACM (93)');
xlabel('E [MPa]');
ylabel('count');
histogram(Emap, 'DisplayName', 'E', 'BinWidth', bin_size, 'Normalization', 'count');
xlim(h_limits);

% 89 - 90,91
Emap90 = calculate_E_map('./dati/exp84-tesi/map90.txt', slope_ACM, k, R, v, n, Rsq_min, b_start) * 1e-6;
Emap91 = calculate_E_map('./dati/exp84-tesi/map91.txt', slope_ACM, k, R, v, n, Rsq_min, b_start) * 1e-6;

fig = figure;
fig.Position(1) = 0;
fig.Position(2) = 0;
fig.Position(3) = 2 * fig.Position(3);
fig.Position(4) = 2 * fig.Position(4); 
drawnow;
tiledlayout(2, 2);

% Carica la mappa delle z convertendo in nm
Hmap = load_height_map('./dati/exp84-tesi/scan89.txt');
nexttile;
add_height_map_to_figure(Hmap, L, 'nm', 'Height map - ACM (89)', slanCM('heat'));

nexttile;
add_E_map_to_figure(Emap90, 'L', L, 'um', 'MPa', 'title', 'Elastic modulus map - ACM (90)', 'clim',  h_limits);

nexttile;
add_E_map_to_figure(Emap91, 'L', L, 'um', 'MPa', 'title', 'Elastic modulus map - ACM (91)', 'clim',  h_limits);

nexttile
grid on;
hold on;
axis square;
legend show;
title('E distribution of ACM (90,91)');
xlabel('E [MPa]');
ylabel('count');
histogram(Emap90, 'DisplayName', 'E 90', 'BinWidth', bin_size, 'Normalization', 'count');
histogram(Emap91, 'DisplayName', 'E 91', 'BinWidth', bin_size, 'Normalization', 'count');
xlim(h_limits);