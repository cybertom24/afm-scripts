clc;
clear;
close all;

addpath ./funzioni/

k = 2;    % N/m
R = 10e-9;  % m
v = 0.22;   % 1

marker_size = 100;

% Inizio

% Calibra lo strumento
[~, slope] = calibra('./dati/zaffiro_DZ_2024_10_25_801pt_4mspt_5x.txt');

% Carica la curva di forza
[zu, Nfu, ~, ~] = load_curva_forza('./dati/curva-ldpe.txt');

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
z = zu;

%F = d * k;

%figure;
%grid on;
%hold on;
%legend show;
%scatter(z, F, 'Marker', '.', 'SizeData', marker_size, 'DisplayName','curva FZ');
%title('Curva FZ');
%xlabel('z [nm]');
%ylabel('F [N]'); 

figure;
grid on;
hold on;
legend show;
scatter(z, d, 'Marker', '.', 'SizeData', marker_size, 'DisplayName','curva DZ');
title('Curva DZ senza background e riscalata');
xlabel('z [nm]');
ylabel('d [nm]'); 

% Scegli come punto di contatto il minimo
[d_min, i_min] = min(d);
z = z - z(i_min);
d = d - d_min;

% Segli la z minima
soglia = -30;

% Restringi la curva
d = d(z >= soglia);
z = z(z >= soglia);

figure;
grid on;
hold on;
legend show;
scatter(z, d, 'Marker', '.', 'SizeData', marker_size, 'DisplayName','curva DZ');
scatter(dx,dy,'DisplayName','dy', 'Marker', '.');
scatter(dx2,dy2,'DisplayName','d^2y', 'Marker', '.');
title('Curva DZ senza la parte a pendenza pari a slope e shiftata');
xlabel('z [nm]');
ylabel('d [nm]');
%xlim([-10 100]);

%%

z = z * 1e-9;
d = d * 1e-9;

% Calcola h
h = (-z) - d;

figure;
grid on;
hold on;
legend('show', 'location', 'northwest');
scatter(z, h, 'Marker', '.', 'SizeData', marker_size, 'DisplayName','curva DH');
title('Curva DH');
xlabel('h [m]');
ylabel('d [m]');
%xlim([-6e-9 1e-9]);

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
   fprintf('Errore\n')
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