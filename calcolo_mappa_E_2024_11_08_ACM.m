clc;
close all;
clear;

addpath './funzioni/';

% Caratteristiche punta e materiale
k = 0.5;
R = 35e-9;
v = 0.22;

% Caratteristica mappa
L = 2;

% Recupera la slope di calibrazione
[~, slope] = calibra('./dati/zaffiro-2024_11_08-1001pt-10x.txt');

% Calcola la mappa
Emap = calcola_mappa_E_fitting('./dati/map68.txt', slope, k, R, v, 15, 50);
% Rendi in MPa
Emap = Emap / 1e6;
% Prima di mostrarla pero' ribalta le y
% Flippandola up-down (al posto di left right)

% Conta prima il numero di NaN
numero_NaN = sum(isnan(Emap), 'all');
tot = length(Emap)^2;
fprintf('Numero di errori: %d. Successo: %.2f\n', numero_NaN, ((tot - numero_NaN) * 100 / tot) );

% Crea gli assi x e y
n_pixel = length(Emap);
l_pixel = L / n_pixel;
x = linspace(l_pixel / 2, L - l_pixel / 2, n_pixel);
y = linspace(l_pixel / 2, L - l_pixel / 2, n_pixel);

%%
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
% Imposta come scala quella logaritmica
% set(gca,'ColorScale','log'); 
xlabel('x [{\mu}m]');
ylabel('y [{\mu}m]');
%clabel('E [MPa]');
title('Mappa del modulo elastico del campione ACM-EXP84');
ylabel(cb, 'E [MPa]'); % Imposta la label della colorbar
xticks(0:0.25:L);
yticks(0:0.25:L);

%% --- Istogramma per il substrato LDPE ---
E_lim = 15;
bin_size = 20;

figure;
hold on;
grid on;
histogram(Emap, 'DisplayName', 'E', 'BinWidth', bin_size, 'Normalization', 'pdf');
xlabel('E [MPa]');
ylabel('pdf []');
title('Distribuzione del modulo elastico');

% Quindi con E < E_lim
bin_size = 1;
Emap_ldpe = Emap(Emap < E_lim);
Emap_ldpe = Emap_ldpe(:);

figure;
hold on;
grid on;
legend show;
h = histogram(Emap_ldpe, 'DisplayName', 'E - LDPE', 'BinWidth', bin_size, 'Normalization', 'pdf');
xlabel('E [MPa]');
%ylabel('pdf []');
title('Distribuzione del modulo elastico LDPE');

%% --- Istogramma per il substrato PS ---
% Quindi con E >= E_lim
bin_size = 20;
Emap_ps = Emap((Emap >= E_lim) & (Emap < 6500));
Emap_ps = Emap_ps(:);

figure;
hold on;
grid on;
legend show;
h = histogram(Emap_ps, 'DisplayName', 'E - PS', 'BinWidth', bin_size, 'Normalization', 'pdf');
xlabel('E [MPa]');
%ylabel('pdf');
title('Distribuzione del modulo elastico PS');