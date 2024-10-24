clc;
clear;
close all;

% Caratteristiche punta e materiale
k = 9;
R = 25e-9;
v = 0.22;

% Recupera la slope di calibrazione
[slopel, slope] = calibra('curva-zaffiro-11_07_2024.txt');

% Calcola la mappa
Emap = calcola_mappa_E('mappa_E_ps-lpde-12m_11-07-2024.txt', slope, k, R, v);
% Rendi in MPa
Emap = Emap / 1e6;
% Prima di mostrarla pero' ribalta le y
% Flippandola up-down (al posto di left right)

figure;
Emap = flipud(Emap);
imagesc(Emap);
colormap(jet);
colorbar;
% caxis([-100, 7000]);
xlabel('x');
ylabel('y');