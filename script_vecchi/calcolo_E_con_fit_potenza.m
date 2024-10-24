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

%def = Nf / slope;

% Calcolo dell'identazione del campione (h)
% Differenza tra la deflesssione del cantilever (def) e la posizione del 
% piezo tubo (z)
h = (-z) - def;

% Calcolo della forza (in N)
f = k * def;

figure;
hold on;
grid on;
legend show;
title('Curva forza vs identazione');
xlabel('h [m]');
ylabel('f [N]');
scatter(h, f, 'DisplayName', 'f vs h', 'Marker','.');

% Applica il modello di Hertz senza la linearizzazione

% Fitta la curva f(h) con il modello f(h) = a * (h ^ b)
% con b = 1.5 (3/2)

% Esecuzione del fitting con vincoli: h > 0, b = 1.5
[fitted_curve, gof, out] = fit(h, f, 'power1', 'Exclude', h < 0, 'Lower', [-Inf 1.5], 'Upper', [Inf 1.5], 'StartPoint', [0 1.5]);

% Recupera i risultati del fit
a = fitted_curve.a;
b = fitted_curve.b;

plot(h, (a * (h.^b)), 'DisplayName','power fit');

E = 0.75 * (1 - v^2) * a / sqrt(R)

Ek = calcola_E_modH_kontomaris(z, def, k, R, v)