clc;
clear;
close all;

dir_E84 = "/home/cyber/Desktop/Università/Tesi/Dati/20240702_Tommaso/ACM_EXP84/";
dir_E27 = "/home/cyber/Desktop/Università/Tesi/Dati/20240702_Tommaso/EXP27ORG/";
dir_E85 = "/home/cyber/Desktop/Università/Tesi/Dati/20240702_Tommaso/ISO_EXP85/";

lineWidth = 2;

figure 1;
plot_raman_spectrum([dir_E84 "ACM_EXP84_22h_638nm_10%_40s_1800gr" ".txt"], lineWidth);
hold on;
plot_raman_spectrum([dir_E27 "EXP27ORG_32h_638nm_10%_60s_1800gr" ".txt"], lineWidth);
legend("ACM EXP84 - 40s", "EXP27ORG - 60s");
title("ACM EXP84 vs EXP27ORG - Spettro Raman 638nm, 10%, 1800 l/mm");
axis([200 3500 0 45000]);
xlabel("Shift Raman [cm^{-1}]");
ylabel("Intensità [AU]");

figure 2;
plot_raman_spectrum([dir_E84 "ACM_EXP84_22h_638nm_10%_40s_1800gr" ".txt"], lineWidth);
hold on;
plot_raman_spectrum([dir_E85 "ISO_EXP85_638nm_10%_40s_1800gr" ".txt"], lineWidth);
legend("ACM EXP84", "ISO EXP85");
title("ACM EXP84 vs ISO EXP85 - Spettro Raman 638nm, 10%, 40s, 1800 l/mm");
axis([200 3500 0 45000]);
xlabel("Shift Raman [cm^{-1}]");
ylabel("Intensità [AU]");

figure 3;
plot_raman_spectrum_normalized([dir_E84 "ACM_EXP84_22h_638nm_10%_40s_1800gr" ".txt"], lineWidth);
hold on;
plot_raman_spectrum_normalized([dir_E85 "ISO_EXP85_638nm_10%_40s_1800gr" ".txt"], lineWidth);
legend("ACM EXP84", "ISO EXP85");
title("ACM EXP84 vs ISO EXP85 - Spettro Raman 638nm, 10%, 40s, 1800 l/mm - normalizzati rispetto al val max");
axis([200 3500 0 1.1]);
xlabel("Shift Raman [cm^{-1}]");
ylabel("Intensità [rel al val max]");

figure 4;
plot_raman_spectrum_normalized_x([dir_E85 "ISO_EXP85_638nm_10%_40s_1800gr" ".txt"], 2500, lineWidth);
hold on;
plot_raman_spectrum_normalized([dir_E85 "ISO_EXP85_638nm_[2500-3100]_10%_20s_3acc_1800gr" ".txt"], lineWidth);
plot_raman_spectrum_normalized([dir_E85 "ISO_EXP85_638nm_[2500-3100]_10%_60s_1acc_1800gr" ".txt"], lineWidth);
plot_raman_spectrum_normalized([dir_E85 "ISO_EXP85_638nm_[2500-3100]_10%_120s_1acc_1800gr" ".txt"], lineWidth);
plot_raman_spectrum_normalized([dir_E85 "ISO_EXP85_638nm_[2500-3100]_10%_120s_2acc_1800gr" ".txt"], lineWidth);
plot_raman_spectrum_normalized([dir_E85 "ISO_EXP85_638nm_[2500-3100]_10%_120s_3acc_1800gr" ".txt"], lineWidth);
plot_raman_spectrum_normalized([dir_E85 "ISO_EXP85_638nm_[2500-3100]_10%_360s_1acc_1800gr" ".txt"], lineWidth);
legend("40s - 1 acc", "20s - 3 acc", "60s - 1 acc", "120s - 1 acc", "120s - 2 acc", "120s - 3 acc", "360s - 1 acc");
title("ISO EXP85 - Spettro Raman 638nm, 10%, 1800 l/mm - normalizzati rispetto al val max");
axis([2500 3100 0.5 1.1]);
xlabel("Shift Raman [cm^{-1}]");
ylabel("Intensità [rel al val max]");

figure 5;
plot_raman_spectrum_normalized_minmax([dir_E85 "ISO_EXP85_638nm_[2500-3100]_10%_20s_3acc_1800gr" ".txt"], lineWidth);