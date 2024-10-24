clc;
clear;
close all;

addpath ./funzioni/;

dir_E84 = 'C:\Users\savol\Documents\Università\Tesi\Dati\RAMAN\ACM_EXP84\';
dir_E27 = 'C:\Users\savol\Documents\Università\Tesi\Dati\RAMAN\EXP27ORG\';
dir_E85 = 'C:\Users\savol\Documents\Università\Tesi\Dati\RAMAN\ISO_EXP85\';

lineWidth = 1;

%% 532 nm
figure;
hold on;
grid on;
plot_raman_spectrum_normalized_minmax([dir_E27 'EXP27ORG_18h_532nm_10%_60s_1800gr_2' '.txt'], lineWidth, 'Non colorato');
plot_raman_spectrum_normalized_minmax([dir_E84 'ACM_EXP84_532nm_1%_300ms_1800gr' '.txt'], lineWidth, 'Colorato');
legend('show', 'location', 'north');
title('\lambda = 532 nm');
axis([200 3500 0 1]);
xlabel('Shift Raman [cm^{-1}]');
ylabel('Intensità [AU]');

%% 638 nm
figure;
hold on;
grid on;
plot_raman_spectrum_normalized_minmax([dir_E27 'EXP27ORG_32h_638nm_10%_60s_1800gr' '.txt'], lineWidth, 'Non colorato');
plot_raman_spectrum_normalized_minmax([dir_E84 'ACM_EXP84_22h_638nm_10%_40s_1800gr' '.txt'], lineWidth, 'ACM (colorato)');
plot_raman_spectrum_normalized_minmax([dir_E85 'ISO_EXP85_638nm_10%_40s_1800gr' '.txt'], lineWidth, 'ISO (colorato)');
legend('show', 'location', 'southwest');
title('\lambda = 638 nm');
axis([200 3500 0 1]);
xlabel('Shift Raman [cm^{-1}]');
ylabel('Intensità [AU]');

%% 532 nm vs 638 nm EXP27
figure;
hold on;
grid on;
plot_raman_spectrum_normalized_minmax([dir_E27 'EXP27ORG_18h_532nm_10%_60s_1800gr_2' '.txt'], lineWidth, '532 nm');
plot_raman_spectrum_normalized_minmax([dir_E27 'EXP27ORG_32h_638nm_10%_60s_1800gr' '.txt'], lineWidth, '638 nm');
legend('show', 'location', 'west');
title('Non colorato - 532 nm vs 638 nm');
axis([200 3500 0 1]);
xlabel('Shift Raman [cm^{-1}]');
ylabel('Intensità [AU]');