clc;
clear;
close all;

addpath './funzioni/';

dir = 'C:\Users\savol\Documents\Università\Tesi\Dati\AFM\';

[~, slope] = calibra('./dati/curva-zaffiro-11_07_2024.txt');

file = 'mappa_ISO_map74.txt';
name = 'ISO';

% Caratteristiche punta e materiale
k = 3.38;  % N/m
R = 30e-9;  % nm
v = 0.5;

bin_size = 50;

% Calcola la mappa
[Emap, uEmap] = calcola_mappa_E([dir file], slope, k, R, v);
% Rendi in MPa
Emap = Emap * 1e-6;

% Conta quanti errori ci sono stati
numero_NaN = sum(isnan(Emap), 'all');
tot = length(Emap)^2;
fprintf('%s: Numero di errori: %d. Successo: %.2f\n', name, numero_NaN, ((tot - numero_NaN) * 100 / tot) );

% Calcola e mostra l'istogramma
figure;
hold on;
grid on;
legend show;
h = histogram(Emap(Emap < 2000), 'DisplayName', 'E', 'BinWidth', bin_size, 'Normalization', 'pdf');

xlabel('E [MPa]');
% ylabel('pdf'); Non serve
title(['Distribuzione di E del campione ' name]);

% Ottieni la funzione di densità di probabilità
y = h.Values;
x = y * 0;
edges = h.BinEdges;

for i = 1:1:length(x)
    x(i) = (edges(i) + edges(i+1)) / 2; 
end

% Plottala sull'istogramma
% scatter(x, y, 'DisplayName', 'pdf');

% Setup del fitter
ft = fittype( 'gauss4' );

opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.Robust = 'LAR';
opts.Lower = [0 0 0 0 0 0 0 0 0 0 0 0];
opts.StartPoint = [0.01 475 100 0.01 750 100 0.01 750 100 0.01 1725 100];
opts.DiffMinChange = 1e-100;
opts.DiffMaxChange = 1e-10;
opts.MaxFunEvals = 1e10;
opts.MaxIter = 1e10;
opts.TolFun = 1e-10;
opts.TolX = 1e-10;

% Fit model to data.
[fitresult, gof] = fit( x(:), y(:), ft, opts );

% Recupera i dati
a1 = fitresult.a1;
b1 = fitresult.b1;
c1 = fitresult.c1;

a2 = fitresult.a2;
b2 = fitresult.b2;
c2 = fitresult.c2;

a3 = fitresult.a3;
b3 = fitresult.b3;
c3 = fitresult.c3;

a4 = fitresult.a4;
b4 = fitresult.b4;
c4 = fitresult.c4;

%a5 = fitresult.a5;
%b5 = fitresult.b5;
%c5 = fitresult.c5;

x_fit = 0:max(x)/1000:max(x);
y_fit = gauss(x_fit, a1, b1, c1) + gauss(x_fit, a2, b2, c2) + gauss(x_fit, a3, b3, c3) + gauss(x_fit, a4, b4, c4);% + gauss(x_fit, a5, b5, c5);

plot(x_fit, y_fit, 'DisplayName', 'fit', 'LineWidth', 1.5);

plot(x_fit, gauss(x_fit, a1, b1, c1), 'DisplayName', [int2str(b1) ' MPa'], 'LineWidth', 1.5);
plot(x_fit, gauss(x_fit, a2, b2, c2), 'DisplayName', [int2str(b2) ' MPa'], 'LineWidth', 1.5);
plot(x_fit, gauss(x_fit, a3, b3, c3), 'DisplayName', [int2str(b3) ' MPa'], 'LineWidth', 1.5);
plot(x_fit, gauss(x_fit, a4, b4, c4), 'DisplayName', [int2str(b4) ' MPa'], 'LineWidth', 1.5);
%plot(x_fit, gauss(x_fit, a5, b5, c5), 'DisplayName', [int2str(b5) ' MPa']);

fprintf('picco 1: %.0f MPa +- %.0f MPa\n', b1, c1/sqrt(2));
fprintf('picco 2: %.0f MPa +- %.0f MPa\n', b2, c2/sqrt(2));
fprintf('picco 3: %.0f MPa +- %.0f MPa\n', b3, c3/sqrt(2));
fprintf('picco 4: %.0f MPa +- %.0f MPa\n', b4, c4/sqrt(2));