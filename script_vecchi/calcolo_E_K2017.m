close all;
clear;
clc;

% Queste curve sono state simulate e sono state proposte da Kontomaris 2022
% Caratteristiche punta:
k = 0.1;    % N/m
R = 1e-6;   % m
v = 0.5;
%slope = 1;  % a.u./nm
% E dovrebbe essere 20kPa (fisso)

data = readmatrix('100nm_no_1_Hertz_R1um.csv');
z = data(:,1) * 1e-6;   % m
def = data(:,2) * 1e-6; % m

figure;
hold on;
grid on;
legend show;
title('Curva (misurata) deflessione cantilever (def) vs sensore piezo (z)');
xlabel('z [m]');
ylabel('def [m]');
scatter(z, def, 'Marker', '.', 'DisplayName', 'curva def vs z');

% Calcolo dell'identazione
h = def - z;

% Calcolo della forza
f = def * k;

figure;
hold on;
grid on;
legend show;
title('Curva forza (f) vs identazione (h)');
xlabel('h [m]');
ylabel('f [N]');
scatter(h, f, 'Marker', '.', 'DisplayName', 'f(h)');

% Linearizza
f = potenza(f, 2/3);

figure;
hold on;
grid on;
legend show;
title('Curva forza (f) vs identazione (h) linearizzata');
xlabel('h [m]');
ylabel('f^{2/3} [N^{2/3}]');
scatter(h, f, 'Marker', '.', 'DisplayName', 'f^{2/3}(h)');

% Fitta la parte lineare dopo lo 0
[mf, qf, sigma, sigma_m] = fitta_retta_parziale(h, f, 0, 1);

plot(h, mf*h + qf, 'DisplayName','f^{2/3}(h) - fit');

% Recupera E
S = mf;

E = (S ^ 1.5) * 0.75 * (1 - v^2) / sqrt(R);

% Calcola errore su E
err = (0.75 * (1 - v^2) / sqrt(R)) * 1.5 * sqrt(S) * sigma_m;