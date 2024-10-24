close all;
clear;
clc;

addpath ./funzioni/;

[~, slope_iso] = calibra('./dati/curva-zaffiro-11_07_2024.txt');
[~, slope_acm] = calibra('./dati/curva-zaffiro-12_07_2024-s1000.txt');

figure;
hold on;
grid on;
legend show;

[zl1, dl1, zu1, du1] = load_curva_forza('./dati/curva-ISO-map74-1.txt');
du1 = rimuovi_background(zu1, du1, max(zu1)/2, max(zu1));
du1 = du1 / slope_iso;

[zl2, dl2, zu2, du2] = load_curva_forza('./dati/curva-ISO-map74-2.txt');
du2 = rimuovi_background(zu2, du2, max(zu2)/2, max(zu2));
du2 = du2 / slope_iso;

[zl3, dl3, zu3, du3] = load_curva_forza('./dati/curva-ISO-map74-3.txt');
du3 = rimuovi_background(zu3, du3, max(zu3)/2, max(zu3));
du3 = du3 / slope_iso;

plot(zu1, du1, 'DisplayName', 'ISO - 1' , 'Color', 'b', 'LineStyle', '-');
plot(zu2, du2, 'DisplayName', 'ISO - 2' , 'Color', 'b', 'LineStyle', '--');
plot(zu3, du3, 'DisplayName', 'ISO - 3' , 'Color', 'b', 'LineStyle', '-.');

[zl1, dl1, zu1, du1] = load_curva_forza('./dati/curva-ACM-map93-1.txt');
du1 = rimuovi_background(zu1, du1, max(zu1)/2, max(zu1));
du1 = du1 / slope_acm;

[zl2, dl2, zu2, du2] = load_curva_forza('./dati/curva-ACM-map93-2.txt');
du2 = rimuovi_background(zu2, du2, max(zu2)/2, max(zu2));
du2 = du2 / slope_acm;

[zl3, dl3, zu3, du3] = load_curva_forza('./dati/curva-ACM-map93-3.txt');
du3 = rimuovi_background(zu3, du3, max(zu3)/2, max(zu3));
du3 = du3 / slope_acm;

plot(zu1, du1, 'DisplayName', 'ACM - 1' , 'Color', 'r', 'LineStyle', '-');
plot(zu2, du2, 'DisplayName', 'ACM - 2' , 'Color', 'r', 'LineStyle', '--');
plot(zu3, du3, 'DisplayName', 'ACM - 3' , 'Color', 'r', 'LineStyle', '-.');

xlabel('z [nm]');
ylabel('d [nm]');
title('Confronto curve FD in distacco');

xlim([-20 200]);

%%

[zli, dli, zui, dui] = load_curva_forza('./dati/curva-ISO-map74-media.txt');
[zla, dla, zua, dua] = load_curva_forza('./dati/curva-ACM-map93-media.txt');

dli = rimuovi_background(zli, dli, max(zli)/2, max(zli));
dli = dli / slope_iso;
dui = rimuovi_background(zui, dui, max(zui)/2, max(zui));
dui = dui / slope_iso;

dla = rimuovi_background(zla, dla, max(zla)/2, max(zla));
dla = dla / slope_acm;
dua = rimuovi_background(zua, dua, max(zua)/2, max(zua));
dua = dua / slope_acm;

figure;
hold on;
grid on;
legend show;

plot(zli, dli, 'DisplayName', 'ISO - approccio' , 'Color', 'b', 'LineStyle', '--');
plot(zui, dui, 'DisplayName', 'ISO - distacco' , 'Color', 'b', 'LineStyle', '-');
plot(zla, dla, 'DisplayName', 'ACM - approccio' , 'Color', 'r', 'LineStyle', '--');
plot(zua, dua, 'DisplayName', 'ACM - distacco' , 'Color', 'r', 'LineStyle', '-');

xlabel('z [nm]');
ylabel('d [nm]');
title('Confronto curve FD medie');

xlim([-20 200]);

fprintf('Eiso = %0.f MPa, Eacm = %0.f MPa\n', calcola_E_modH_lineare_simple(zui * 1e-9, dui * 1e-9, 3.38, 30e-9, 0.5) * 1e-6, calcola_E_modH_lineare_simple(zua * 1e-9, dua * 1e-9, 3.38, 30e-9, 0.5) * 1e-6);