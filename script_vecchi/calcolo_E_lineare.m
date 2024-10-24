clc;
clear;
close all;

addpath './funzioni/';

dir = 'C:\Users\savol\Documents\Università\Tesi\Dati\AFM\';
files_ISO = {{'map74', 'scan72', 'b'}, {'map80', 'scan77', 'g'}};
files_ACM = {{'map91', 'scan89', 'r'}, {'map93', 'scan92', 	'#EDB120'}};

% Caratteristiche punta e materiale
k = 5;    % N/m
R = 35e-9;  % nm
v = 0.5;

% Calibra
[slopel, slopeu] = calibra('./dati/curva-zaffiro-11_07_2024.txt');

% Indice
i = 2;

% Calcola una media su tutta la mappa
% [zl, dl, zu, du] = calcola_DZ_media([dir 'mappa_ACM_' files_ACM{i}{1} '.txt'], './dati/curva-zaffiro-12_07_2024-s1000.txt');

[zl, Nfl, zu, Nfu] = load_curva_forza('./dati/curva-ps-11_07_2024.txt');

Nfl = rimuovi_background(zl, Nfl, max(zl)/2, max(zl));
Nfu = rimuovi_background(zu, Nfu, max(zu)/2, max(zu));

dl = Nfl / slopel;
du = Nfu / slopeu;

figure;
hold on;
grid on;
legend('show', 'location', 'northeast');
title('Curva originale');
xlabel('z [nm]');
ylabel('d [nm]');
plot(zl, dl, 'DisplayName', 'load', 'LineStyle','--', 'Marker','.');
plot(zu, du, 'DisplayName', 'unload', 'LineStyle','-', 'Marker','.');

% Shifta verso il basso in modo che quando z = 0 anche d = 0
dl = dl - dl(zl == 0);
du = du - du(zu == 0);

figure;
hold on;
grid on;
legend('show', 'location', 'northeast');
title('ACM 93 - ora d = 0 quando z = 0');
xlabel('z [nm]');
ylabel('d [nm]');
plot(zl, dl, 'DisplayName', 'load', 'LineStyle','--', 'Marker','.');
plot(zu, du, 'DisplayName', 'unload', 'LineStyle','-', 'Marker','.');
plot(zu(zu <= 0), -zu(zu <= 0), 'DisplayName', 'substrato rigido', 'Color',[0.15 0.15 0.15], 'LineStyle','-.');

% Calcola l'indentazione
hl = (-zl) - dl;
hu = (-zu) - du;

% Calcola la forza
Fl = dl * k;
Fu = du * k;

figure;
hold on;
grid on;
legend('show', 'location', 'northwest');
title('ACM 93 - forza F vs indentazione h');
xlabel('h [nm]');
ylabel('F [nN]');
plot(hl, Fl, 'DisplayName', 'unload', 'LineStyle','--', 'Marker','.');
plot(hu, Fu, 'DisplayName', 'load', 'LineStyle','-', 'Marker','.');

% Mantieni solo la parte positiva
Fl_lin = Fl(hl >= 0) * 1e-9;
Fu_lin = Fu(hu >= 0) * 1e-9;

hl_lin = hl(hl >= 0) * 1e-9;
hu_lin = hu(hu >= 0) * 1e-9;

% Linearizza
Fl_lin = potenza(Fl_lin, 2/3);
Fu_lin = potenza(Fu_lin, 2/3);

figure;
hold on;
grid on;
legend('show', 'location', 'north');
title('ACM 93 - forza F^{2/3} vs indentazione h');
xlabel('h [nm]');
ylabel('F^{2/3} [nN^{2/3}]');
plot(hl_lin, Fl_lin, 'DisplayName', 'load', 'LineStyle','--', 'Marker','.');
plot(hu_lin, Fu_lin, 'DisplayName', 'unload', 'LineStyle','-', 'Marker','.');

% Fitta
[ml, ql] = fitta_retta(hl_lin, Fl_lin);
[mu, qu] = fitta_retta(hu_lin, Fu_lin);

plot(hl_lin, ml*hl_lin + ql, 'DisplayName', 'load fit', 'LineStyle','--');
plot(hu_lin, mu*hu_lin + qu, 'DisplayName', 'unload fit', 'LineStyle','-');

% Calcola E
El = (ml ^ 1.5) * 0.75 * (1 - v^2) / sqrt(R);
Eu = (mu ^ 1.5) * 0.75 * (1 - v^2) / sqrt(R);

fprintf('E load = %.1f MPa, E unload = %.1f MPa\n', El/1e6, Eu/1e6);

[zl, Nfl, zu, Nfu] = load_curva_forza('./dati/curva-ps-11_07_2024.txt');

Nfl = rimuovi_background(zl, Nfl, max(zl)/2, max(zl));
Nfu = rimuovi_background(zu, Nfu, max(zu)/2, max(zu));

dl = Nfl / slopel;
du = Nfu / slopeu;

[El, Eridl, u_El] = calcola_E_modH_lineare(zl * 1e-9, dl * 1e-9, k, R, v);
[Eu, Eridu, u_Eu] = calcola_E_modH_lineare(zu * 1e-9, du * 1e-9, k, R, v);

fprintf('E load = %.1f MPa +- %.1f MPa, E unload = %.1f MPa +- %.1f MPa\n', El/1e6, u_El/1e6, Eu/1e6, u_Eu/1e6);
