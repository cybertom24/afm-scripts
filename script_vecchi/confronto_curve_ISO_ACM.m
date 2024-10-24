clc;
clear;
close all;

addpath './funzioni/';

% Caratteristiche punta e materiale
k = 3.8;    % N/m
R = 32e-9;  % m
v = 0.5;

figure;
hold on;
grid on;
legend('show', 'location', 'northeast');
title('ISO vs ACM - medie sulle mappe');
xlabel('z [nm]');
ylabel('d [nm]');

% --- ISO ---
[~, slope] = calibra('./dati/curva-zaffiro-11_07_2024.txt');
[zl, dl, zu, du] = load_curva_forza('./dati/curva-ISO-map74.txt');
dl = rimuovi_background(zl, dl, max(zl)/2, max(zl));
du = rimuovi_background(zu, du, max(zu)/2, max(zu));
dl = dl / slope;
du = du / slope;
plot(zl, dl, 'DisplayName', 'ISO load', 'Color', 'b', 'LineStyle','--');
plot(zu, du, 'DisplayName', 'ISO unload', 'Color', 'b', 'LineStyle','-');
Eiso = calcola_E_modH_lineare(zu' * 1e-9, du' * 1e-9, k, R, v);

% --- ACM ---
[~, slope] = calibra('./dati/curva-zaffiro-12_07_2024-s1000.txt');
[zl, dl, zu, du] = load_curva_forza('./dati/curva-ACM-map93.txt');
dl = rimuovi_background(zl, dl, max(zl)/2, max(zl));
du = rimuovi_background(zu, du, max(zu)/2, max(zu));
dl = dl / slope;
du = du / slope;
plot(zl, dl, 'DisplayName', 'ACM load', 'Color', 'r', 'LineStyle','--');
plot(zu, du, 'DisplayName', 'ACM unload', 'Color', 'r', 'LineStyle','-');
Eacm = calcola_E_modH_lineare(zu' * 1e-9, du' * 1e-9, k, R, v);

fprintf('Eiso = %.0f MPa, Eacm = %.0f MPa', Eiso * 1e-6, Eacm * 1e-6);