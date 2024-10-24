clc;
clear;
close all;

heigth_data = load("scan72-heigth.txt");
heigth_data_x = heigth_data(:, 1);
heigth_data_y = heigth_data(:, 2);
heigth_data_z = heigth_data(:, 3);

l = round( sqrt(length(heigth_data_z)) );
heigth_map = zeros([l l]);

for i = 1:1:length(heigth_data_x)
    x = heigth_data_x(i) + 1;
    y = heigth_data_y(i) + 1;
    z = heigth_data_z(i);
    heigth_map(x, y) = z; 
end

phase_data = load("scan72-phase.txt");
phase_data_x = phase_data(:, 1);
phase_data_y = phase_data(:, 2);
phase_data_z = phase_data(:, 3);

l = round( sqrt(length(phase_data_z)) );
phase_map = zeros([l l]);

for i = 1:1:length(phase_data_x)
    x = phase_data_x(i) + 1;
    y = phase_data_y(i) + 1;
    z = phase_data_z(i);
    phase_map(x, y) = z; 
end

figure;
% Plotta la superficie 3D disattivando i bordi ed utilizzando la phase_map
% per colorare la superficie
surf(heigth_map, phase_map, 'EdgeColor', 'none'); 
