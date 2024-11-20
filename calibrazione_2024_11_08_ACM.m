clc;
close all;
clear;

addpath './funzioni/';

% Caratteristiche punta e materiale
% Con 
% k = 0.5;
% R = 35e-9;
% Esce Eldpe = 1.7372 MPa +- 0.7600 MPa
%      Eps   = 210.37 MPa +- 48.436 MPa
% k va da 0.05 N/m a 2.3 N/m
% R è < 35 nm
% Provo con
% k = 2.3;
% R = 8e-9;
% v = 0.22;
% Esce Eldpe = 16.897 MPa +- 7.0540 MPa
%      Eps   = 2029.0 MPa +- 461.02 MPa
% Speriamo vadano bene

% Riprovo con 
k = 0.5;
R = 8e-9;
v = 0.22;

% Opzioni di fitting
n = 25;
Rsq_min = 0.99;
% p = 25;

% Caratteristica mappa
L = 2;  % um

% Recupera la slope di calibrazione
[~, slope] = calibra('./dati/zaffiro-2024_11_08-ACM.txt');
% [~, slope] = calibra('./dati/zaffiro-2024_10_31-1001pt-5x.txt');

% Calcola la mappa
Emap = calcola_mappa_E_intervallo('./dati/map56.txt', slope, k, R, v, n, Rsq_min);
% Emap = calcola_mappa_E_intervallo('./dati/map48.txt', slope, k, R, v, n, Rsq_min);
% Rendi in MPa
Emap = Emap / 1e6;
% Prima di mostrarla pero' ribalta le y
% Flippandola up-down (al posto di left right)

% Conta prima il numero di NaN
numero_NaN = sum(isnan(Emap), 'all');
tot = length(Emap)^2;
fprintf('Numero di errori: %d. Successo: %.2f\n', numero_NaN, ((tot - numero_NaN) * 100 / tot) );

mostra_mappa_E(Emap, L, 'MPa', 'Distribuzione modulo elastico PS-LDPE-12M');

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

%% --- Istogramma della mappa ---

E_lim = 300;
bin_size = 10;

figure;
hold on;
grid on;
histogram(Emap, 'DisplayName', 'E', 'BinWidth', bin_size, 'Normalization', 'pdf');
xlabel('E [MPa]');
ylabel('pdf []');
title('Distribuzione del modulo elastico');

%% --- Istogramma per il substrato LDPE ---

% Quindi con E < E_lim
Emap_ldpe = Emap(Emap < E_lim);
Emap_ldpe = Emap_ldpe(:);
bin_size = 10;

figure;
hold on;
grid on;
legend show;
h = histogram(Emap_ldpe, 'DisplayName', 'E - LDPE', 'BinWidth', bin_size, 'Normalization', 'pdf');
xlabel('E [MPa]');
%ylabel('pdf []');
title('Distribuzione del modulo elastico LDPE');

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

%% --- Istogramma per il substrato PS ---
% Quindi con E >= E_lim
bin_size = 50;
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