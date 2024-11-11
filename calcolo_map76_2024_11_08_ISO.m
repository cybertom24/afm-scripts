%% --- Calcola modulo elastico ---

clc;
close all;
clear;

addpath './funzioni/';

% Caratteristiche punta e materiale
k = 2.3;
R = 8e-9;
v = 0.5;

% Impostazioni fitting
n = 15;
p = 25;

% Caratteristica mappa
L = 2;

% Recupera la slope di calibrazione
[~, slope] = calibra('./dati/zaffiro-2024_11_08-ACM.txt');

% Calcola la mappa
Emap = calcola_mappa_E_fitting('./dati/map76.txt', slope, k, R, v, n, p);
% Rendi in MPa
Emap = Emap / 1e6;
% Prima di mostrarla pero' ribalta le y
% Flippandola up-down (al posto di left right)

% Conta prima il numero di NaN
numero_NaN = sum(isnan(Emap), 'all');
tot = length(Emap)^2;
fprintf('Numero di errori: %d. Successo: %.2f\n', numero_NaN, ((tot - numero_NaN) * 100 / tot) );

%% --- Genera mappa del modulo elastico ---

mostra_mappa_E(Emap, 2, 'MPa', 'Mappa del modulo elastico ACM-EXP84');

%% --- Distribuzione della mappa ---

bin_size = 100;

figure;
hold on;
grid on;
histogram(Emap, 'DisplayName', 'E', 'BinWidth', bin_size, 'Normalization', 'pdf');
xlabel('E [MPa]');
ylabel('pdf');
title('Distribuzione del modulo elastico');