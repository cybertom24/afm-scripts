clc;
clear;
close all;

addpath ../funzioni/;

dir_E84 = 'C:\Users\savol\Documents\Università\Tesi - Triennale\Dati\RAMAN\ACM_EXP84\';
dir_E27 = 'C:\Users\savol\Documents\Università\Tesi - Triennale\Dati\RAMAN\EXP27ORG\';
dir_E85 = 'C:\Users\savol\Documents\Università\Tesi - Triennale\Dati\RAMAN\ISO_EXP85\';

lineWidth = 1;

%% Breve termine EXP27 532 nm
figure;
hold on;
grid on;
plot_raman_spectrum_normalized_minmax([dir_E27 'EXP27ORG_532nm_10%_10s_1800gr_0' '.txt'], lineWidth, '1°');
plot_raman_spectrum_normalized_minmax([dir_E27 'EXP27ORG_532nm_10%_10s_1800gr_1' '.txt'], lineWidth, '2°');
plot_raman_spectrum_normalized_minmax([dir_E27 'EXP27ORG_532nm_10%_10s_1800gr_2' '.txt'], lineWidth, '3°');
plot_raman_spectrum_normalized_minmax([dir_E27 'EXP27ORG_532nm_10%_10s_1800gr_3' '.txt'], lineWidth, '4°');
plot_raman_spectrum_normalized_minmax([dir_E27 'EXP27ORG_532nm_10%_10s_1800gr_4' '.txt'], lineWidth, '5°');
plot_raman_spectrum_normalized_minmax([dir_E27 'EXP27ORG_532nm_10%_10s_1800gr_5' '.txt'], lineWidth, '6°');
plot_raman_spectrum_normalized_minmax([dir_E27 'EXP27ORG_532nm_10%_10s_1800gr_6' '.txt'], lineWidth, '7°');
legend('show', 'location', 'northwest');
title('EXP27ORG - 532 nm - da 200 a 3500 cm^{-1} - 10%, 10s, 1 acc');
axis([200 3500 0 1]);
xlabel('Shift Raman [cm^{-1}]');
ylabel('Intensità [AU]');
%set(gca, 'ytick', []); % Rimuove i tick sull'asse y

%% Lungo termine EXP27 532 nm
figure;
hold on;
grid on;
plot_raman_spectrum_normalized_minmax([dir_E27 'EXP27ORG_532nm_10%_60s_1800gr_buono' '.txt'], lineWidth, '~2h');
plot_raman_spectrum_normalized_minmax([dir_E27 'EXP27ORG_18h_532nm_10%_60s_1800gr_2' '.txt'], lineWidth, '~18h');
%plot_raman_spectrum([dir 'EXP27ORG_32h_532nm_10%_60s_1800gr_nocalib' '.txt'], lineWidth);
legend('show', 'location', 'northwest');
title('EXP27ORG - 532 nm - da 200 a 3500 cm^{-1} - 10%, 60s, 1 acc');
axis([200 3500 0 1]);
xlabel('Shift Raman [cm^{-1}]');
ylabel('Intensità [AU]');
%set(gca, 'ytick', []); % Rimuove i tick sull'asse y

%% 532 nm
figure;
hold on;
grid on;
plot_raman_spectrum_normalized_minmax([dir_E27 'EXP27ORG_18h_532nm_10%_60s_1800gr_2' '.txt'], lineWidth, 'EXP27ORG');
plot_raman_spectrum_normalized_minmax([dir_E84 'ACM_EXP84_532nm_1%_300ms_1800gr' '.txt'], lineWidth, 'ACM-EXP84');
legend('show', 'location', 'north');
title('532 nm - da 200 a 3500 cm^{-1}');
axis([200 3500 0 1]);
xlabel('Shift Raman [cm^{-1}]');
ylabel('Intensità [AU]');
% Nascondi l'asse y
%set(gca, 'ytick', []); % Rimuove i tick sull'asse y

%% 638 nm
figure;
hold on;
grid on;
plot_raman_spectrum_normalized_minmax([dir_E27 'EXP27ORG_32h_638nm_10%_60s_1800gr' '.txt'], lineWidth, 'EXP27ORG');
plot_raman_spectrum_normalized_minmax([dir_E84 'ACM_EXP84_22h_638nm_10%_40s_1800gr' '.txt'], lineWidth, 'ACM-EXP84');
plot_raman_spectrum_normalized_minmax([dir_E85 'ISO_EXP85_638nm_10%_40s_1800gr' '.txt'], lineWidth, 'ISO-EXP85');
legend('show', 'location', 'southwest');
title('638 nm - da 200 a 3500 cm^{-1}');
axis([200 3500 0 1]);
xlabel('Shift Raman [cm^{-1}]');
ylabel('Intensità [AU]');
% Nascondi l'asse y
%set(gca, 'ytick', []); % Rimuove i tick sull'asse y

%% 532 nm vs 638 nm EXP27
figure;
hold on;
grid on;
plot_raman_spectrum_normalized_minmax([dir_E27 'EXP27ORG_18h_532nm_10%_60s_1800gr_2' '.txt'], lineWidth, '532 nm');
plot_raman_spectrum_normalized_minmax([dir_E27 'EXP27ORG_32h_638nm_10%_60s_1800gr' '.txt'], lineWidth, '638 nm');
legend('show', 'location', 'west');
title('EXP27ORG - 532 nm vs 638 nm - da 200 a 3500 cm^{-1}');
axis([200 3500 0 1]);
xlabel('Shift Raman [cm^{-1}]');
ylabel('Intensità [AU]');
% Nascondi l'asse y
%set(gca, 'ytick', []); % Rimuove i tick sull'asse y

%% 638 nm al massimo
figure;
hold on;
grid on;
%plot_raman_spectrum_normalized_x([dir_E85 'ISO_EXP85_638nm_10%_40s_1800gr' '.txt'], 2500, lineWidth);
plot_raman_spectrum_normalized_minmax([dir_E85 'ISO_EXP85_638nm_[2500-3100]_10%_20s_3acc_1800gr' '.txt'], lineWidth, '20s - 3 acc');
plot_raman_spectrum_normalized_minmax([dir_E85 'ISO_EXP85_638nm_[2500-3100]_10%_60s_1acc_1800gr' '.txt'], lineWidth, '60s - 1 acc');
plot_raman_spectrum_normalized_minmax([dir_E85 'ISO_EXP85_638nm_[2500-3100]_10%_120s_1acc_1800gr' '.txt'], lineWidth, '120s - 1 acc');
plot_raman_spectrum_normalized_minmax([dir_E85 'ISO_EXP85_638nm_[2500-3100]_10%_120s_2acc_1800gr' '.txt'], lineWidth, '120s - 2 acc');
plot_raman_spectrum_normalized_minmax([dir_E85 'ISO_EXP85_638nm_[2500-3100]_10%_120s_3acc_1800gr' '.txt'], lineWidth, '120s - 3 acc');
plot_raman_spectrum_normalized_minmax([dir_E85 'ISO_EXP85_638nm_[2500-3100]_10%_360s_1acc_1800gr' '.txt'], lineWidth, '360s - 1 acc');
legend('show', 'location', 'southwest');
title('ISO-EXP85 - 638nm - da 2500 a 3100 cm^{-1}');
axis([2500 3100 0 1]);
xlabel('Shift Raman [cm^{-1}]');
ylabel('Intensità [AU]');
% Nascondi l'asse y
%set(gca, 'ytick', []); % Rimuove i tick sull'asse y

%% Spettro lunghezze d'onda

% Spettro raman con l = 532nm, t = 0.3s, convertito da shift ad l assolute
data = convert_raman_shift_in_absolute_wavelength([dir_E84 'ACM_EXP84_532nm_1%_300ms_1800gr' '.txt'], 532e-9);
wl  = data(:,1);
int = data(:,2);

% Colormap dello spettro emesso con l = 532nm. Riga tratteggiata su l = 550nm
figure;
imagesc([min(wl)*10^9 max(wl)*10^9], [0 10], int'); 
colormap(jet(numel(int))); 
cb_handle = colorbar;
xlabel("Lunghezza d'onda [nm]");
% Aggiungi la label alla color bar (tramite il suo handle apposito)
ylabel(cb_handle, 'Intensità [AU]');
xline(550, 'Color', [0.15 0.15 0.15], 'LineWidth', lineWidth, 'LineStyle', '--');
axis image;
title('ACM-EXP84 - Spettro di emissione - eccitazione a 532 nm');
%text(550, 24, '550', 'Color', [0.15 0.15 0.15], 'HorizontalAlignment','center', 'VerticalAlignment', 'middle', 'FontSize', 11);
xticks([540 550 560 580 600 620 640]);
yticks([]); % Rimuove i tick sull'asse y