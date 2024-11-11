clc;
clear;
close all;

addpath ./funzioni/

k = 0.5;    % N/m
R = 8e-9;  % m
v = 0.22;   % 1

marker_size = 100;

% Inizio

% Calibra lo strumento
[~, slope] = calibra('./dati/zaffiro-2024_10_31-1001pt-5x.txt');

% Carica la curva di forza
[~, ~, zu, Nfu] = load_curva_forza('./dati/map48-ldpe.txt');

% Rimuovi il background
[Nfu_nob, b] = rimuovi_background(zu, Nfu, max(zu) * 0.80, max(zu));

d = Nfu_nob / slope;
z = zu;

%d = flip(d);
%z = flip(z);

figure;
grid on;
hold on;
legend show;
scatter(z, d, 'Marker', '.', 'SizeData', marker_size, 'DisplayName','curva DZ');
title('Curva DZ e curva HZ');
xlabel('z [nm]');
ylabel('d/h [nm]');
% xlim([-10 100]);

% Calcola indentazione
h = (-z) - d;

scatter(z, h, 'Marker', '.', 'SizeData', marker_size, 'DisplayName','curva DZ');

n = 10;
[dx, dh] = derivata_locale(z, h, n);
plot(dx, dh, 'DisplayName', '\partialh');

figure;
grid on;
hold on;
legend show;
title('Curva DZ e curva HZ');
xlabel('z [nm]');
ylabel('d/h [nm]');

% plot(z, potenza(d, -1/3), 'DisplayName','curva D^{2/3}Z');
S = 2000;
g = - (potenza(d, -1/3) * (2 * S / 3) + 1).^-1;
plot(z, g, 'DisplayName','g(z)');

[dx, dd] = derivata_locale(z, d, n);
plot(dx, dd, 'DisplayName', '\partiald');