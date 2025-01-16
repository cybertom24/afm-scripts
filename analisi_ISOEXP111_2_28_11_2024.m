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
Rsq_min = 0.95;
b_start = 0.80;

% Impostazioni istogramma
bin_size = 100;
h_limits = [0 3000];
c_limits = [0 3000];

% Recupera la slope di calibrazione
[~, ~, z, Nf] = load_force_curve('./dati/exp111/curve60.txt');
slope = calculate_slope(z, Nf, max(z) * b_start, +Inf);

%% --- P1 (47; 64): img46, map48 ---

% Calcola la mappa, convertendo i valori in MPa
[Emap, ~, z, good_curves] = calculate_E_map('./dati/exp111/map88.txt', slope, k, R, v, n, Rsq_min, b_start);
Emap = Emap * 1e-6;
mean_curve_1 = mean(good_curves);

% Conta il numero di NaN
numero_NaN = sum(isnan(Emap), 'all');
tot = length(Emap)^2;
fprintf('Numero di errori: %d. Successo: %.2f\n', numero_NaN, ((tot - numero_NaN) * 100 / tot) );

% Mostra l'immagine, la mappa e l'istogramma
fig = figure;
fig.Position(3) = fig.Position(3) * 2; 
drawnow;
tiledlayout(1, 2);

% Carica la mappa delle z (già in nm)
Hmap = load_height_map('./dati/exp111/img86.txt');
nexttile;
add_height_map_to_figure(Hmap, L, 'nm', 'Height map of P_1', slanCM('heat'));

nexttile;
add_E_map_to_figure(Emap, 'L', L, 'um', 'MPa', 'title', 'Elastic modulus map of P_1', 'clim', c_limits);

% Costruisci e mostra l'istogramma
figure;
grid on;
histogram(Emap, 'DisplayName', 'E', 'BinWidth', bin_size, 'Normalization', 'count');
xlabel('E [MPa]');
ylabel('count');
title('E distribution of the map of P_1');
xlim(h_limits);

% h1 = histogram(Emap, 'DisplayName', 'E', 'BinWidth', bin_size, 'Normalization', 'count');
% Emap1 = Emap;

%% --- P2 (63; 61): img49, map50 ---

% Calcola la mappa, convertendo i valori in MPa
[Emap, ~, z, good_curves] = calculate_E_map('./dati/exp111/map91.txt', slope, k, R, v, n, Rsq_min, b_start);
Emap = Emap * 1e-6;
mean_curve_2 = mean(good_curves);

% Conta il numero di NaN
numero_NaN = sum(isnan(Emap), 'all');
tot = length(Emap)^2;
fprintf('Numero di errori: %d. Successo: %.2f\n', numero_NaN, ((tot - numero_NaN) * 100 / tot) );

fig = figure;
fig.Position(3) = fig.Position(3) * 2; 
drawnow;
tiledlayout(1, 2);

% Carica la mappa delle z (già in nm)
Hmap = load_height_map('./dati/exp111/img89.txt');
nexttile;
add_height_map_to_figure(Hmap, L, 'nm', 'Height map of P_2', slanCM('heat'));

nexttile;
add_E_map_to_figure(Emap, 'L', L, 'um', 'MPa', 'title', 'Elastic modulus map of P_2', 'clim', c_limits);

% Costruisci e mostra l'istogramma
figure;
grid on;
hold on;
histogram(Emap, 'DisplayName', 'E', 'BinWidth', bin_size, 'Normalization', 'count');
xlabel('E [MPa]');
ylabel('count');
title('E distribution of the map of P_2');
xlim(h_limits);

h2 = histogram(Emap, 'DisplayName', 'E', 'BinWidth', bin_size, 'Normalization', 'count', 'Visible', 'off');
Emap2 = Emap;

%% --- P3 (45; 50): img51, map53 ---

% Calcola la mappa, convertendo i valori in MPa
[Emap, ~, z, good_curves] = calculate_E_map('./dati/exp111/map94.txt', slope, k, R, v, n, Rsq_min, b_start);
Emap = Emap * 1e-6;
mean_curve_3 = mean(good_curves);

% Conta il numero di NaN
numero_NaN = sum(isnan(Emap), 'all');
tot = length(Emap)^2;
fprintf('Numero di errori: %d. Successo: %.2f\n', numero_NaN, ((tot - numero_NaN) * 100 / tot) );

fig = figure;
fig.Position(3) = fig.Position(3) * 2; 
drawnow;
tiledlayout(1, 2);

% Carica la mappa delle z (già in nm)
Hmap = load_height_map('./dati/exp111/img92.txt');
nexttile;
add_height_map_to_figure(Hmap, L, 'nm', 'Height map of P_3', slanCM('heat'));

nexttile;
add_E_map_to_figure(Emap, 'L', L, 'um', 'MPa', 'title', 'Elastic modulus map of P_3', 'clim', c_limits);

% Costruisci e mostra l'istogramma
figure;
grid on;
hold on;
histogram(Emap, 'DisplayName', 'E', 'BinWidth', bin_size, 'Normalization', 'count');
xlabel('E [MPa]');
ylabel('count');
title('E distribution of the map of P_3');
xlim(h_limits);

h3 = histogram(Emap, 'DisplayName', 'E', 'BinWidth', bin_size, 'Normalization', 'count', 'Visible', 'off');
Emap3 = Emap;

%% --- P4 (63; 61): img54, map55 ---

% Calcola la mappa, convertendo i valori in MPa
[Emap, ~, z, good_curves] = calculate_E_map('./dati/exp111/map97.txt', slope, k, R, v, n, Rsq_min, b_start);
Emap = Emap * 1e-6;
mean_curve_4 = mean(good_curves);

% Conta il numero di NaN
numero_NaN = sum(isnan(Emap), 'all');
tot = length(Emap)^2;
fprintf('Numero di errori: %d. Successo: %.2f\n', numero_NaN, ((tot - numero_NaN) * 100 / tot) );

fig = figure;
fig.Position(3) = fig.Position(3) * 2; 
drawnow;
tiledlayout(1, 2);

% Carica la mappa delle z convertendo in nm
Hmap = load_height_map('./dati/exp111/img95.txt') * 1e3;
nexttile;
add_height_map_to_figure(Hmap, L, 'nm', 'Height map of P_4', slanCM('heat'));

nexttile;
add_E_map_to_figure(Emap, 'L', L, 'um', 'MPa', 'title', 'Elastic modulus map of P_4', 'clim', c_limits);

% Costruisci e mostra l'istogramma
figure;
grid on;
hold on;
histogram(Emap, 'DisplayName', 'E', 'BinWidth', bin_size, 'Normalization', 'count');
xlabel('E [MPa]');
ylabel('count');
title('E distribution of the map of P_4');
xlim(h_limits);

h4 = histogram(Emap, 'DisplayName', 'E', 'BinWidth', bin_size, 'Normalization', 'count', 'Visible', 'off');
Emap4 = Emap;

%% --- Plotta le curve medie ---
figure;
grid on;
hold on;
legend show;
title('Mean force distance curves on ISO-EXP111');
xlabel('z [nm]');
ylabel('F [nN]');

z = z * 1e9;
plot(z, mean_curve_1 * k * 1e9, 'DisplayName', 'P_1');
plot(z, mean_curve_2 * k * 1e9, 'DisplayName', 'P_2');
plot(z, mean_curve_3 * k * 1e9, 'DisplayName', 'P_3');
plot(z, mean_curve_4 * k * 1e9, 'DisplayName', 'P_4');

%% --- Plotta l'istogramma completo ---

bin_centers = (min(h_limits) + bin_size/2):bin_size:(max(h_limits) - bin_size/2);

% Recupera i valori
values1 = h1.Values;
values2 = h2.Values;
values3 = h3.Values;
values4 = h4.Values;

% Aggiungi il padding se necessario
if length(values1) < length(bin_centers)
    values1 = [values1, zeros(1, length(bin_centers) - length(values1))];
end

if length(values2) < length(bin_centers)
    values2 = [values2, zeros(1, length(bin_centers) - length(values2))];
end

if length(values3) < length(bin_centers)
    values3 = [values3, zeros(1, length(bin_centers) - length(values3))];
end

if length(values4) < length(bin_centers)
    values4 = [values4, zeros(1, length(bin_centers) - length(values4))];
end

values = values1(1:length(bin_centers)) + values2(1:length(bin_centers)) + values3(1:length(bin_centers)) + values4(1:length(bin_centers));

figure;
grid on;
hold on;
title('E distribution across the maps');
xlabel('E [MPa]');
ylabel('count');
bar(bin_centers, values, 'hist');

%salva_mappa_come_vettore(Emap1, './output/analisi exp111/iso-exp111-P1-400pt-MPa-0.5Nm.csv');
%salva_mappa_come_vettore(Emap2, './output/analisi exp111/iso-exp111-P2-400pt-MPa-0.5Nm.csv');
%salva_mappa_come_vettore(Emap3, './output/analisi exp111/iso-exp111-P3-400pt-MPa-0.5Nm.csv');
%salva_mappa_come_vettore(Emap4, './output/analisi exp111/iso-exp111-P4-400pt-MPa-0.5Nm.csv');
% salva_mappa_come_vettore([Emap1, Emap2, Emap3, Emap4], './output/csv/iso-exp111-1600pt-MPa.csv');