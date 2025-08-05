% Salva tutte le figure aperte sia come .fig che come .png in una cartella
% unica. Il nome del file viene recuperato dall'sgtitle o in assenza viene
% usato il numero della figura

% Trova tutti gli handle delle figure aperte
figHandles = findall(0, 'Type', 'figure');

% Crea una cartella per salvare (opzionale)
outputFolder = uigetdir('.', 'Scegli la cartella dove salvare tutte le figure');
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

% Scorri tutte le figure e salva
for i = 1:length(figHandles)
    fig = figHandles(i);
    % Porta in primo piano (necessario per saveas)
    figure(fig);
    % Porta a schermo intero
    fig.WindowState = 'maximized';

    try
        name = fig.Children.Title.String;
    catch
        name = sprintf('Figure_%d', fig.Number);
    end
    filename = fullfile(outputFolder, name);

    % Salva in formato .fig
    savefig(fig, [filename, '.fig']);

    % Salva in formato .png
    saveas(fig, [filename, '.png']);
end

disp('Tutte le figure sono state salvate.');
