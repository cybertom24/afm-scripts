clc;
clear;
close all;

addpath './funzioni/';

[~, slope] = calibra('./dati/curva-zaffiro-12_07_2024-s1000.txt');

% Caratteristiche punta e materiale
k = 3.38;  % N/m
R = 30e-9;  % nm
v = 0.5;
name = 'ACM';
file = 'C:\Users\savol\Documents\Università\Tesi\Dati\AFM\mappa_ACM_map93.txt';

% Calcola la mappa
[Emap, uEmap] = calcola_mappa_E(file, slope, k, R, v);
% Rendi in MPa
Emap = Emap * 1e-6;

% Conta quanti errori ci sono stati
numero_NaN = sum(isnan(Emap), 'all');
tot = length(Emap)^2;
fprintf('%s: Numero di errori: %d. Successo: %.2f\n', name, numero_NaN, ((tot - numero_NaN) * 100 / tot) );

% Crea gli assi x e y
n_pixel = length(Emap);
l_pixel = 2 / n_pixel;
max_xy = 2;
x = linspace(l_pixel / 2, max_xy - l_pixel / 2, n_pixel);
y = linspace(l_pixel / 2, max_xy - l_pixel / 2, n_pixel);

% Mostra la mappa
figure;
img = imagesc(x, y, Emap); % Indica gli assi prima della matrice

% Imposta a direzione dell'asse verticale come dal basso verso l'alto 
% Non è più necessario flippare l'immagine
set(gca, 'YDir', 'normal');
colormap(jet);
% cb = colorbar;

% Impostare il colore di sfondo a grigio
set(gca, 'Color', [0.65 0.65 0.65]); % Colore grigio (RGB [0.5, 0.5, 0.5])
% Rendi i NaN trasparenti
set(img, 'AlphaData', ~isnan(Emap)); % Alpha 1 per i valori, 0 per i NaN

axis image;

clim([0, 4000]);

%title(['Mappa del modulo elastico del campione ' name]);
%xlabel('x [{\mu}m]');
%ylabel('y [{\mu}m]');
%ylabel(cb, 'E [MPa]'); % Imposta la label della colorbar

%xticks(0:0.25:max_xy);
%yticks(0:0.25:max_xy);

set(gca, 'YColor', 'none');
set(gca, 'XColor', 'none');
