clc;
clear;
close all;

addpath './funzioni/';

dir = 'C:\Users\savol\Documents\Università\Tesi\Dati\AFM\';
files_ISO = {{'map74', 'scan72'}, {'map80', 'scan77'}};
files_ACM = {{'map91', 'scan89'}, {'map93', 'scan92'}};

% Caratteristiche punta e materiale
k = 3.8;      % N/m
R = 32e-9;  % nm
v = 0.5;
bin_size = 200;

% --- ISO ---

% Recupera la slope di calibrazione
[~, slope] = calibra('./dati/curva-zaffiro-11_07_2024.txt');

for i = 1:1:length(files_ISO)
    % Calcola la mappa
    [Emap_ISO, uEmap_ISO] = calcola_mappa_E([dir 'mappa_ISO_' files_ISO{i}{1} '.txt'], slope, k, R, v);
    % Rendi in MPa
    Emap_ISO = Emap_ISO * 1e-6;

    Emap_ISO = flipud(Emap_ISO);

    % Plotta la mappa E e l'istogramma
    figure;
    % Plot a sinistra
    subplot(1, 2, 1);
    
    imagesc(Emap_ISO); % Indica gli assi prima della matrice
    colormap(jet);
    cb = colorbar;
    % caxis([0, 4000]);
    title(files_ISO{i}{1});
    ylabel(cb, 'E [MPa]'); % Imposta la label della colorbar

    % Plot a destra
    subplot(1, 2, 2);
    hold on;
    grid on;
    legend show;
    h = histogram(Emap_ISO, 'DisplayName', 'E', 'BinWidth', bin_size, 'Normalization', 'pdf');
    xlabel('E [MPa]');
    ylabel('pdf [%]');
    title('Distribuzione del modulo elastico');

    [mu, sigma, x, y] = fitta_istogramma(h, 1000, 100);
    plot(x, y, 'DisplayName', 'fit', 'LineWidth', 1.5, 'Color', 'r');

    fprintf('[%s] numero di NaN: %d; E = %.0f MPa +- %.0f MPa\n', files_ISO{i}{1}, sum(isnan(Emap_ISO), 'all'), mu, sigma);
end

% --- ACM ---

% Recupera la slope di calibrazione
[~, slope] = calibra('./dati/curva-zaffiro-12_07_2024-s1000.txt');

for i = 1:1:length(files_ACM)
    % Calcola la mappa
    [Emap_ACM, uEmap_ACM] = calcola_mappa_E([dir 'mappa_ACM_' files_ACM{i}{1} '.txt'], slope, k, R, v);
    % Rendi in MPa
    Emap_ACM = Emap_ACM * 1e-6;
    % Calcola la media
    med_ACM = media(Emap_ACM);
    
    Emap_ACM = flipud(Emap_ACM);

    % Plotta la mappa E e l'istogramma
    figure;
    % Plot a sinistra
    subplot(1, 2, 1);
    
    imagesc(Emap_ACM); % Indica gli assi prima della matrice
    colormap(jet);
    cb = colorbar;
    % caxis([0, 4000]);
    title(files_ACM{i}{1});
    ylabel(cb, 'E [MPa]'); % Imposta la label della colorbar

    % Plot a destra
    subplot(1, 2, 2);
    hold on;
    grid on;
    legend show;
    h = histogram(Emap_ACM, 'DisplayName', 'E', 'BinWidth', bin_size, 'Normalization', 'pdf');
    xlabel('E [MPa]');
    ylabel('pdf [%]');
    title('Distribuzione del modulo elastico');

    [mu, sigma, x, y] = fitta_istogramma(h, 1000, 100);
    plot(x, y, 'DisplayName', 'fit', 'LineWidth', 1.5, 'Color', 'r');

    fprintf('[%s] numero di NaN: %d; E = %.0f MPa +- %.0f MPa\n', files_ACM{i}{1}, sum(isnan(Emap_ACM), 'all'), mu, sigma);
end