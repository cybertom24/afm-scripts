close all;
clear;
clc;

addpath './funzioni/';

% Caratteristiche punta e campione
k = 5;      % N/m
R = 35e-9;  % nm
v = 0.22;

marker_size = 200;
line_width = 1.5;

% Trova il valore di slope partendo dalle curve dello zaffiro
[zaff_zl, zaff_Nfl, zaff_zu, zaff_Nfu] = load_curva_forza('./dati/curva-zaffiro-11_07_2024.txt');

figure;
hold on;
grid on;
legend show;
title('Calibrazione con zaffiro - curva DZ acquisita');
xlabel('z [nm]');
ylabel('Nf [au]');
scatter(zaff_zl, zaff_Nfl, 'DisplayName','approccio', 'Marker','.', 'SizeData', marker_size);
% scatter(zaff_zu, zaff_Nfu, 'DisplayName','distacco', 'Marker','.', 'SizeData', marker_size);
xlim([-5 100]);

% Rimozione del background
[zaff_Nfl, b_l] = rimuovi_background(zaff_zl, zaff_Nfl, 60, 100);
[zaff_Nfu, b_u] = rimuovi_background(zaff_zu, zaff_Nfu, 60, 100);

plot(zaff_zl, b_l, 'DisplayName','background - approccio', 'LineWidth', line_width);
% plot(zaff_zu, b_u, 'DisplayName','background - distacco', 'LineWidth', line_width);

figure;
hold on;
grid on;
legend show;
title('Calibrazione con zaffiro - curva DZ senza background');
xlabel('z [nm]');
ylabel('Nf [au]');
scatter(zaff_zl, zaff_Nfl, 'DisplayName','approccio', 'Marker', '.', 'SizeData', marker_size);
% scatter(zaff_zu, zaff_Nfu, 'DisplayName','distacco', 'Marker', '.', 'SizeData', marker_size);
xlim([-5 50]);
ylim([-750 1750]);

% Fitta la parte con z < 0
[zaff_ml, zaff_ql] = fitta_retta_parziale(zaff_zl, zaff_Nfl, 0, -10);
[zaff_mu, zaff_qu] = fitta_retta_parziale(zaff_zu, zaff_Nfu, 0, -10);

plot(zaff_zl(zaff_zl <= 0), (zaff_zl(zaff_zl <= 0) * zaff_ml + zaff_ql), 'DisplayName', 'fit approccio', 'LineWidth', line_width);
% plot(zaff_zu(zaff_zu <= 0), (zaff_zu(zaff_zu <= 0) * zaff_mu + zaff_qu), 'DisplayName', 'fit distacco', 'LineWidth', line_width);

slopel = abs(zaff_ml)
slopeu = abs(zaff_mu)

% Carica i due substrati
[ps_zl, ps_Nfl, ps_zu, ps_Nfu] = load_curva_forza('./dati/curva-ps-11_07_2024.txt');
[ldpe_zl, ldpe_Nfl, ldpe_zu, ldpe_Nfu] = load_curva_forza('./dati/curva-ldpe-11_07_2024.txt');

% Lavora solo sulle curve di distacco e rimuovi il background
ps_z = ps_zu;
ps_Nf = ps_Nfu;
ldpe_z = ldpe_zu;
ldpe_Nf = ldpe_Nfu;

ps_Nf = rimuovi_background(ps_z, ps_Nf, 100, 200);
ldpe_Nf = rimuovi_background(ldpe_z, ldpe_Nf, 100, 200);

% Converti in deflessione d
ps_d = ps_Nf / slopeu;
ldpe_d = ldpe_Nf / slopeu;

figure;
hold on;
grid on;
legend show;
title('Curve DZ del substrato PS e LDPE');
scatter(ps_z, ps_d, 'DisplayName', 'PS', 'Marker','.');
scatter(ldpe_z, ldpe_d, 'DisplayName', 'LDPE', 'Marker','.');
xlabel('z [nm]');
ylabel('d [nm]');

% Converti in forza f
ps_f = ps_d * k;
ldpe_f = ldpe_d * k;

% Converti in indentazione h
ps_h = (-ps_z) - ps_d;
ldpe_h = (-ldpe_z) - ldpe_d;

figure;
hold on;
grid on;
legend('show', 'location', 'northwest');
title('Curve FH del substrato PS e LDPE');
scatter(ps_h, ps_f, 'DisplayName', 'PS', 'Marker','.', 'SizeData', marker_size);
scatter(ldpe_h, ldpe_f, 'DisplayName', 'LDPE', 'Marker','.', 'SizeData', marker_size);
xlabel('h [nm]');
ylabel('f [nN]');

[Eps, Eridps, uEps, uEridps] = calcola_E_completo('./dati/curva-ps-11_07_2024.txt', './dati/curva-zaffiro-11_07_2024.txt', k, R, v);
[Eldpe, Eridldpe, uEldpe, uEridldpe] = calcola_E_completo('./dati/curva-ldpe-11_07_2024.txt', './dati/curva-zaffiro-11_07_2024.txt', k, R, v);

['Eps = ' num2str(Eps * 1e-9) ' GPa +- ' num2str(uEps * 2 * 1e-9) ' GPa']
['Eldpe = ' num2str(Eldpe * 1e-6) ' MPa +- ' num2str(uEldpe * 2 * 1e-6) ' MPa']
