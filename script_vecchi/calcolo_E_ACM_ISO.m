clear;
close all;
clc;

addpath './funzioni/';
addpath './dati/';

% Caratteristiche punta e campione
k = 9;      % N/m
R = 24e-9;  % nm
v = 0.5;

dir = '/home/cyber/Documents/Università/Tesi/Dati/AFM/';
fileISO = 'mappa_ISO_map80.txt';
fileACM = 'mappa_ACM_map93.txt';

[zaff_zl, zaff_Nfl, zaff_zu, zaff_Nfu] = load_curva_forza('curva-zaffiro-12_07_2024-s1000.txt');

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

%[zl, Nfl, zu, Nfu] = load_curva_forza('curva-ps-11_07_2024.txt');

data = load([dir fileACM]);

z = data(1, :);
zl = z(1:end/2)';
zu = z(end/2:end)';

Nf_list = data(2:end, :);
Nf = Nf_list(1, :);
Nfl = Nf(1:end/2)';
Nfu = Nf(end/2:end)';

figure;
hold on;
grid on;
title('ACM');
xlabel('z [nm]');
ylabel('Nf [au]');
scatter(zl, Nfl, 'DisplayName','load', 'Marker','.');
scatter(zu, Nfu, 'DisplayName','unload', 'Marker','.');
legend show;

% Rimozione del background
[Nfl, b_l] = rimuovi_background(zl, Nfl, 100, 200);
[Nfu, b_u] = rimuovi_background(zu, Nfu, 100, 200);

plot(zl, b_l, 'DisplayName','background - load');
plot(zu, b_u, 'DisplayName','background - unload');

figure;
hold on;
grid on;
title('ACM - no background');
xlabel('z [nm]');
ylabel('Nf [au]');
scatter(zl, Nfl, 'DisplayName','load', 'Marker','.');
scatter(zu, Nfu, 'DisplayName','unload', 'Marker','.');
legend show;

% Calcolo della deflessione
defl = Nfl / slopel;
defu = Nfu / slopeu;

figure;
hold on;
grid on;
title('ACM - deflessione');
xlabel('z [nm]');
ylabel('def [nm]');
scatter(zl, defl, 'DisplayName','load', 'Marker','.');
scatter(zu, defu, 'DisplayName','unload', 'Marker','.');
legend show;

% [da Kontomaris 2017, pag. 10]
% La profondità di indentazione viene calcolata sottraendo alla z della
% curva del PS la z della curva dello zaffiro, a parità di deflessione
% Visto che nel caso dello zaffiro la deflessione è pari alla stessa z,
% allora il calcolo di h si riduce a:
% OCCHIO AL SEGNO DELLA z
hl = (-zl) - defl;
hu = (-zu) - defu;

figure;
hold on;
grid on;
title('ACM - indentazione vs posizione z');
xlabel('z [nm]');
ylabel('h [nm]');
scatter(zl, hl, 'DisplayName','load', 'Marker','.');
scatter(zu, hu, 'DisplayName','unload', 'Marker','.');
legend show;
%axis([min(zl), -min(zl)], [max(hl), -max(hl)])

% Calcolo della forza
fl = k * defl;
fu = k * defu;

figure;
hold on;
grid on;
title('ACM - forza vs indentazione');
xlabel('h [nm]');
ylabel('f [nN]');
scatter(hl, fl, 'DisplayName','load', 'Marker','.');
scatter(hu, fu, 'DisplayName','unload', 'Marker','.');
legend show;

% Trasforma in m e N
hl = hl * 1e-9;
hu = hu * 1e-9;
fl = fl * 1e-9;
fu = fu * 1e-9;

% Linearizza
fpowl = potenza(fl, 2/3);
fpowu = potenza(fu, 2/3);

figure;
hold on;
grid on;
title('ACM - forza vs indentazione - linearizzato');
xlabel('h [m]');
ylabel('f^{2/3} [N^{2/3}]');
scatter(hl, fpowl, 'DisplayName','load', 'Marker','.');
scatter(hu, fpowu, 'DisplayName','unload', 'Marker','.');
legend show;

% Fitta la parte lineare e recupera S
[Sl, ql] = fitta_retta_parziale_xy(hl, fpowl, 0, Inf, 0, Inf);
[Su, qu] = fitta_retta_parziale_xy(hu, fpowu, 0, Inf, 0, Inf);

fitl = hl(hl >= 0) * Sl + ql;
fitu = hu(hu >= 0) * Su + qu;

plot(hl(hl >= 0), fitl, 'DisplayName', 'load fit');
plot(hu(hu >= 0), fitu, 'DisplayName', 'unload fit');

% Calcola E ridotto per ciascuna delle due curve
Eridl = (Sl ^ 1.5) * 0.75 / sqrt(R);
Eridu = (Su ^ 1.5) * 0.75 / sqrt(R);

% Calcola E
El = Eridl * (1 - v^2)
Eu = Eridu * (1 - v^2)

% Calcola f
fcall = 4/3 * Eridl * sqrt(R) * potenza(hl, 3/2);
fcalu = 4/3 * Eridu * sqrt(R) * potenza(hu, 3/2);

figure;
hold on;
grid on;
title('ACM - forza vs indentazione');
xlabel('h [nm]');
ylabel('f [nN]');
scatter(hl, fl, 'DisplayName','load', 'Marker','.');
scatter(hu, fu, 'DisplayName','unload', 'Marker','.');
plot(hl, fcall, 'DisplayName','load');
plot(hu, fcalu, 'DisplayName','unload');
legend show;