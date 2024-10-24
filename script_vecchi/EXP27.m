clc;
clear;
close all;

addpath ./funzioni/;

% Esempio di concatenazione
dir = 'C:\Users\savol\Documents\Università\Tesi\Dati\RAMAN\EXP27ORG\';
file = [dir 'EXP27ORG_532nm_10%_60s_1800gr_buono.txt'];

lineWidth = 1;

figure;
plot_raman_spectrum([dir 'EXP27ORG_532nm_10%_10s_1800gr_0' '.txt'], lineWidth, '1°');
hold on;
plot_raman_spectrum([dir 'EXP27ORG_532nm_10%_10s_1800gr_1' '.txt'], lineWidth, '2°');
plot_raman_spectrum([dir 'EXP27ORG_532nm_10%_10s_1800gr_2' '.txt'], lineWidth, '3°');
plot_raman_spectrum([dir 'EXP27ORG_532nm_10%_10s_1800gr_3' '.txt'], lineWidth, '4°');
plot_raman_spectrum([dir 'EXP27ORG_532nm_10%_10s_1800gr_4' '.txt'], lineWidth, '5°');
plot_raman_spectrum([dir 'EXP27ORG_532nm_10%_10s_1800gr_5' '.txt'], lineWidth, '6°');
plot_raman_spectrum([dir 'EXP27ORG_532nm_10%_10s_1800gr_6' '.txt'], lineWidth, '7°');
legend('show', 'location', 'northwest');
grid on;
title('EXP27ORG - Spettri Raman acquisiti in successione');
axis([200 3500 0 14000]);
xlabel('Shift Raman [cm^{-1}]');
ylabel('Intensità [AU]');

figure;
hold on;
plot_raman_spectrum_normalized_minmax([dir 'EXP27ORG_532nm_10%_10s_1800gr_0' '.txt'], lineWidth, '1°');
plot_raman_spectrum_normalized_minmax([dir 'EXP27ORG_532nm_10%_10s_1800gr_1' '.txt'], lineWidth, '2°');
plot_raman_spectrum_normalized_minmax([dir 'EXP27ORG_532nm_10%_10s_1800gr_2' '.txt'], lineWidth, '3°');
plot_raman_spectrum_normalized_minmax([dir 'EXP27ORG_532nm_10%_10s_1800gr_3' '.txt'], lineWidth, '4°');
plot_raman_spectrum_normalized_minmax([dir 'EXP27ORG_532nm_10%_10s_1800gr_4' '.txt'], lineWidth, '5°');
plot_raman_spectrum_normalized_minmax([dir 'EXP27ORG_532nm_10%_10s_1800gr_5' '.txt'], lineWidth, '6°');
plot_raman_spectrum_normalized_minmax([dir 'EXP27ORG_532nm_10%_10s_1800gr_6' '.txt'], lineWidth, '7°');
legend('show', 'location', 'northwest');
grid on;
title('EXP27ORG - Spettri Raman acquisiti in successione');
axis([200 3500 0 1.1]);
xlabel('Shift Raman [cm^{-1}]');
ylabel('Intensità [AU]');

figure;
plot_raman_spectrum([dir 'EXP27ORG_532nm_10%_60s_1800gr_buono' '.txt'], lineWidth, '~2h');
hold on;
plot_raman_spectrum([dir 'EXP27ORG_18h_532nm_10%_60s_1800gr_2' '.txt'], lineWidth, '~18h');
%plot_raman_spectrum([dir 'EXP27ORG_32h_532nm_10%_60s_1800gr_nocalib' '.txt'], lineWidth);
legend('show', 'location', 'northwest');
title('EXP27ORG - Spettri Raman acquisiti ore dopo la deposizione');
axis([200 3500 0 30000]);
xlabel('Shift Raman [cm^{-1}]');
ylabel('Intensità [AU]');

figure;
plot_raman_spectrum_normalized_minmax([dir 'EXP27ORG_532nm_10%_60s_1800gr_buono' '.txt'], lineWidth, '~2h');
hold on;
plot_raman_spectrum_normalized_minmax([dir 'EXP27ORG_18h_532nm_10%_60s_1800gr_2' '.txt'], lineWidth, '~18h');
%plot_raman_spectrum([dir 'EXP27ORG_32h_532nm_10%_60s_1800gr_nocalib' '.txt'], lineWidth);
legend('show', 'location', 'northwest');
title('EXP27ORG - Spettri Raman acquisiti ore dopo la deposizione - normalizzati rispetto al valore massimo');
axis([200 3500 0 1.1]);
xlabel('Shift Raman [cm^{-1}]');
ylabel('Intensità [relativo al massimo]');


