close all;
clear;
clc;

dir = 'C:\Users\savol\Documents\Università\Tesi\Dati\AFM\';
fileISO = 'mappa_ISO_map80.txt';
fileACM = 'mappa_ACM_map93.txt';

data = load([dir fileISO]);

z = data(1, :);
zl = z(1:end/2)';
zu = z(end/2:end)';

Nf_list = data(2:end, :);
Nf = Nf_list(1, :);
Nfl = Nf(1:end/2)';
Nfu = Nf(end/2:end)';

mat = [z' Nf'];