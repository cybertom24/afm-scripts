% Analisi e riconoscimento dei picchi nello spettro del campione EXP27ORG
clc;
clear;
close all;

dir_E84 = "/home/cyber/Desktop/Università/Tesi/Dati/20240702_Tommaso/ACM_EXP84/";
dir_E27 = "/home/cyber/Desktop/Università/Tesi/Dati/20240702_Tommaso/EXP27ORG/";
dir_E85 = "/home/cyber/Desktop/Università/Tesi/Dati/20240702_Tommaso/ISO_EXP85/";

lineWidth = 2;
picchi = {  { 749, "Acidi nucleici, DNA, nucleoproteine Trp., citocromo"}, ...
            {1004, "Amminoacidi, fenilanina"}, ...
            {1062, "Acidi nucleici, lipidi, proteine"}, ...
            {1070, "Acidi nucleici, lipidi, proteine"}, ...
            {1129, "Lactato, lipidi saturi, citocromo, fosfatidi, glucosio"}, ...
            {1156, "Carotenoidi"}, ...
            {1170, "GMP, pirimidina"}, ...
            {1223, "Ammide 3°, fibrina, fosfolipidi"}, ...
            {1245, "DNA/RNA"}, ...
            {1304, "Lipidi, proteine (amminoacidi alifatici)"}, ...
            {1334, "Lipidi, proteine (amminoacidi alifatici)"}, ...
            {1360, "DeossiEmoglobina, proteina ferrica"}, ...
            {1432, "Lipidi, proteine"}, ...
            {1438, "Lipidi, proteine"}, ...
            {1516, "Carotenoidi, emoproteina"}, ...
            {1550, "Ammide 2°, proteine, beta-foglio delle proteine"}, ...
            {1575, "DNA"}, ...
            {1587, "Proteine fosforilate, Trp. Mit. Cyt. heme"}, ...
            {1652, "alfa-elica delle proteine, lipidi insaturi"}, ...
            {1672, "Ammide 1°, apoproteina"}, ...
            {1750, "Lipidi"}, ...
            {2848, "Acidi grassi, lipidi"}, ...
            {2905, "Proteine"}, ...
            {2931, "Lipoproteine"}, ...
            {3009, "Lipidi, acidi grassi insaturi =C-H"} };

figure 1;
show_raman_peaks([dir_E27 "EXP27ORG_18h_532nm_10%_60s_1800gr_2_BKGREM(7deg_200pt)" ".txt"], picchi, lineWidth)
% Spettro
%plot_raman_spectrum_normalized_minmax([dir_E27 "EXP27ORG_18h_532nm_10%_60s_1800gr_2_BKGREM(7deg_200pt)" ".txt"], lineWidth);
% Picchi
%line([2848 2848], [-5 5], "color", [rand() rand() rand()], "LineWidth", lineWidth, "linestyle", "--");
%line([2848 2848], [-5 5], "color", [rand() rand() rand()], "LineWidth", lineWidth, "linestyle", "--");
%line([2905 2931], [-5 5], "color", [rand() rand() rand()], "LineWidth", lineWidth, "linestyle", "--");
%line([2931 2931], [-5 5], "color", [rand() rand() rand()], "LineWidth", lineWidth, "linestyle", "--");
%line([3009 3009], [-5 5], "color", [rand() rand() rand()], "LineWidth", lineWidth, "linestyle", "--");

%legend("Spettro Raman", "Acidi grassi, lipidi", "Proteine", "Lipoproteine", "Lipidi, acidi grassi insaturi, =C-H", "location", "northwest");
title("EXP27ORG - 18h dopo, 532 nm, 10%, 60s, 1 acc, BKG rimosso (7deg, 200pt) - normalizzato");
axis([200 3500 0 1]);
xlabel("Shift Raman [cm^{-1}]");
ylabel("Intensità [AU]");
% Nascondi l'asse y
set(gca, 'ytick', []); % Rimuove i tick sull'asse y

