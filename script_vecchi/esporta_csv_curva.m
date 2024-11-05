clear;
close all;
clc;

% Carica il file AIST
mat = load('./dati/curva-ldpe-30nm-2.txt');

% Imposta la slope
slope = 347.54;

% Converti in um
mat = [ (mat(:,1)/1000) (mat(:,2:end)/(slope*1000)) ];

% Aggiungi l'intestazione
intest = ["Z (um)" "Deflection (um)"];

mat = [intest; mat];

writematrix(mat, 'curva-ldpe-30nm-2.csv');