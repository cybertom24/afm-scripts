clear;
close all;
clc;

% Carica il file AIST
mat = load('curva-ps-11_07_2024.txt');
% Imposta la slope
slope = 300;
% Converti in um e prendi solo la curva di loading
mat = [ (mat((1:end/2),1)/1000) (mat((1:end/2),2)/(slope*1000)) ];
% Salva il file
writematrix(mat, 'curva-ldpe-11_07_2024.csv');