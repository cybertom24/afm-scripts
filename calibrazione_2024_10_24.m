clc;
clear;
close all;

addpath ./funzioni/

k = 0.5;    % N/m
R = 35e-9;  % m
v = 0.22;   % 1

marker_size = 150;

[zaff_zl, zaff_Nfl, zaff_zu, zaff_Nfu] = load_curva_forza('./dati/zaffiro_DZ_2024_10_24_801pt_2mspt.txt');

figure;
legend show;
grid on;
hold on;
plot(zaff_zl, zaff_Nfl, 'DisplayName', 'load');
plot(zaff_zu, zaff_Nfu, 'DisplayName', 'unload');

[ml, ql] = fitta_retta_parziale(zaff_zl, zaff_Nfl, -Inf, 0);
[mu, qu] = fitta_retta_parziale(zaff_zu, zaff_Nfu, -Inf, 0);

z = min(zaff_zl):0.25:0;

plot(z, z*ml + ql, 'DisplayName', 'fit load');
plot(z, z*mu + qu, 'DisplayName', 'fit unload');

fprintf('slope load: %f au/nm\nslope unload: %f au/nm\n', -ml, -mu);

% Inizio

% Calibra lo strumento
[~, slope] = calibra('./dati/zaffiro_DZ_2024_10_24_801pt_2mspt.txt');

% Carica la curva di forza
[zl, Nfl, zu, Nfu] = load_curva_forza('./dati/psldpe12m_DZ_2024_10_24_801pt_2mspt.txt');

% Rimuovi il background
[Nfu_nob, b] = rimuovi_background(zu, Nfu, max(zu)/2, max(zu));

figure;
grid on;
hold on;
legend show;
scatter(zu, Nfu, 'Marker', '.', 'SizeData', marker_size, 'DisplayName','curva DZ');
scatter(zu, Nfu_nob, 'Marker', '.', 'SizeData', marker_size, 'DisplayName','curva DZ senza background');
plot(zu, b, 'DisplayName', 'background', 'LineWidth',2);
title('Curva DZ con e senza background');
xlabel('z [nm]');
ylabel('Nf [au]');
xlim([-10 100]);

d = Nfu_nob / slope;

% Shifta ora tutto in modo che quando d = 0 anche z = 0
d = d - d(zu == 0);

figure;
grid on;
hold on;
legend show;
scatter(zu, d, 'Marker', '.', 'SizeData', marker_size, 'DisplayName','curva DZ');
title('Curva DZ con e senza background, riscalata e shiftata');
xlabel('z [nm]');
ylabel('d [nm]');
xlim([-10 100]);

z = zu * 1e-9;
d = d * 1e-9;

% Calcola h
h = (-z) - d;

figure;
grid on;
hold on;
legend('show', 'location', 'northwest');
scatter(h, d, 'Marker', '.', 'SizeData', marker_size, 'DisplayName','curva DH');
title('Curva DH');
xlabel('h [m]');
ylabel('d [m]');
xlim([-6e-9 1e-9]);

% D'ora in poi lavora solo con h >= 0
d = d(h > 0);
h = h(h > 0);

% Fitta solo l'ultima parte
%h_media = mean(h);
%f2fit = f(h >= h_media);
%h2fit = h(h >= h_media);

% Linearizza e fitta con la retta
d = potenza(d, 2/3);

[m, q, sigma, sigma_m] = fitta_retta(h, d);
    
if m <= 0
   E = NaN;
   Erid = NaN;
   u_E = NaN;
   u_Erid = NaN;
   return;
end

figure;
grid on;
hold on;
legend('show', 'location', 'northwest');
scatter(h, d, 'DisplayName', 'curva DH linearizzata', 'Marker', '.', 'SizeData', marker_size);
% scatter(h2fit, f2fit, 'DisplayName','curva FH linearizzata da fittare');
plot(h, h*m + q, 'DisplayName','fit');
title('Porzione di curva DH linearizzata');
xlabel('h [m]');
ylabel('d^{2/3} [m^{2/3}]');    

% Calcola E
Erid = (m ^ 1.5) * 0.75 * k / sqrt(R);
E = Erid * (1 - v^2);
u_Erid = 9/8 * sqrt(m/R) * sigma_m;
u_E = u_Erid * (1 - v^2);

calcola_E_da_curva_z_Nf(zu, Nfu, slope, k, R, v)