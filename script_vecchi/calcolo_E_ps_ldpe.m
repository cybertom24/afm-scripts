clear;
close all;
clc;

addpath './funzioni/'

% Caratteristiche punta e campione
k = 8.5;      % N/m
R = 20e-9;  % nm
v = 0.22;

[Eps, Eridps, u_Eps] = calcola_E_completo('./dati/curva-ps-11_07_2024.txt', './dati/curva-zaffiro-11_07_2024.txt', k, R, v)
[Eldpe, Eridldpe, u_Eldpe] = calcola_E_completo('./dati/curva-ldpe-11_07_2024.txt', './dati/curva-zaffiro-11_07_2024.txt', k, R, v)

Eps / Eldpe