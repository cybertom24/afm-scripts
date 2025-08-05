% Carica le mappe

[files, dir] = uigetfile('*.txt', 'Scegli i file da caricare', "MultiSelect", "on");

if isequal(files, 0)
    return
end

%% 
figure;
tiledlayout('flow');

for i = 1:length(files)
    f = files{i};
    match = regexp(f, '^(.*?)\s*-\s*ratio\.txt$', 'tokens');

    % Estrai il contenuto del token (se trovato)
    if ~isempty(match)
        name = match{1}{1};
    else
        name = f;
    end

    data = load(fullfile(dir, f));
    
    nexttile;
    grid on;
    hold on;
    title(name);
    % xlabel('');
    ylabel('ratio');
    xticklabels([]);
    set(gca, 'XGrid', 'off');
    set(gca().XAxis, 'Visible', 'off');
    ylim([2, 10]);
    swarmchart(data(:)*0, data(:), 'SizeData', 50, 'Marker', '.','XJitterWidth', 0.5);
end