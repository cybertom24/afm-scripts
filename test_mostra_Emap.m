clc;
close all;
clear;

set(0, 'DefaultAxesFontSize', 14);
set(0, 'DefaultTextFontSize', 14);

addpath ./funzioni
addpath ./app/functions/
addpath ./more-colormaps/

load ./output/prova.mat

cmap = [[1, 0, 0]; [0, 1, 0]];% [0, 0, 1]; [1, 0, 1]];
scale = 'log';
color_lim = [0 0];

figure;
add_E_map_to_figure(Emap, 'L', L, 'um', 'MPa', 'title', '(b) Elastic modulus map', 'scale', scale, 'image_cmap', cmap, 'clim', color_lim);

figure;
imagesc(Emap);
colormap(cmap);
axis image;
set(gca, 'YDir', 'normal')
set(gca, 'ColorScale', scale)
colorbar
clim(color_lim);

return;

fig = figure;
fig.Position(3) = fig.Position(3) * 2; 
drawnow;
tiledlayout(1, 2);
nexttile;
add_height_map_to_figure(Hmap, L, 'nm', '(a) Height map', slanCM('heat'));
nexttile;
add_E_map_to_figure(Emap, 'L', L, 'um', 'MPa', 'title', '(b) Elastic modulus map');