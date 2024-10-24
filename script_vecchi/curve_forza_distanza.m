clc;
close all;
clear;

data = load("curva-zaffiro-11_07_2024.txt");
dist = data(:,1);
f = data(:,2);

dist_load = dist(1:end/2);
f_load = f(1:end/2);

dist_unload = dist((end/2+1):end);
f_unload = f((end/2+1):end);

figure;
hold on;
grid on;
scatter(dist_load, f_load, 'DisplayName','load');
scatter(dist_unload, f_unload,'DisplayName','unload');
legend show;

x_start = 4;
x_end = -2;
x = x_end:1:x_start;

[m_load, q_load] = fitta_retta_parziale(dist_load, f_load, x_start, x_end)
f_fit_load = m_load * x + q_load;
plot(x, f_fit_load, 'DisplayName','load - fit');

[m_unload, q_unload] = fitta_retta_parziale(dist_unload, f_unload, x_start, x_end)
f_fit_unload = m_unload * x + q_unload;
plot(x, f_fit_unload, 'DisplayName','unload - fit');

slope = 326;
k = 5;
R = 35e-9;
v = 0.4;

% Prova

E = calcola_E_modH(dist_load, f_load, slope, k, R, v);
% In MPa
E * 1e-6