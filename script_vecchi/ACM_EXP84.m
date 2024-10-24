clc;
clear;
close all;

dir_E84 = "/home/cyber/Desktop/Università/Tesi/Dati/20240702_Tommaso/ACM_EXP84/"
dir_E27 = "/home/cyber/Desktop/Università/Tesi/Dati/20240702_Tommaso/EXP27ORG/"

figure 1;
plot_raman_spectrum([dir_E84 "ACM_EXP84_532nm_1%_300ms_1800gr" ".txt"], lineWidth);
title("ACM EXP84 - Spettro Raman acquisito con lambda = 532 nm");
axis([200 3500 0 35000]);
xlabel("Shift Raman [cm^{-1}]");
ylabel("Intensità [AU]");

x = 2935;
figure 2;
plot_raman_spectrum_normalized_x([dir_E84 "ACM_EXP84_532nm_1%_300ms_1800gr" ".txt"], x, lineWidth);
hold on;
plot_raman_spectrum_normalized_x([dir_E27 "EXP27ORG_18h_532nm_10%_60s_1800gr_2" ".txt"], x, lineWidth);
line([x, x], [-5, 5], "color", [0 0 0], "LineWidth", lineWidth, "linestyle", "--");
title("ACM EXP84 ed EXP27ORG - Spettri Raman - normalizzati rispetto all'intensità a x = 2935 cm^{-1}");
axis([200 3500 0 4.1]);
xlabel("Shift Raman [cm^{-1}]");
ylabel("Intensità [AU]");

% Spettro raman con l = 532nm, t = 0.3s, convertito da shift ad l assolute
figure 3;
data = convert_raman_shift_in_absolute_wavelength([dir_E84 "ACM_EXP84_532nm_1%_300ms_1800gr" ".txt"], 532e-9);
wl  = data(:,1);
int = data(:,2);
plot(wl, int, "LineWidth", 2);
axis([min(wl) max(wl) 0 max(int)+1000]);

% Colormap dello spettro emesso con l = 532nm. Riga tratteggiata su l = 550nm
figure 4;
imagesc([min(wl)*10^9 max(wl)*10^9], [0 1], int'); 
colormap(jet(numel(int))); 
cb_handle = colorbar;
xlabel("Lunghezza d'onda [nm]");
% Aggiungi la label alla color bar (tramite il suo handle apposito)
ylabel(cb_handle, "Intensità [AU]");
line([550, 550], [-5, 5], "color", [0 0 0], "LineWidth", lineWidth, "linestyle", "--");
axis([540 640 0 1]);
title("ACM EXP84 - Spettro di emissione - eccitazione a 532 nm");

% Nascondi l'asse y
set(gca, 'ytick', []); % Rimuove i tick sull'asse y
set(gca, 'ycolor', 'none'); % Rende invisibile l'asse y


