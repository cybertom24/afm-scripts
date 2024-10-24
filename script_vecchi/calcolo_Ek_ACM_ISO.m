clear;
close all;
clc;

addpath './funzioni/';

% Caratteristiche punta e campione
k = 9;      % N/m
R = 25e-9;  % nm
v = 0.5;

[Eiso, Eridiso, u_Eiso] = calcola_E_completo('./dati/curva-ISO-11_07_2024.txt', './dati/curva-zaffiro-11_07_2024.txt', k, R, v)
[Eacm, Eridacm, u_Eacm] = calcola_E_completo('./dati/curva-ACM-12_07_2024.txt', './dati/curva-zaffiro-12_07_2024-s1000.txt', k, R, v)