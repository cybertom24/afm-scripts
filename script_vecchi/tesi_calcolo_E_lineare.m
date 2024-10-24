close all;
clear;
clc;

addpath ./funzioni/;

marker_size = 200;

k = 5;
R = 35e-9;
v = 0.22;

% Calibra lo strumento
[~, slope] = calibra('./dati/curva-zaffiro-11_07_2024.txt');

% Carica la curva di forza
[zl, Nfl, zu, Nfu] = load_curva_forza('./dati/curva-ps-11_07_2024.txt');

% Rimuovi il background
[Nfu_nob, b] = rimuovi_background(zu, Nfu, max(zu)/2, max(zu));

figure;
grid on;
hold on;
legend show;
scatter(zu, Nfu, 'Marker', '.', 'SizeData', marker_size, 'DisplayName','curva DZ');
scatter(zu, Nfu_nob, 'Marker', '.', 'SizeData', marker_size, 'DisplayName','curva DZ senza background');
plot(zu, b, 'DisplayName', 'background', 'LineWidth',2);
title('Curva DZ con e senza background');
xlabel('z [nm]');
ylabel('Nf [au]');
xlim([-10 100]);

% Calcola z e d
z = zu * 1e-9;
d = Nfu_nob * 1e-9 / slope;

% Sposta la curva in modo che quando d = 0 anche z = 0
% Ragiona solo dopo il minimo
% Il problema è che non so se i valori sono in crescendo o in diminuendo
[d_min, i_min] = min(d);
[z_min, i_end] = min(z);

% Le z sono in ordine decrescente
if i_min > i_end
    % Le z sono in ordine crescente
    % Scambio
    temp = i_min;
    i_min = i_end;
    i_end = temp;
end

d_temp = d(i_min:i_end);
z_temp = z(i_min:i_end);

% Trova i punti in cui y cambia segno (da positivo a negativo o viceversa)
x_zero = NaN;
for i = 1:length(d_temp) - 1
    y1 = d_temp(i);
    y2 = d_temp(i+1);
    
    if y1 * y2 < 0  % Cambia segno tra y1 e y2
        x1 = z_temp(i);
        x2 = z_temp(i+1);
        
        % Interpolazione lineare
        x_zero = x1 - y1 * (x2 - x1) / (y2 - y1);
        y_zero = 0;
    end
end

if isnan(x_zero) || (sum(d > 0) < 3)
    % Se la ricerca è fallita oppure ci sono troppo pochi elementi per
    % eseuire un fit fai lo shift scegliendo come punto quello intermedio 
    i_medio = floor((i_end + i_min) / 2);
    x_zero = z(i_medio);
    y_zero = d(i_medio);
end

figure;
grid on;
hold on;
legend show;
scatter(z, d, 'Marker', '.', 'SizeData', marker_size, 'DisplayName','curva DZ originale');
scatter(z_temp, d_temp, 'DisplayName','curva DZ per la ricerca di d = 0', 'SizeData', marker_size);
xline(x_zero, 'LineStyle','--', 'Color',[0.15 0.15 0.15],'DisplayName','d = 0');
title('Curva DZ');
xlabel('z [m]');
ylabel('d [m]');
xlim([-4e-9 6e-9]);

% Shifta ora tutto in modo che quando d = 0 anche z = 0
z = z - x_zero;
d = d - y_zero;

scatter(z, d, 'Marker', '.', 'SizeData', marker_size, 'DisplayName','curva DZ con shift');

% Calcola h
h = (-z) - d;

figure;
grid on;
hold on;
legend('show', 'location', 'northwest');
scatter(h, d, 'Marker', '.', 'SizeData', marker_size, 'DisplayName','curva DH');
title('Curva DH');
xlabel('h [m]');
ylabel('d [m]');
xlim([-6e-9 1e-9]);

% Parti a fittare dal punto in cui f = 0
% Trascina però la funzione verso l'alto in modo che il minimo corrisponda con lo zero
% Trova il minimo
%[f_min, i_min] = min(f);
%h_min = h(i_min);
% Porta le y a 0
%f = f - f_min;
% Shifta le x in modo che quando f = 0 anche h = 0
%h = h - h_min;

%figure;
%grid on;
%hold on;
%legend('show', 'location', 'northwest');
%scatter(h + h_min, f + f_min, 'Marker', '.', 'LineWidth', marker_size, 'DisplayName','curva FH originale');
%scatter(h, f, 'Marker', '.', 'LineWidth', marker_size, 'DisplayName',"curva FH senza l'offset");
%title("Rimozione dell'offset");
%xlabel('h [nm]');
%ylabel('f [nN]');    


% D'ora in poi lavora solo con h >= 0
d = d(h > 0);
h = h(h > 0);

% Fitta solo l'ultima parte
%h_media = mean(h);
%f2fit = f(h >= h_media);
%h2fit = h(h >= h_media);

% Linearizza e fitta con la retta
d = potenza(d, 2/3);

[m, q, sigma, sigma_m] = fitta_retta(h, d);
    
if m <= 0
   E = NaN;
   Erid = NaN;
   u_E = NaN;
   u_Erid = NaN;
   return;
end

figure;
grid on;
hold on;
legend('show', 'location', 'northwest');
scatter(h, d, 'DisplayName', 'curva DH linearizzata', 'Marker', '.', 'SizeData', marker_size);
% scatter(h2fit, f2fit, 'DisplayName','curva FH linearizzata da fittare');
plot(h, h*m + q, 'DisplayName','fit');
title('Porzione di curva DH linearizzata');
xlabel('h [m]');
ylabel('d^{2/3} [m^{2/3}]');    

% Calcola E
Erid = (m ^ 1.5) * 0.75 * k / sqrt(R);
E = Erid * (1 - v^2);
u_Erid = 9/8 * sqrt(m/R) * sigma_m;
u_E = u_Erid * (1 - v^2);
