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

% Calcola la mappa, convertendo i valori in MPa
Emap = calculate_E_map('./dati/exp84-tesi/map60.txt', slope_ISO, k, R, 0.22, n, Rsq_min, 0.80);
Emap = Emap * 1e-6;
salva_mappa_come_vettore(Emap, './output/csv/psldpe-exp84-5Nm-400pt-MPa.csv');

% Conta il numero di NaN
numero_NaN = sum(isnan(Emap), 'all');
tot = length(Emap)^2;
fprintf('Numero di errori: %d. Successo: %.2f\n', numero_NaN, ((tot - numero_NaN) * 100 / tot) );

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
add_E_map_to_figure(Emap, 'L', L, 'um', 'MPa', 'title', 'Elastic modulus map - PS-LDPE');

% Mostra l'istogramma
figure;
grid on;
hold on;
legend show;
title('E distribution of PS-LDPE');
xlabel('E [MPa]');
ylabel('pdf');
histogram(Emap, 'DisplayName', 'E', 'BinWidth', bin_size, 'Normalization', 'pdf');

%% ISO

% Calcola la mappa, convertendo i valori in MPa
[Emap, ~, z_ISO, good_curves] = calculate_E_map('./dati/exp84-tesi/map74.txt', slope_ISO, k, R, v, n, Rsq_min, 0.80);
Emap = Emap * 1e-6;
salva_mappa_come_vettore(Emap, './output/csv/iso-exp85-400pt-MPa.csv');
mean_curve_ISO = mean(good_curves);

% Conta il numero di NaN
numero_NaN = sum(isnan(Emap), 'all');
tot = length(Emap)^2;
fprintf('Numero di errori: %d. Successo: %.2f\n', numero_NaN, ((tot - numero_NaN) * 100 / tot) );

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

% Costruisci l'istogramma
h_ISO = histogram(Emap, 'DisplayName', 'E', 'BinWidth', bin_size, 'Normalization', 'pdf', 'Visible', 'off');

%% ACM

% Calcola la mappa, convertendo i valori in MPa
[Emap, ~, z_ACM, good_curves] = calculate_E_map('./dati/exp84-tesi/map93.txt', slope_ACM, k, R, v, n, Rsq_min, 0.80);
Emap = Emap * 1e-6;
salva_mappa_come_vettore(Emap, './output/csv/acm-exp84-400pt-MPa.csv');
mean_curve_ACM = mean(good_curves);

% Conta il numero di NaN
numero_NaN = sum(isnan(Emap), 'all');
tot = length(Emap)^2;
fprintf('Numero di errori: %d. Successo: %.2f\n', numero_NaN, ((tot - numero_NaN) * 100 / tot) );

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

% Costruisci l'istogramma
h_ACM = histogram(Emap, 'DisplayName', 'E', 'BinWidth', bin_size, 'Normalization', 'count', 'Visible', 'off');

%% --- Plotta le curve medie ---
figure;
grid on;
hold on;
legend show;
title('Mean force distance curves - ISO vs ACM');
xlabel('z [nm]');
ylabel('F [nN]');

z_ACM = z_ACM * 1e9;
z_ISO = z_ISO * 1e9;

plot(z_ISO, mean_curve_ISO * k * 1e9, 'DisplayName', 'ISO', 'LineWidth', 2);
plot(z_ACM, mean_curve_ACM * k * 1e9, 'DisplayName', 'ACM', 'LineWidth', 2);

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
ylabel('pdf');
bar(bin_centers, values_ISO(1:length(bin_centers)), 'DisplayName', 'ISO', 'FaceAlpha', 0.65);
bar(bin_centers, values_ACM(1:length(bin_centers)), 'DisplayName', 'ACM', 'FaceAlpha', 0.65);