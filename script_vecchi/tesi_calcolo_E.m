close all;
clear;
clc;

addpath ./funzioni/;

k = 8.5;
R = 30e-9;
v = 0.22;

% Calibra lo strumento
[~, slope] = calibra('./dati/curva-zaffiro-11_07_2024.txt');

% Carica la curva di forza
[zl, Nfl, zu, Nfu] = load_curva_forza('./dati/curva-ldpe-11_07_2024.txt');

% Rimuovi il background
[Nfu_nob b] = rimuovi_background(zu, Nfu, max(zu)/2, max(zu));

figure;
grid on;
hold on;
legend show;
scatter(zu, Nfu, 'Marker', '.', 'DisplayName','curva DZ');
scatter(zu, Nfu_nob, 'Marker', '.', 'DisplayName','curva DZ senza background');
plot(zu, b, 'DisplayName', 'background', 'LineWidth',2);
title('Curva DZ con e senza background');
xlabel('z [nm]');
ylabel('Nf [au]');

% Calcola z e d
z = zu * 1e-9;
d = Nfu_nob * 1e-9 / slope;

% Calcola h
h = (-z) - d;

figure;
grid on;
hold on;
legend show;
scatter(h, d, 'Marker', '.', 'DisplayName','curva DH');
title('Curva DH');
xlabel('h [m]');
ylabel('d [m]');

% Calcola la forza (f) [nN]
f = k * d;

% Fitta con una funzione a * x ^ b
% Parti a fittare dal minimo
% Trascina però la funzione verso l'alto in modo che il minimo corrisponda con lo zero
% Trova il minimo
[f_min, i_min] = min(f);
h_min = h(i_min);
% Porta le y a 0
f = f - f_min;
% Shifta le x in modo che quando f = 0 anche h = 0
h = h - h_min;

figure;
grid on;
hold on;
legend('show', 'location', 'northwest');
scatter(h + h_min, f + f_min, 'Marker', '.', 'DisplayName','curva FH originale');
scatter(h, f, 'Marker', '.', 'DisplayName',"curva FH senza l'offset");
title("Rimozione dell'offset");
xlabel('h [nm]');
ylabel('f [nN]');    


% D'ora in poi lavora solo con h >= 0
f = f(h > 0);
h = h(h > 0);

% Fitta con il modello di potenza
% Esecuzione del fitting con vincoli: b >= 1
[fitted_curve, gof, out] = fit(h, f, 'power1', 'Lower', [-Inf 1], 'StartPoint', [0 0]);

% Recupera i risultati del fit
a = fitted_curve.a;
b = fitted_curve.b;
sigma = gof.rmse;

figure;
grid on;
hold on;
legend('show', 'location', 'northwest');
scatter(h, f, 'Marker', '.', 'DisplayName','curva FH');
plot(h, a * potenza(h, b), 'DisplayName','fit');
title('Porzione di curva FH sottoposta al fitting');
xlabel('h [nm]');
ylabel('f [nN]');    

% Se b risulta diversa da 1.5 vuol dire che il modello non è giusto
% Ritorna quindi NaN
max_error = 0.1;
if 0 == 1%abs(b - 1.5) > max_error
  E = NaN;
  Erid = NaN;
  u_E = NaN;
  u_Erid = NaN;
  return;
end

%plot(h, (a * (h.^b)), 'DisplayName',['a: ' num2str(a) ' - b: ' num2str(b)]);

% Equazione 29 Kontomaris 2022
c1 =  1.01400;
c2 = -0.09059;
c3 = -0.09431;
rc = (R * ( c1 * sqrt(h/R) + c2 * (h/R) + c3 * ((h/R) .^ 2) ));

% Avendo calcolato rc, posso unire le eq. 25, 26 e 29 per ottenere E
%E = (1 - v^2) * (a * b / 2) * ( (h .^ (b - 1)) ./ rc );
  
f_fit = a * (h.^b);

% Consigliato da Kontomaris 2017
Erid_fit = (f_fit ./ (rc .* h)) * b / 2;
Erid_mis = (f ./ (rc .* h)) * b / 2;
    
figure;
hold on;
grid on;
legend('show', 'location', 'southeast');
plot(h, Erid_mis, 'DisplayName','con misura di F');
plot(h, Erid_fit, 'DisplayName','con fit di F');
xlabel('h [m]');
ylabel('E^* [Pa]');
title('E^* in funzione di h');

Erid = Erid_fit;

% Mia versione di Kontomaris 2017
% Erid_k2017_mio = (a * b / 2) * max(h) ^ (b - 1) / max(rc)
% Dal modello Hertziano, mia versione
%Erid = 3/4 * a / sqrt(R);
%E = (1 - v^2) * Erid;
%u_E = 0;
%u_Erid = 0;
%return;
    
% Calcola l'incertezza sul valore di Erid
% (vedi propagazione dell'incertezza sul fit)
u_Erid = ((b / 2) * sigma) ./ (rc .* h);
    
% Rimuovi quando h = 0 ed rc = 0
% u_Erid = u_Erid((h > 0) & (rc > 0));
   
figure;
grid on;
hold on;
scatter(Erid, u_Erid);
%scatter(max(Erid), min(u_Erid));
title('u_{E^*} in funzione di E^*');
xlabel('E^* [Pa]');
ylabel('u_{E^*} [Pa]');

% Calcola Erid solo quando u_Erid è minore
[u_Erid_min, i_min] = min(u_Erid);
  
Erid = Erid(i_min);
u_Erid = u_Erid_min;
    
E = Erid * (1 - v^2);

% Dato che si assume u(v) = 0, per trovare u(E) basta moltiplicare per
% (1 - v^2)
u_E = (1 - v^2) * u_Erid;

