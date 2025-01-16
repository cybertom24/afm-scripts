clc;
close all;
clear;

addpath ./funzioni/
addpath ./app/functions/
addpath ./more-colormaps/

set(0, 'DefaultAxesFontSize', 14);
set(0, 'DefaultTextFontSize', 14);

%% --- Morfologia ---

figure;
tiledlayout(1, 2);

Hmap = load_height_map('./dati/exp111/img45.txt');
nexttile;
add_height_map_to_figure(Hmap, 25, '{\mu}m', 'Height map of ACM scan region', slanCM('heat'));

Hmap = load_height_map('./dati/exp111/img85.txt');
nexttile;
add_height_map_to_figure(Hmap, 25, '{\mu}m', 'Height map of ISO scan region', slanCM('heat'));

figure;
tiledlayout(1, 2);

Hmap = load_height_map('./dati/exp111/img98.txt');
nexttile;
add_height_map_to_figure(Hmap, 30, '{\mu}m', 'Height map of ISO scan region', slanCM('heat'));

nexttile;
add_height_map_to_figure(Hmap, 30, '{\mu}m', 'Height map of ISO scan region', slanCM('heat'));

%% --- Curve di calibrazione ---

% -- EXP111 --
figure;
tiledlayout(1, 2);

% ACM
[~, ~, z, Nf] = load_force_curve('./dati/exp111/curve29.txt');
Nf = remove_background(z, Nf, max(z) * 0.8, +Inf);

nexttile;
hold on;
grid on;
plot(z, Nf, 'LineWidth', 2);
title('ACM EXP111 calibration curve on sapphire');
xlabel('z [nm]');
ylabel('d [au]');
pbaspect([1 1 1]);

% ISO
[~, ~, z, Nf] = load_force_curve('./dati/exp111/curve60.txt');
Nf = remove_background(z, Nf, max(z) * 0.8, +Inf);

nexttile;
hold on;
grid on;
plot(z, Nf, 'LineWidth', 2);
title('ISO EXP111 calibration curve on sapphire');
xlabel('z [nm]');
ylabel('d [au]');
pbaspect([1 1 1]);


% -- EXP84/85 --
figure;
tiledlayout(1, 2);

% ACM
[~, ~, z, Nf] = load_force_curve('./dati/exp84-tesi/curve-sapphire-ACM.txt');
Nf = remove_background(z, Nf, max(z) * 0.8, +Inf);

nexttile;
hold on;
grid on;
plot(z, Nf, 'LineWidth', 2);
title('ACM EXP84 calibration curve on sapphire');
xlabel('z [nm]');
ylabel('d [au]');
pbaspect([1 1 1]);

% ISO
[~, ~, z, Nf] = load_force_curve('./dati/exp84-tesi/curve-sapphire-ISO.txt');
Nf = remove_background(z, Nf, max(z) * 0.8, +Inf);

nexttile;
hold on;
grid on;
plot(z, Nf, 'LineWidth', 2);
title('ISO EXP85 calibration curve on sapphire');
xlabel('z [nm]');
ylabel('d [au]');
pbaspect([1 1 1]);

%% --- Analisi superficie ---
Hmap = load_height_map('./dati/exp111/img98.txt');
[count, avg, maxv, minv, med, Ra, Rms, skew, kurt, surf_area, proj_area, theta, phi] = analizza_superficie(Hmap, 30);

fprintf(['count = %d\n' ...
    'avg = %d\n' ...
    'max = %d\n' ...
    'min = %d\n' ...
    'med = %d\n' ...
    'Ra = %d\n' ...
    'Rms = %d\n' ...
    'skew = %d\n' ...
    'kurtosis = %d\n' ...
    'surface area = %d\n' ...
    'projected area = %d\n' ...
    'theta = %d\n' ...
    'phi = %d\n'], count, avg, maxv, minv, med, Ra, Rms, skew, kurt - 3, surf_area, proj_area, 180 - theta * 180/pi, 180 + phi * 180/pi);
