clc;
clear;
close all;

dir = "/home/cyber/Desktop/Università/Tesi/Dati/20240702_Tommaso/old/"
%dir_E27 = "/home/cyber/Desktop/Università/Tesi/Dati/20240702_Tommaso/EXP27ORG/"

set(0, "defaultaxesfontsize", 22);  % Imposta la dimensione del font degli assi
set(0, "defaulttextfontsize", 22);  % Imposta la dimensione del font del testo
lineWidth = 2;

figure 1;
plot_raman_spectrum([dir "ACM_old_532nm_10%_05s_1800gr" ".txt"], lineWidth);
hold on;
plot_raman_spectrum([dir "ISO_old_532nm_10%_1s_1800gr" ".txt"], lineWidth);
legend("ACM old - 0.5s", "ISO old - 1s");
title("old - Spettri Raman - 532nm, 10%, 1800 l/mm");
axis([200 3500 0 18000]);
xlabel("Shift Raman [cm^{-1}]");
ylabel("Intensità [AU]");