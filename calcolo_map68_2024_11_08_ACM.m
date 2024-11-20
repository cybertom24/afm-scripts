%% --- Calcola modulo elastico ---

clc;
close all;
clear;

addpath './funzioni/';

% Caratteristiche punta e materiale
% k = 2.3;
% R = 8e-9;
% v = 0.5;
k = 0.5;
R = 35e-9;
v = 0.22;

% Impostazioni fitting
n = 15;
%p = 25;
Rsq_min = 0.99;

% Recupera la slope di calibrazione
[~, slope] = calibra('./dati/zaffiro-2024_11_08-ACM.txt');

% Calcola la mappa
% Emap = calcola_mappa_E_fitting('./dati/map68.txt', slope, k, R, v, n, p);
Emap = calcola_mappa_E_intervallo('./dati/map68.txt', slope, k, R, v, n, Rsq_min);
% Rendi in MPa
Emap = Emap / 1e6;
% Prima di mostrarla pero' ribalta le y
% Flippandola up-down (al posto di left right)

% Conta prima il numero di NaN
numero_NaN = sum(isnan(Emap), 'all');
tot = length(Emap)^2;
fprintf('Numero di errori: %d. Successo: %.2f\n', numero_NaN, ((tot - numero_NaN) * 100 / tot) );

%% --- Genera mappa del modulo elastico ---

% Caratteristica mappa
L = 2;

% Crea gli assi x e y
n_pixel = length(Emap);
l_pixel = L / n_pixel;
x = linspace(l_pixel / 2, L - l_pixel / 2, n_pixel);
y = linspace(l_pixel / 2, L - l_pixel / 2, n_pixel);

figure;
imagesc(x, y, Emap); % Indica gli assi prima della matrice
axis image; % imposta l'aspect ratio giusto
%set(gca, 'Units', 'pixels', 'Position', [100 100 400 400]); % [left, bottom, width, height]   imposta la dimensione a 400x400 px
% Imposta a direzione dell'asse verticale come dal basso verso l'alto 
% Non è più necessario flippare l'immagine
set(gca, 'YDir', 'normal');
colormap(jet);
cb = colorbar;
% clim([0, 4000]);
xlabel('x [{\mu}m]');
ylabel('y [{\mu}m]');
ylabel(cb, 'E [MPa]'); % Imposta la label della colorbar
title('Mappa del modulo elastico del campione ACM-EXP84');
xticks(0:0.25:L);
yticks(0:0.25:L);

% Impostare il colore di sfondo a grigio
set(gca, 'Color', [0.65 0.65 0.65]); % Colore grigio (RGB [0.5, 0.5, 0.5])
% Rendi i NaN trasparenti
set(img, 'AlphaData', ~isnan(Emap)); % Alpha 1 per i valori, 0 per i NaN

%% --- Distribuzione della mappa ---

bin_size = 50;

figure;
hold on;
grid on;
histogram(Emap, 'DisplayName', 'E', 'BinWidth', bin_size, 'Normalization', 'pdf');
xlabel('E [MPa]');
ylabel('pdf');
title('Distribuzione del modulo elastico');