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

k = 5;
R = 35e-9;
v = 0.22;
[ps_zl, ps_Nfl, z, Nf] = load_curva_forza('curva-ps-11_07_2024.txt');
% Rimozione del background
[Nf, b] = rimuovi_background(z, Nf, 100, 200);
def = Nf / 325;

z = z * 1e-9;
def = def * 1e-9;

% Calcolo dell'identazione del campione (h)
% Differenza tra la deflesssione del cantilever (def) e la posizione del 
% piezo tubo (z)
h = (-z) - def;

% Limita h ai soli valori positivi
h = h(h > 0);
% Riduci def alla stessa dimensione
def = def(h > 0);

% Rimuovi offset
def = def - min(def);

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


% Applica il modello di Hertz modificato da Kontomaris 2022

% Fitta la curva f(h) con il modello f(h) = a * (h ^ b)

% Esecuzione del fitting con vincoli: h > 0, b >= 1
[fitted_curve, gof, out] = fit(h, f, 'power1', 'Exclude', h < 0, 'Lower', [-Inf 1], 'StartPoint', [0 0]);

% Recupera i risultati del fit
a = fitted_curve.a;
b = fitted_curve.b;

plot(h, (a * (h.^b)), 'DisplayName','power fit');

% Equazione 29 Kontomaris 2022
c1 =  1.01400;
c2 = -0.09059;
c3 = -0.09431;
rc = (R * ( c1 * sqrt(h/R) + c2 * (h/R) + c3 * ((h/R) .^ 2) ));

figure;
hold on;
grid on;
legend show;
title('raggio di contatto (rc) vs identazione (h)');
xlabel('h [m]');
ylabel('rc [m]');
plot(h, rc, 'DisplayName','rc vs h');

% Avendo calcolato rc, posso unire le eq. 25, 26 e 29 per ottenere E
%E = (1 - v^2) * (a * b / 2) * ( (h .^ (b - 1)) ./ rc );

E = (max(f) / (max(rc) * max(h))) * b * (1 - v^2) / 2;