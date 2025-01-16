clc;
close all;
clear;

addpath ./funzioni/
addpath ./app/functions/

set(0, 'DefaultAxesFontSize', 14);
set(0, 'DefaultTextFontSize', 14);

slope = 377.5;
k = 0.5;
R = 35e-9;
v = 0.5;
n = 15;
Rsq_min = 0.95;

figure;
hold on;
grid on;
legend show;
title('Comparison between different acquisition speeds');
xlabel('z [nm]');
ylabel('F [nN]');

[~, ~, z, Nf] = load_force_curve('./dati/exp84/curva60-2024_08_11-50nm_s.txt');
Nf = remove_background(z, Nf, 0.80 * max(z), Inf);
d = Nf / slope;
plot(z, d * k, 'DisplayName', '(60) 50 nm/s', 'LineWidth', 2);
E = calculate_E_curve(z * 1e-9, d * 1e-9, k, R, v, n, Rsq_min);
fprintf('60) E: %f MPa\n', E * 1e-6);

[~, ~, z, Nf] = load_force_curve('./dati/exp84/curva61-2024_08_11-62.5nm_s.txt');
Nf = remove_background(z, Nf, 0.80 * max(z), Inf);
d = Nf / slope;
plot(z, d * k, 'DisplayName', '(61) 62.5 nm/s', 'LineWidth', 2);
E = calculate_E_curve(z * 1e-9, d * 1e-9, k, R, v, n, Rsq_min);
fprintf('61) E: %f MPa\n', E * 1e-6);

[~, ~, z, Nf] = load_force_curve('./dati/exp84/curva62-2024_08_11-20nm_s.txt');
Nf = remove_background(z, Nf, 0.80 * max(z), Inf);
d = Nf / slope;
plot(z, d * k, 'DisplayName', '(62) 20 nm/s', 'LineWidth', 2);
E = calculate_E_curve(z * 1e-9, d * 1e-9, k, R, v, n, Rsq_min);
fprintf('62) E: %f MPa\n', E * 1e-6);

[~, ~, z, Nf] = load_force_curve('./dati/exp84/curva63-2024_08_11-1000nm_s.txt');
Nf = remove_background(z, Nf, 0.80 * max(z), Inf);
d = Nf / slope;
plot(z, d * k, 'DisplayName', '(63) 1000 nm/s', 'LineWidth', 2);
E = calculate_E_curve(z * 1e-9, d * 1e-9, k, R, v, n, Rsq_min);
fprintf('63) E: %f MPa\n', E * 1e-6);

[~, ~, z, Nf] = load_force_curve('./dati/exp84/curva64-2024_08_11-20nm_s-2.txt');
Nf = remove_background(z, Nf, 0.80 * max(z), Inf);
d = Nf / slope;
plot(z, d * k, 'DisplayName', '(64) 20 nm/s', 'LineWidth', 2);
E = calculate_E_curve(z * 1e-9, d * 1e-9, k, R, v, n, Rsq_min);
fprintf('64) E: %f MPa\n', E * 1e-6);

[~, ~, z, Nf] = load_force_curve('./dati/exp84/curva65-2024_08_11-50nm_s-2.txt');
Nf = remove_background(z, Nf, 0.80 * max(z), Inf);
d = Nf / slope;
plot(z, d * k, 'DisplayName', '(65) 50 nm/s', 'LineWidth', 2);
E = calculate_E_curve(z * 1e-9, d * 1e-9, k, R, v, n, Rsq_min);
fprintf('65) E: %f MPa\n', E * 1e-6);