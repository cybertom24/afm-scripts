close all;
clear;
clc;

dir = '/home/cyber/Documents/Università/Tesi/Dati/AFM/';
fileACM = 'mappa_ACM_map93.txt';

data = load([dir fileACM]);
z = data(1,:);

Nf_list = data((2:end),:);

z = z(end/2 : end);
Nf = Nf_list(1, end/2 : end);

plot(z, Nf);

[x, slope] = calibra('curva-zaffiro-12_07_2024-s1000.txt');

E = calcola_E_da_curva_z_Nf(z, Nf, slope, 5, 35e-9, 0.5) * 1e-6

