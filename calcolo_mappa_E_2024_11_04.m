clc;
close all;
clear;

addpath './funzioni/';

% Caratteristiche punta e materiale
k = 0.5;
R = 35e-9;
v = 0.22;
n = 15;
p = 25;

% Caratteristica mappa
L = 2;

% Recupera la slope di calibrazione
[~, slope] = calibra('./dati/zaffiro_DZ_2024_10_25_801pt_4mspt_5x.txt');
%[~, slope] = calibra('./dati/zaffiro-2024_10_31-1001pt-5x.txt');


% Calcola la mappa
Emap = calcola_mappa_E_fitting('./dati/map29.txt', slope, k, R, v, n, p);
%Emap = calcola_mappa_E_fitting('./dati/map48.txt', slope, k, R, v, n, p);
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

figure;
imagesc(x, y, Emap); % Indica gli assi prima della matrice
axis image; % imposta l'aspect ratio giusto
%set(gca, 'Units', 'pixels', 'Position', [100 100 400 400]); % [left, bottom, width, height]   imposta la dimensione a 400x400 px
% Imposta a direzione dell'asse verticale come dal basso verso l'alto 
% Non è più necessario flippare l'immagine
set(gca, 'YDir', 'normal');
colormap(jet);
cb = colorbar;
%clim([0, 4000]);
% Imposta come scala quella logaritmica
set(gca,'ColorScale','log'); 
xlabel('x [{\mu}m]');
ylabel('y [{\mu}m]');
%clabel('E [MPa]');
title('Mappa del modulo elastico del campione PS-LDPE-12M');
ylabel(cb, 'E [MPa]'); % Imposta la label della colorbar
xticks(0:0.25:L);
yticks(0:0.25:L);

%{
% Ricrea l'immagine e salvala
figure;
img = imagesc(x, y, Emap); % Indica gli assi prima della matrice
axis image; % imposta l'aspect ratio giusto
set(gca, 'YDir', 'normal');
cmap = colormap(jet);
clim([0, 4000]);
set(gca,'XTick',[]); % Remove the ticks in the x axis
set(gca,'YTick',[]); % Remove the ticks in the y axis
set(gca,'Position',[0 0 1 1]); % Make the axes occupy the hole figure
saveas(gcf,'mappa-E-psldpe','png');
%}

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

%{
val = h.Values;
n = val * 0;
edges = h.BinEdges;

for i = 1:1:length(n)
   n(i) = (edges(i) + edges(i+1)) / 2; 
end

%scatter(n, val, 'DisplayName', 'Punti istogramma');

% Fitta con curva gaussiana
[mu, sigma] = fitta_gaussiana(n, val, media(Emap_ldpe), std(Emap_ldpe, 0, 'all'));

n_fit = 1:1:max(n);
val_fit = (1/(sigma*sqrt(2*pi))) * exp( -( ((n_fit - mu).^2)/(2*sigma^2) ) );

plot(n_fit, val_fit, 'DisplayName', 'Fit gaussiano', 'LineWidth', 1.5, 'Color', 'r');
xline(mu, 'LineStyle','--','Color', 'k', 'DisplayName', [int2str(mu) ' MPa'], 'LineWidth', 1.2);

fprintf('Eldpe = %4.0f MPa +- %4.0f MPa\n', mu, sigma);
%}

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

%{
val = h.Values;
n = val * 0;
edges = h.BinEdges;

for i = 1:1:length(n)
   n(i) = (edges(i) + edges(i+1)) / 2; 
end

%scatter(n, val, 'DisplayName', 'Punti istogramma');

% Fitta con curva gaussiana
[mu, sigma] = fitta_gaussiana(n, val, media(Emap_ps), std(Emap_ps, 0, 'all'));

n_fit = 1:1:max(n);
val_fit = (1/(sigma*sqrt(2*pi))) * exp( -( ((n_fit - mu).^2)/(2*sigma^2) ) );

plot(n_fit, val_fit, 'DisplayName', 'Fit gaussiano', 'LineWidth', 1.5, 'Color', 'r');
xline(mu, 'LineStyle','--','Color', 'k', 'DisplayName', [int2str(mu) ' MPa'], 'LineWidth', 1.2);

fprintf('Eps = %4.0f MPa +- %4.0f MPa\n', mu, sigma);
%}