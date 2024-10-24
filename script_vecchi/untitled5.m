close all;
clear;
clc;

k = 0.1;

data = readmatrix('100nm_no_1_Hertz_R1um.csv');
z = data(:,1) * 1000;   % m
def = data(:,2) * 1000; % m

h = (def - z);

% Limita h ai soli valori positivi
h = h(h > 0);
% Riduci def alla stessa dimensione
def = def((length(def) - length(h) + 1):length(def));

% Calcolo della forza (in N)
f = k * def;