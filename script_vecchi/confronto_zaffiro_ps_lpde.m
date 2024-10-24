clc;
close all;
clear;

zaffiro = load('curva-zaffiro-11_07_2024.txt');
ps = load('curva-ps-11_07_2024.txt');
ldpe = load('curva-ldpe-11_07_2024.txt');

figure;
hold on;
grid on;
mostra_curva(zaffiro);
mostra_curva(ps);
mostra_curva(ldpe);