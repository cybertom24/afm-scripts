clc;
clear;
close all;

addpath './funzioni/';

dir = 'C:\Users\savol\Documents\Università\Tesi\Dati\AFM\';
files_ISO = {{'map74', 'scan72'}, {'map80', 'scan77'}};
files_ACM = {{'map91', 'scan89'}, {'map93', 'scan92'}};

% Caratteristiche punta e materiale
k = 5;      % N/m
R = 35e-9;  % nm
v = 0.5;

% --- ISO ---

% Recupera la slope di calibrazione
[slopel, slope] = calibra('./dati/curva-zaffiro-11_07_2024.txt');

for i = 1:1:length(files_ISO)
    % Recupera l'informazione sull'altezza
    heigth_data = load([dir files_ISO{i}{2} '-heigth.txt']);
    heigth_data_x = heigth_data(:, 1);
    heigth_data_y = heigth_data(:, 2);
    heigth_data_z = heigth_data(:, 3);

    l = round( sqrt(length(heigth_data_z)) );
    heigth_map = zeros([l l]);

    for j = 1:1:length(heigth_data_x)
        x = heigth_data_x(j) + 1;
        y = heigth_data_y(j) + 1;
        z = heigth_data_z(j);
        heigth_map(y, x) = z; 
    end

    % Calcola la mappa
    [Emap_ISO, uEmap_ISO] = calcola_mappa_E([dir 'mappa_ISO_' files_ISO{i}{1} '.txt'], slope, k, R, v);
    % Rendi in MPa
    Emap_ISO = Emap_ISO * 1e-6;
    % Calcola la media
    med_ISO = media(Emap_ISO);
    
    % Estendi la mappa E alla stessa dimensione di heigth_map
    Emap_extended = estendi_mappa(Emap_ISO, size(heigth_map));

    figure;
    % Plotta la superficie 3D usando Emap (estesa) come colorazione
    surf(heigth_map, Emap_extended, 'EdgeColor','none');
    colormap(jet);
    cb = colorbar;

    % Migliora la visualizzazione 3D
    shading interp           % Smoothing dei colori
    light                    % Aggiunta di luce
    lighting gouraud         % Illuminazione Gouraud
    lightangle(45, 30)       % Angolo della luce
    title(['ISO EXP85 - ' files_ISO{i}{1} ' - media: ' num2str(med_ISO) ' MPa']);
    %clim([0 1000]);
    ylabel(cb, 'E [MPa]');
end

% --- ACM ---

% Recupera la slope di calibrazione
[slopel, slope] = calibra('./dati/curva-zaffiro-12_07_2024-s1000.txt');

for i = 1:1:length(files_ACM)
    % Recupera l'informazione sull'altezza
    heigth_data = load([dir files_ACM{i}{2} '-heigth.txt']);
    heigth_data_x = heigth_data(:, 1);
    heigth_data_y = heigth_data(:, 2);
    heigth_data_z = heigth_data(:, 3);

    l = round( sqrt(length(heigth_data_z)) );
    heigth_map = zeros([l l]);

    for j = 1:1:length(heigth_data_x)
        x = heigth_data_x(j) + 1;
        y = heigth_data_y(j) + 1;
        z = heigth_data_z(j);
        heigth_map(y, x) = z; 
    end

    % Calcola la mappa
    [Emap_ACM, uEmap_ACM] = calcola_mappa_E([dir 'mappa_ACM_' files_ACM{i}{1} '.txt'], slope, k, R, v);
    % Rendi in MPa
    Emap_ACM = Emap_ACM * 1e-6;
    % Calcola la media
    med_ACM = media(Emap_ACM);
    
    Emap_extended = estendi_mappa(Emap_ACM, size(heigth_map));

    figure;
    % Plotta la superficie 3D usando Emap (estesa) come colorazione
    surf(heigth_map, Emap_extended, 'EdgeColor','none');
    colormap(jet);
    cb = colorbar;

    % Migliora la visualizzazione 3D
    shading interp           % Smoothing dei colori
    light                    % Aggiunta di luce
    lighting gouraud         % Illuminazione Gouraud
    lightangle(45, 30)       % Angolo della luce
    title(['ACM EXP84 - ' files_ACM{i}{1} ' - media: ' num2str(med_ACM) ' MPa']);
    %clim([0 1000]);
    ylabel(cb, 'E [MPa]');
end