clc;
clear;
close all;

dir = '/home/cyber/Documents/Università/Tesi/Dati/AFM/';
fileISO = 'mappa_ISO_map80.txt';
fileACM = 'mappa_ACM_map93.txt';

% Recupera la slope di calibrazione
[slopel, slope] = calibra('curva-zaffiro-11_07_2024.txt');

% --- ISO ---

% Calcola la mappa
Hmap_ISO = calcola_mappa_H([dir fileISO], slope);
% Rendi in MPa
% hmap_ISO = gmap_ISO / 1e6;
% Prima di mostrarla pero' ribalta le y
% Flippandola up-down (al posto di left right)

figure;
Hmap_ISO = flipud(Hmap_ISO);
imagesc(Hmap_ISO);
colormap(jet);
colorbar;
xlabel('x');
ylabel('y');
title('ISO');
caxis([-0.01, 0.01]);

% --- ACM ---

% Calcola la mappa
Hmap_ACM = calcola_mappa_H([dir fileACM], slope);
% Rendi in MPa
% hmap_ACM = gmap_ACM / 1e6;
% Prima di mostrarla pero' ribalta le y
% Flippandola up-down (al posto di left right)

figure;
Hmap_ACM = flipud(Hmap_ACM);
imagesc(Hmap_ACM);
colormap(jet);
colorbar;
xlabel('x');
ylabel('y');
title('ACM');
caxis([-0.01, 0.01]);