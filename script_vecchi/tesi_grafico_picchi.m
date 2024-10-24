clear;
close all;
clc;

addpath ./funzioni/

picchi_iso = [484, 778, 924, 1725];
picchi_acm = [25, 452, 1008, 2254];
larg_picchi_iso = 2*[136, 40, 185, 74];
larg_picchi_acm = 2*[38, 166, 382, 101];

altezza = 0.1; % Altezza dei rettangoli

pos_y_iso = 0.3; % Posizione y della prima riga
pos_y_acm = 0; % Posizione y della seconda riga

% Creazione del grafico
figure;
hold on;

% Plot rettangoli sulla prima riga (top)
for i = 1:length(picchi_iso)
    % Rettangolo centrato nella posizione x con la larghezza specifica
    rectangle('Position', [picchi_iso(i)-larg_picchi_iso(i)/2, pos_y_iso, larg_picchi_iso(i), altezza], 'FaceColor', [0 0.45 0.74], 'EdgeColor', 'k', 'FaceAlpha', 0.6);
    line([picchi_iso(i), picchi_iso(i)], [-10, pos_y_iso + 1.3 * altezza], 'Color', 'k', 'LineWidth', 1.5, 'LineStyle', '--');
end

% Plot rettangoli sulla prima riga (top)
for i = 1:length(picchi_iso)
    % Rettangolo centrato nella posizione x con la larghezza specifica
    rectangle('Position', [picchi_acm(i)-larg_picchi_acm(i)/2, pos_y_acm, larg_picchi_acm(i), altezza], 'FaceColor', [0.85 0.33 0.10], 'EdgeColor', 'k', 'FaceAlpha', 0.6);
    line([picchi_acm(i), picchi_acm(i)], [-10, pos_y_acm + 1.3 * altezza], 'Color', 'k', 'LineWidth', 1.5, 'LineStyle', '--');
end

% Impostazioni del grafico
xlim([0, 2500]);
ylim([-0.2, 0.6]);
% axis padded;
xlabel('E [MPa]');
ylabel('');
set(gca, 'YColor', 'none');

title('Picchi rilevati nelle distribuzioni dei due campioni');

