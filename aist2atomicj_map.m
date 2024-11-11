clear;
close all;
clc;

% Carica il file AIST
mat = load('./dati/map29.txt');
%mat = mat';

% Imposta la slope
slope = 347.54;

% Converti in um
mat = [ (mat(1,:)/1000); (mat(2:end,:)/(slope*1000)) ];

%curves = min(size(mat)) - 1;

% Aggiungi l'intestazione
%intest(1) = "Z (um)";

%for i = 1:1:curves
%    intest(i+1) = "Deflection (um)";
%end

%mat = [intest; mat];

writematrix(mat, 'map29.csv');