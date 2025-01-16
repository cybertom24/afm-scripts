clc;
clear;
close all;

% Carica i dati calcolati
load('./output/analisi - ACM&ISO - 2024_11_28/values_acm.mat');
load('./output/analisi - ACM&ISO - 2024_11_28/values_iso.mat');

% Plotta entrambi gli istogrammi
figure;
grid on;
hold on;
title('E distribution across the maps');
xlabel('E [MPa]');
ylabel('count');
bar(bin_centers, values_iso, 'hist');
bar(bin_centers, values_acm, 'hist');