clc;
clear;
close all;

%plotta_curva_forza('curva-zaffiro-12_07_2024-s100.txt', 's100');
%plotta_curva_forza('curva-zaffiro-12_07_2024-s1000.txt', 's1000');
%plotta_curva_forza('curva-zaffiro-11_07_2024.txt', 'ieri');

%[zl, Nfl, zu, Nfu] = load_curva_forza('curva-zaffiro-12_07_2024-s100.txt');
%calcola_E_modH(zl, Nfl, 250, 5, 35, 0.25)





%[zl, Nfl, zu, Nfu] = load_curva_forza('curva-zaffiro-11_07_2024.txt');
%calcola_E_modH(zu, Nfu, 326, 10, 35, 0.25)

[ml_calib, mu_calib] = calibrazione('curva-zaffiro-11_07_2024.txt');

figure;
hold on;
legend show;
grid on;

% Calcolo E del PS
[zl, Nfl, zu, Nfu] = load_curva_forza('curva-ldpe-11_07_2024.txt');

scatter(zl, Nfl, 'DisplayName', 'raw','Marker','.');

% Caratteristiche della punta
k = 10;          % N/m
R = 35e-9;      % m
E_tip = 78e9;   % E dell'oro (coating della punta)
v_tip = 0.42;   % coef. di Poisson dell'oro (coating della punta)
% Caratteristiche del materiale
v = 0.40;       % Boh a caso
% Lo calcolo sulla curva di approccio (load) e quindi userò
slope = - ml_calib;

%E = calcola_E_modH(zl, Nfl, slope, k, R, v)

% Rimozione del background (ottenuto fittando la parte lineare)
[m_bck, q_bck] = fitta_retta_parziale(zl, Nfl, 100, 200);
Nfl = Nfl - (m_bck*zl + q_bck);

scatter(zl, Nfl, 'DisplayName', 'no bck','Marker','.');

% Conversione da Nfl [au] a defl [nm]
defl = Nfl / slope;

% Calcolo della distanza tip-campione
% Differenza tra la posizione del piezo tubo (zl) e la deflessione del
% cantilever (delf)
% Converti anche in m (moltiplicando per e-9)
d = (zl - defl) * 1e-9;

% Calcolo della forza (in N)
% (aggiunto e-9 per portare nm in m)
f = k * defl * 1e-9;

figure;
grid on;
title('Curva forza vs distanza punta-campione');
xlabel('d [m]');
ylabel('f [N]');
scatter(d, f);

% Applica il modello di Hertz
figure;
hold on;
grid on;
legend show;
title('Modello di Hertz');
xlabel('d [m]');
ylabel('f [N ^ 2/3]');

% Eleva la f alla 2/3
f = (f .^ 2) .^ (1/3);

scatter(d, f, 'DisplayName','f ^ 2/3');

% d0 è il punto da cui parte l'identazione (che può essere cambiato per impostare degli
% offset)
d0 = -1e-9;

% Fitta la parte che va negativa
[mf, qf] = fitta_retta_parziale(d, f, -1, d0);

plot(d, (mf*d + qf), 'DisplayName','fit');

E_rid = (3/4) * (abs(mf) ^ (3/2)) / (sqrt(R));

E = ( (1 + v^2) * (1/E_rid - (1 - v_tip^2)/E_tip)  ) ^ (-1)