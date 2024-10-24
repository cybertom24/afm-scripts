close all;
clear;
clc;

addpath './funzioni/';

% Trova il valore di slope partendo dalle curve dello zaffiro
[zaff_zl, zaff_Nfl, zaff_zu, zaff_Nfu] = load_curva_forza('./dati/curva-zaffiro-11_07_2024.txt');

[zaff_Nfl, b_l] = rimuovi_background(zaff_zl, zaff_Nfl, 60, 100);

figure;
hold on;
%grid on;
%legend show;
title('Curva DZ ideale');
xlabel('z');
ylabel('d');
plot(zaff_zl, zaff_Nfl, 'DisplayName','approccio');
%scatter(zaff_zu, zaff_Nfu, 'DisplayName','distacco', 'Marker','.');
%xticks([]);
%yticks([]);
hline(0, 'Color', 'k');
xline(0, 'Color', 'k');