clear;
close all;
clc;

set(0, "defaultaxesfontsize", 12);  % Imposta la dimensione del font degli assi
set(0, "defaulttextfontsize", 12);  % Imposta la dimensione del font del testo

% Caratteristiche punta e campione
k = 8.5;      % N/m
R = 25e-9;  % nm
v = 0.22;

[zaff_zl, zaff_Nfl, zaff_zu, zaff_Nfu] = load_curva_forza('curva-zaffiro-11_07_2024.txt');

figure;
hold on;
grid on;
title('Calibrazione con zaffiro');
xlabel('z [nm]');
ylabel('Nf [au]');
scatter(zaff_zl, zaff_Nfl, 'DisplayName','load', 'Marker','.');
scatter(zaff_zu, zaff_Nfu, 'DisplayName','unload', 'Marker','.');
legend show;

% Rimozione del background
[zaff_Nfl, b_l] = rimuovi_background(zaff_zl, zaff_Nfl, 60, 100);
[zaff_Nfu, b_u] = rimuovi_background(zaff_zu, zaff_Nfu, 60, 100);

plot(zaff_zl, b_l, 'DisplayName','background - load');
plot(zaff_zu, b_u, 'DisplayName','background - unload');

figure;
hold on;
grid on;
title('Calibrazione con zaffiro - no background');
xlabel('z [nm]');
ylabel('Nf [au]');
scatter(zaff_zl, zaff_Nfl, 'DisplayName','load', 'Marker','.');
scatter(zaff_zu, zaff_Nfu, 'DisplayName','unload', 'Marker','.');
legend show;

% [da Kontomaris 2017, pag. 10]
% Assumendo che non ci siano identazioni, quando la punta va in contatto la
% deflessione dovrebbe essere uguale alla posizione z
% Devo quindi trovare quel valore di 'slope' che porta ad avere 
% def (= Nf / slope) = |z| nella zona dopo lo zero (occhio ai segni)
% Visto quindi che Nf / slope = |z| -> slope = Nf / |z|.
% Fitto quindi la parte negativa per poter recuperare la slope

slopel = abs(fitta_retta_parziale(zaff_zl, zaff_Nfl, 0, -10));
slopeu = abs(fitta_retta_parziale(zaff_zu, zaff_Nfu, 0, -10));

% Calcolo la deflessione del cantilever
zaff_defl = zaff_Nfl / slopel;
zaff_defu = zaff_Nfu / slopeu;

figure;
hold on;
grid on;
title('Calibrazione con zaffiro - deflessione');
xlabel('z [nm]');
ylabel('def [nm]');
scatter(zaff_zl, zaff_defl, 'DisplayName','load', 'Marker','.');
scatter(zaff_zu, zaff_defu, 'DisplayName','unload', 'Marker','.');
legend show;

% Ottenuto quindi il fattore di scala posso caricare la curva che mi
% interessa

[ps_zl, ps_Nfl, ps_zu, ps_Nfu] = load_curva_forza('curva-ISO-11_07_2024.txt');

figure;
hold on;
grid on;
title('Substrato PS');
xlabel('z [nm]');
ylabel('Nf [au]');
scatter(ps_zl, ps_Nfl, 'DisplayName','load', 'Marker','.');
scatter(ps_zu, ps_Nfu, 'DisplayName','unload', 'Marker','.');
legend show;

% Rimozione del background
[ps_Nfl, b_l] = rimuovi_background(ps_zl, ps_Nfl, 100, 200);
[ps_Nfu, b_u] = rimuovi_background(ps_zu, ps_Nfu, 100, 200);

plot(ps_zl, b_l, 'DisplayName','background - load');
plot(ps_zu, b_u, 'DisplayName','background - unload');

figure;
hold on;
grid on;
title('Substrato PS - no background');
xlabel('z [nm]');
ylabel('Nf [au]');
scatter(ps_zl, ps_Nfl, 'DisplayName','load', 'Marker','.');
scatter(ps_zu, ps_Nfu, 'DisplayName','unload', 'Marker','.');
legend show;

% Calcolo della deflessione
ps_defl = ps_Nfl / slopel;
ps_defu = ps_Nfu / slopeu;

figure;
hold on;
grid on;
title('Substrato PS - deflessione');
xlabel('z [nm]');
ylabel('def [nm]');
scatter(ps_zl, ps_defl, 'DisplayName','load', 'Marker','.');
scatter(ps_zu, ps_defu, 'DisplayName','unload', 'Marker','.');
legend show;

% [da Kontomaris 2017, pag. 10]
% La profondità di indentazione viene calcolata sottraendo alla z della
% curva del PS la z della curva dello zaffiro, a parità di deflessione
% Visto che nel caso dello zaffiro la deflessione è pari alla stessa z,
% allora il calcolo di h si riduce a:
% OCCHIO AL SEGNO DELLA z
ps_hl = (-ps_zl) - ps_defl;
ps_hu = (-ps_zu) - ps_defu;

figure;
hold on;
grid on;
title('Substrato PS - indentazione vs posizione z');
xlabel('z [nm]');
ylabel('h [nm]');
scatter(ps_zl, ps_hl, 'DisplayName','load', 'Marker','.');
scatter(ps_zu, ps_hu, 'DisplayName','unload', 'Marker','.');
legend show;

% Calcolo della forza
ps_fl = k * ps_defl;
ps_fu = k * ps_defu;

figure;
hold on;
grid on;
title('Substrato PS - forza vs indentazione');
xlabel('h [nm]');
ylabel('f [nN]');
scatter(ps_hl, ps_fl, 'DisplayName','load', 'Marker','.');
scatter(ps_hu, ps_fu, 'DisplayName','unload', 'Marker','.');
legend show;

% Calcolo della derivata locale
[dh, df] = derivata_locale(ps_hu, ps_fu, 2);

figure;
hold on;
grid on;
title('Substrato PS - derivata locale forza vs indentazione');
xlabel('h [nm]');
ylabel('df [nN/nm]');
plot(dh, df, 'DisplayName','df - unload');
plot(ps_hu, ps_fu, 'DisplayName', 'f - unload');


% Trasforma in m e N
ps_hl = ps_hl * 1e-9;
ps_hu = ps_hu * 1e-9;
ps_fl = ps_fl * 1e-9;
ps_fu = ps_fu * 1e-9;

% Linearizza
ps_fpowl = potenza(ps_fl, 2/3);
ps_fpowu = potenza(ps_fu, 2/3);

figure;
hold on;
grid on;
title('Substrato PS - forza vs indentazione - linearizzato');
xlabel('h [m]');
ylabel('f^{2/3} [N^{2/3}]');
scatter(ps_hl, ps_fpowl, 'DisplayName','load', 'Marker','.');
scatter(ps_hu, ps_fpowu, 'DisplayName','unload', 'Marker','.');
legend show;

[dh, dfpow] = derivata_locale(ps_hu, ps_fpowu, 2);

figure;
hold on;
grid on;
title('Substrato PS - derivata locale forza linearizzata vs indentazione');
plot(dh, dfpow, 'DisplayName','dfpow - unload');
plot(ps_hu, ps_fpowu * 2e9, 'DisplayName', 'fpow - unload');

% Fitta la parte lineare e recupera S
[ps_Sl, ps_ql] = fitta_retta_parziale_xy(ps_hl, ps_fpowl, 0, Inf, 0, Inf);
[ps_Su, ps_qu] = fitta_retta_parziale_xy(ps_hu, ps_fpowu, 0, Inf, 0, Inf);

fitl = ps_hl(ps_hl >= 0) * ps_Sl + ps_ql;
fitu = ps_hu(ps_hu >= 0) * ps_Su + ps_qu;

plot(ps_hl(ps_hl >= 0), fitl, 'DisplayName', 'load fit');
plot(ps_hu(ps_hu >= 0), fitu, 'DisplayName', 'unload fit');

% Calcola E ridotto per ciascuna delle due curve
Eridl = (ps_Sl ^ 1.5) * 0.75 / sqrt(R);
Eridu = (ps_Su ^ 1.5) * 0.75 / sqrt(R);

% Calcola E
El = Eridl * (1 - v^2)
Eu = Eridu * (1 - v^2)

% Calcola f
ps_fcall = 4/3 * Eridl * sqrt(R) * potenza(ps_hl, 3/2);
ps_fcalu = 4/3 * Eridu * sqrt(R) * potenza(ps_hu, 3/2);

figure;
hold on;
grid on;
title('Substrato PS - forza vs indentazione');
xlabel('h [nm]');
ylabel('f [nN]');
scatter(ps_hl, ps_fl, 'DisplayName','load', 'Marker','.');
scatter(ps_hu, ps_fu, 'DisplayName','unload', 'Marker','.');
plot(ps_hl, ps_fcall, 'DisplayName','load');
plot(ps_hu, ps_fcalu, 'DisplayName','unload');
legend show;