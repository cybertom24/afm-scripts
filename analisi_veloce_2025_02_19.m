addpath ./funzioni
addpath ./app/functions/

k = 3;    % [N/m]
R = 30e-9;  % [m]
v = 0.22;    % []

n = 15;
Rsq_min = 0.95;
b_start = 0.50;

slope = 30;

figure;
hold on;
grid on;
legend show;

[~, ~, z, Nf] = load_force_curve('./dati/psldpe12m_2025_02_19_1.txt');
Nf = remove_background(z, Nf, max(z) * b_start, +Inf);
z = z * 1e-9;
d = (Nf / slope) * 1e-9;
E = calculate_E_curve(z, d, k, R, v, n, Rsq_min);
fprintf('1: %d\n', E);

plot(z, d, 'DisplayName', '1');

[~, ~, z, Nf] = load_force_curve('./dati/psldpe12m_2025_02_19_2.txt');
Nf = remove_background(z, Nf, max(z) * b_start, +Inf);
z = z * 1e-9;
d = (Nf / slope) * 1e-9;
E = calculate_E_curve(z, d, k, R, v, n, Rsq_min);
fprintf('2: %d\n', E);

plot(z, d, 'DisplayName', '2');