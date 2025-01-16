clc;
clear;
close all;

addpath app\functions\
addpath funzioni\

[z, Nf] = load_force_curve('./dati/afm_zaffiro_curvaDZ_2024_10_24.txt');

z = flip(z);
Nf = flip(Nf);

figure;
hold on;
grid on;
legend show;
scatter(z, Nf, 'Marker','.', 'DisplayName', 'og');

l = 10;

[my_z, my_Nf] = moving_average_filter(z, Nf, 2 * l + 1);
scatter(my_z, my_Nf, 'Marker', '.', 'DisplayName', 'my movavg');

movavg_Nf = movmean(Nf, 2*l + 1, 'Endpoints', 'discard');
scatter(my_z, movavg_Nf, 'Marker', 'o', 'DisplayName', 'matlab movavg');
