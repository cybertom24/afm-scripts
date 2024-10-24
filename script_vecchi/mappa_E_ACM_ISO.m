clc;
clear;
close all;

addpath './funzioni/';

dir = 'C:\Users\savol\Documents\Università\Tesi\Dati\AFM\';
fileISO = 'mappa_ISO_map80.txt';
fileACM = 'mappa_ACM_map93.txt';

% Caratteristiche punta e materiale
k = 8.5;      % N/m
R = 30e-9;  % nm
v = 0.5;

% Recupera la slope di calibrazione
[slopel, slope] = calibra('./dati/curva-zaffiro-11_07_2024.txt');

% --- ISO ---

% Calcola la mappa
[Emap_ISO, uEmap_ISO] = calcola_mappa_E([dir fileISO], slope, k, R, v);
% Rendi in MPa
%Emap_ISO = Emap_ISO * 1e-6;
% Prima di mostrarla pero' ribalta le y
% Flippandola up-down (al posto di left right)

figure;
Emap_ISO = flipud(Emap_ISO);
imagesc(Emap_ISO);
colormap(jet);
colorbar;
xlabel('x');
ylabel('y');
title('ISO');
clim([min(min(Emap_ISO)) max(max(Emap_ISO))]);

% --- ACM ---

[slopel, slope] = calibra('./dati/curva-zaffiro-12_07_2024-s1000.txt');
%[slopel, slope] = calibra('curva-zaffiro-11_07_2024.txt');

% Calcola la mappa
[Emap_ACM, uEmap_ACM] = calcola_mappa_E([dir fileACM], slope, k, R, v);
% Rendi in MPa
% Emap_ACM = Emap_ACM / 1e6;
% Prima di mostrarla pero' ribalta le y
% Flippandola up-down (al posto di left right)

figure;
Emap_ACM = flipud(Emap_ACM);
imagesc(Emap_ACM);
colormap(jet);
colorbar;
xlabel('x');
ylabel('y');
title('ACM');
clim([min(min(Emap_ISO)) max(max(Emap_ISO))]);

med_ISO = media(Emap_ISO)
med_ACM = media(Emap_ACM)

med_u_ISO = media(uEmap_ISO)
med_u_ACM = media(uEmap_ACM)

ACM_over_ISO = med_ACM / med_ISO;
['ACM is ' num2str( ACM_over_ISO * 100 - 100 ) '% stiffer than ISO']
