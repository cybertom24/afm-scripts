close all;
clear;
clc;

addpath './funzioni/'

% Queste curve sono state simulate e sono state proposte da Kontomaris 2022
% Caratteristiche punta:
k = 0.1;    % N/m
R = 1e-6;   % m
v = 0.5;
%slope = 1;  % a.u./nm
% E dovrebbe essere 20kPa (fisso)

data = readmatrix('./dati/100nm_no_1_Hertz_R1um.csv');
z = data(:,1) * 1e-6;   % m
def = data(:,2) * 1e-6; % m

figure;
hold on;
grid on;
legend show;
title('Curva (misurata) deflessione cantilever (def) vs sensore piezo (z)');
xlabel('z [m]');
ylabel('def [m]');
scatter(z, def, 'Marker', '.', 'DisplayName', 'curva def vs z');

%def = Nf / slope;

% Calcolo dell'identazione del campione (h)
% Differenza tra la deflesssione del cantilever (def) e la posizione del 
% piezo tubo (z)
h = (-z) - def;

% Calcolo della forza (in N)
f = k * def;

figure;
hold on;
grid on;
legend show;
title('Curva forza vs identazione');
xlabel('h [m]');
ylabel('f [N]');
scatter(h, f, 'DisplayName', 'f vs h', 'Marker','.');

% Applica il modello di Hertz senza la linearizzazione

% Fitta la curva f(h) con il modello f(h) = a * (h ^ b)
% con b = 1.5 (3/2)

% Esecuzione del fitting con vincoli: h > 0, b = 1.5
[fitted_curve, gof, out] = fit(h, f, 'power1', 'Exclude', h < 0, 'Lower', [-Inf 1.5], 'Upper', [Inf 1.5], 'StartPoint', [0 1.5]);

% Recupera i risultati del fit
a = fitted_curve.a;
b = fitted_curve.b;

plot(h, (a * (h.^b)), 'DisplayName','power fit');

E = 0.75 * (1 - v^2) * a / sqrt(R)

figure;
    hold on;
    grid on;
    legend show;
    scatter(h, f);
    title('forza vs indentazione prima del clip');

f = f(h > 0);
h = h(h > 0);


    figure;
    hold on;
    grid on;
    legend show;
    scatter(h, f);
    title('forza vs indentazione pt 2');
    
    % Fitta con il modello di potenza
    % Esecuzione del fitting con vincoli: b >= 1
    [fitted_curve, gof, out] = fit(h, f, 'power1', 'Lower', [-Inf 1], 'StartPoint', [0 0]);

    % Recupera i risultati del fit
    a = fitted_curve.a;
    b = fitted_curve.b;
    sigma = gof.rmse;

    %plot(h, (a * (h.^b)), 'DisplayName',['a: ' num2str(a) ' - b: ' num2str(b)]);

    % Equazione 29 Kontomaris 2022
    c1 =  1.01400;
    c2 = -0.09059;
    c3 = -0.09431;
    rc = (R * ( c1 * sqrt(h/R) + c2 * (h/R) + c3 * ((h/R) .^ 2) ));

    % Avendo calcolato rc, posso unire le eq. 25, 26 e 29 per ottenere E
    %E = (1 - v^2) * (a * b / 2) * ( (h .^ (b - 1)) ./ rc );
    
    f_fit = a * (h.^b);
    plot(h, f_fit);

    % Consigliato da Kontomaris 2017
    Erid = (f_fit ./ (rc .* h)) * b / 2;
    
    figure;
    hold on;
    grid on;
    legend show;
    plot(h, Erid, 'DisplayName','con fit');
    plot(h, (f ./ (rc .* h)) * b / 2, 'DisplayName','senza fit');
    xlabel('h [m]');
    ylabel('Erid [Pa]');

    % Mia versione di Kontomaris 2017
    % Erid_k2017_mio = (a * b / 2) * max(h) ^ (b - 1) / max(rc)
    % Dal modello Hertziano, mia versione
    Erid = 3/4 * a / sqrt(R);
    E = (1 - v^2) * Erid;
    u_E = 0;
    u_Erid = 0;
    return;

    Erid_sigma = ((b / 2) * sigma) ./ (rc .* h);
    
    % Rimuovi quando h = 0 ed rc = 0
    Erid_sigma = Erid_sigma((h > 0) & (rc > 0));
   
    figure;
    grid on;
    hold on;
    plot(h((h > 0) & (rc > 0)), Erid_sigma);
    title('Erid_sigma in funzione di h');
    
    % Calcola Erid solo quando Erid_sigma è minore
    [Erid_sigma_min, i_min] = min(Erid_sigma);
    
    Erid = Erid(i_min);
    Erid_sigma = Erid_sigma_min;
    
    E = Erid * (1 - v^2)

    U_Erid = 2 * Erid_sigma;
    U_E = U_Erid * (1 - v^2)