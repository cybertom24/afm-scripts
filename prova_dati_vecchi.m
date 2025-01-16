clc;
close all;
clear;

addpath ./funzioni
addpath ./app/functions/
addpath ./more-colormaps/

set(0, 'DefaultAxesFontSize', 14);
set(0, 'DefaultTextFontSize', 14);

% Caratteristiche punta e materiale
k = 0.5;    % [N/m]
R = 35e-9;  % [m]
v = 0.5;    % []

% Caratteristiche mappa
L = 2;      % [um]

% Impostazioni fitting
n = 15;
Rsq_min = 0;
b_start = 0.80;

slope = 350;

[~, ~, z_old, Nf_old] = load_force_curve('./dati/curva-ACM-12_07_2024.txt');

z_new = linspace(min(z_old), max(z_old), 801 * 4);
Nf_new = interp1(z_old, Nf_old, z_new, 'spline');

figure;
grid on;
hold on;
scatter(z_old, Nf_old, 'Marker', 'o');
plot(z_new, Nf_new, 'Marker', '.');

Nf_nob = remove_background(z_new, Nf_new, 0.80 * max(z_new), +Inf);
d = Nf_nob * 1e-9 / slope;
z = z_new * 1e-9;

E = calculate_E_curve(z, d, 5, 35e-9, 0.5, 15, 0.90)