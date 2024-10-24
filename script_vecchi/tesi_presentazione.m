close all;
clear;
clc;

addpath './funzioni/';

% Caratteristiche punta e campione
k = 3.38;      % N/m
R = 30e-9;  % nm
v = 0.22;

% Calibra
[slopel, slopeu] = calibra('./dati/curva-zaffiro-11_07_2024.txt');

% Trova il valore di slope partendo dalle curve dello zaffiro
[zaff_zl, zaff_Nfl, zaff_zu, zaff_Nfu] = load_curva_forza('./dati/curva-ps-11_07_2024.txt');

% Rimozione del background
[zaff_Nfl, b_l] = rimuovi_background(zaff_zl, zaff_Nfl, max(zaff_zl)/2, max(zaff_zl));
[zaff_Nfu, b_u] = rimuovi_background(zaff_zu, zaff_Nfu, max(zaff_zu)/2, max(zaff_zu));

% Conversione in forza
zaff_Fl = zaff_Nfl * k / slopel;
zaff_Fu = zaff_Nfu * k / slopeu;

figure;
hold on;
grid on;
legend show;
title('Curva forza-distanza su substrato PS');
xlabel('z [nm]');
ylabel('F [nN]');
plot(zaff_zl, zaff_Fl, 'DisplayName','approccio', 'LineWidth', 1.2);
plot(zaff_zu, zaff_Fu, 'DisplayName','distacco','LineWidth', 1.2);
xlim([-10 100]);