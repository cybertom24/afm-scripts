clc;
close all;
clear;

addpath ./funzioni
addpath ./app/functions/
addpath ./more-colormaps/

set(0, 'DefaultAxesFontSize', 14);
set(0, 'DefaultTextFontSize', 14);

out_dir = './output/exp84-tesi';

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
% bin_size = (h_limits(2) - h_limits(1)) / 50;
bin_size = 100;

% Recupera la slope di calibrazione
[~, ~, z, Nf] = load_force_curve('./dati/exp84-tesi/curve-sapphire-ACM.txt');
slope_ACM = calculate_slope(z, Nf, max(z) * b_start, +Inf);

[~, ~, z, Nf] = load_force_curve('./dati/exp84-tesi/curve-sapphire-ISO.txt');
slope_ISO = calculate_slope(z, Nf, max(z) * b_start, +Inf);

%% Calibrazione

% Calcola la mappa, convertendo i valori in MPa
Emap = calculate_E_map('./dati/exp84-tesi/map60.txt', slope_ISO, k, R, 0.22, n, Rsq_min, b_start) * 1e-6;
name = salva_Emap(Emap, out_dir, k, R, 0.22, n, Rsq_min, b_start, 'L', L, 'um', 'MPa', 'name', 'calib exp84-tesi');

% Mostra l'immagine, la mappa e l'istogramma
fig = figure;
fig.Position(3) = fig.Position(3) * 2; 
drawnow;
tiledlayout(1, 2);

% Carica la mappa delle z convertendo in nm
Hmap = load_height_map('./dati/exp84-tesi/scan59.txt');
nexttile;
add_height_map_to_figure(Hmap, L, 'nm', 'Height map - PS-LDPE', slanCM('heat'));

nexttile;
hold on;
add_E_map_to_figure(Emap, 'L', L, 'um', 'MPa', 'title', 'Elastic modulus map - PS-LDPE', 'clim', h_limits);

salva_figure(gcf, out_dir, ['maps ' name]);

% Mostra l'istogramma
figure;
grid on;
hold on;
legend show;
title('E distribution of PS-LDPE');
xlabel('E [MPa]');
ylabel('count');
histogram(Emap, 'DisplayName', 'E', 'BinWidth', bin_size, 'Normalization', 'count');
xlim(h_limits);
salva_figure(gcf, out_dir, ['hist ' name]);

%% ISO

% Calcola la mappa, convertendo i valori in MPa
Emap = calculate_E_map('./dati/exp84-tesi/map74.txt', slope_ISO, k, R, v, n, Rsq_min, b_start) * 1e-6;
name = salva_Emap(Emap, out_dir, k, R, v, n, Rsq_min, b_start, 'L', L, 'um', 'MPa', 'name', 'iso exp84-tesi');

% Mostra l'immagine, la mappa e l'istogramma
fig = figure;
fig.Position(3) = fig.Position(3) * 2; 
drawnow;
tiledlayout(1, 2);

% Carica la mappa delle z convertendo in nm
Hmap = load_height_map('./dati/exp84-tesi/scan72.txt');
nexttile;
add_height_map_to_figure(Hmap, L, 'nm', 'Height map - ISO', slanCM('heat'));

nexttile;
hold on;
add_E_map_to_figure(Emap, 'L', L, 'um', 'MPa', 'title', 'Elastic modulus map - ISO', 'clim', h_limits);

salva_figure(gcf, out_dir, ['maps ' name]);

% Costruisci l'istogramma
h_ISO = histogram(Emap, 'DisplayName', 'E', 'BinWidth', bin_size, 'Normalization', 'count', 'Visible', 'off');

%% ACM

% Calcola la mappa, convertendo i valori in MPa
Emap = calculate_E_map('./dati/exp84-tesi/map93.txt', slope_ACM, k, R, v, n, Rsq_min, b_start) * 1e-6;
name = salva_Emap(Emap, out_dir, k, R, v, n, Rsq_min, b_start, 'L', L, 'um', 'MPa', 'name', 'acm exp84-tesi');

% Mostra l'immagine, la mappa e l'istogramma
fig = figure;
fig.Position(3) = fig.Position(3) * 2; 
drawnow;
tiledlayout(1, 2);

% Carica la mappa delle z convertendo in nm
Hmap = load_height_map('./dati/exp84-tesi/scan92.txt');
nexttile;
add_height_map_to_figure(Hmap, L, 'nm', 'Height map - ACM 92', slanCM('heat'));

nexttile;
hold on;
add_E_map_to_figure(Emap, 'L', L, 'um', 'MPa', 'title', 'Elastic modulus map - ACM 93', 'clim',  h_limits);

salva_figure(gcf, out_dir, ['maps ' name]);

% Costruisci l'istogramma
h_ACM = histogram(Emap, 'DisplayName', 'E', 'BinWidth', bin_size, 'Normalization', 'count', 'Visible', 'off');

%% --- Plotta i due istogrammi ---
bin_centers = (min(h_limits) + bin_size/2):bin_size:(max(h_limits) - bin_size/2);

% Recupera i valori
values_ACM = h_ACM.Values;
values_ISO = h_ISO.Values;

% Aggiungi il padding se necessario
if length(values_ACM) < length(bin_centers)
    values_ACM = [values_ACM, zeros(1, length(bin_centers) - length(values_ACM))];
end

if length(values_ISO) < length(bin_centers)
    values_ISO = [values_ISO, zeros(1, length(bin_centers) - length(values_ISO))];
end

figure;
grid on;
hold on;
legend show;
title('E distributions - ISO vs ACM');
xlabel('E [MPa]');
ylabel('count');
bar(bin_centers, values_ISO(1:length(bin_centers)), 'DisplayName', 'ISO', 'FaceAlpha', 0.65);
bar(bin_centers, values_ACM(1:length(bin_centers)), 'DisplayName', 'ACM', 'FaceAlpha', 0.65);

salva_figure(gcf, out_dir, 'hist acm + iso');