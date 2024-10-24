clc;
clear;
close all;

addpath ./funzioni/;

heigth_data = load("./dati/scan59-heigth.txt");
heigth_data_x = heigth_data(:, 1);
heigth_data_y = heigth_data(:, 2);
heigth_data_z = heigth_data(:, 3);

l = round( sqrt(length(heigth_data_z)) );
heigth_map = zeros([l l]);

for i = 1:1:length(heigth_data_x)
    x = heigth_data_x(i) + 1;
    y = heigth_data_y(i) + 1;
    z = heigth_data_z(i);
    heigth_map(y, x) = z; 
end

[slopel, slope] = calibra('./dati/curva-zaffiro-11_07_2024.txt');
k = 8.5;
R = 30e-9;
v = 0.22;

Emap = calcola_mappa_E('./dati/mappa_E_ps-lpde-12m_11-07-2024.txt', slope, k, R, v);
% Rendi in MPa
Emap = Emap / 1e6;

figure;
imagesc(Emap);
colormap(jet);
colorbar;
% caxis([-100, 3000]);

% Estendi la mappa E alla stessa dimensione di heigth_map
Emap_extended = estendi_mappa(Emap, size(heigth_map));

figure;
% Plotta la superficie 3D usando Emap (estesa) come colorazione
surf(heigth_map, Emap_extended, 'EdgeColor','none');
colormap(jet);
colorbar;
% caxis([-100, 3000]);
% Migliora la visualizzazione 3D
shading interp           % Smoothing dei colori
light                    % Aggiunta di luce
lighting gouraud         % Illuminazione Gouraud
lightangle(45, 30)       % Angolo della luce