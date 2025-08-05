% --- Parametri ---
    red_band = [2922, 3120];
    green_band = [2830, 2920];
    
    green_shift = 2845;
    red_shift = 2930;
   
    Lx = 25;    % Dimensione in um lungo x
    Ly = 25;    % Dimensione in um lungo y
    lx = 25;    % Numero di punti lungo x
    ly = 25;    % Numero di punti lungo y
    % titolo = 'H-CO n3 map32';
% -----------------

set(0, 'DefaultAxesFontSize', 12);
set(0, 'DefaultTextFontSize', 12);

addpath app\functions\
addpath app\more-colormaps\

%% Apri il file singolo

% Apri il file contenente la mappa Raman
% if exist('raman_dir', "var") == 0
%     raman_dir = '.';
% end
% [raman_file, raman_dir] = uigetfile(sprintf('%s/*.txt', raman_dir), 'Scegli il file contenente la mappa Raman');
% filename = fullfile(raman_dir, raman_file);
% 
% % Carica anche la morfologia
% if exist('height_dir', "var") == 0
%     height_dir = '.';
% end
% [height_file, height_dir] = uigetfile(sprintf('%s/*.txt', height_dir), 'Carica il file della morfologia');
% Hmap = load_height_map(fullfile(height_dir, height_file));

%% Apri il gruppo di file

files = { {"C:\Users\savol\Documents\Università\SENSOR Lab\afm-scripts\dati\exp113\raman_maps_fede\RamanMap_ACM1st_map21_despike_bkgrmv_range.txt", "C:\Users\savol\Documents\Università\SENSOR Lab\afm-scripts\dati\exp113\acm\campione 1 - 13_03\scan20_um.txt", 'D-CO n1 map21'}, ...
          {"C:\Users\savol\Documents\Università\SENSOR Lab\afm-scripts\dati\exp113\raman_maps_fede\RamanMap_ACM2nd_map55_despike_bkgrmv_range.txt", "C:\Users\savol\Documents\Università\SENSOR Lab\afm-scripts\dati\exp113\acm\campione 2 - 14_03\scan54_um.txt", 'D-CO n2 map55'}, ...
          {"C:\Users\savol\Documents\Università\SENSOR Lab\afm-scripts\dati\exp113\raman_maps_fede\RamanMap_ACM2nd_map70_despike_bkgrmv_range.txt", "C:\Users\savol\Documents\Università\SENSOR Lab\afm-scripts\dati\exp113\acm\campione 2 - 14_03\scan68_um.txt", 'D-CO n2 map70'}, ...
          {"C:\Users\savol\Documents\Università\SENSOR Lab\afm-scripts\dati\exp113\raman_maps_fede\RamanMap_ACM3rd_map86_despike_bkgrmv_range.txt", "C:\Users\savol\Documents\Università\SENSOR Lab\afm-scripts\dati\exp113\acm\campione 3 - 17_03\scan84_um.txt", 'D-CO n3 map86'}, ...
          {"C:\Users\savol\Documents\Università\SENSOR Lab\afm-scripts\dati\exp113\raman_maps_fede\RamanMap_ACM3rd_map88_despike_bkgrmv_range.txt", "C:\Users\savol\Documents\Università\SENSOR Lab\afm-scripts\dati\exp113\acm\campione 3 - 17_03\scan87_um.txt", 'D-CO n3 map88'}, ...
          {"C:\Users\savol\Documents\Università\SENSOR Lab\afm-scripts\dati\exp113\raman_maps_fede\RamanMap_ISO1st_map15_despike_bkgrmv_range.txt", "C:\Users\savol\Documents\Università\SENSOR Lab\afm-scripts\dati\exp113\iso\campione 1 - 25_02\scan14_um.txt", 'D-CO n1 map15'}, ...
          {"C:\Users\savol\Documents\Università\SENSOR Lab\afm-scripts\dati\exp113\raman_maps_fede\RamanMap_ISO2nd_map4_despike_bkgrmv_range.txt", "C:\Users\savol\Documents\Università\SENSOR Lab\afm-scripts\dati\exp113\iso\campione 3 - 06_03\scan3_um.txt", 'H-CO n2 map4'}, ...
          {"C:\Users\savol\Documents\Università\SENSOR Lab\afm-scripts\dati\exp113\raman_maps_fede\RamanMap_ISO3rd_map14_despike_bkgrmv_range.txt", "C:\Users\savol\Documents\Università\SENSOR Lab\afm-scripts\dati\exp113\iso\campione 4 - 07_03\scan13_um.txt", 'H-CO n3 map14'}, ...
          {"C:\Users\savol\Documents\Università\SENSOR Lab\afm-scripts\dati\exp113\raman_maps_fede\RamanMap_ISO3rd_map32_despike_bkgrmv_range.txt", "C:\Users\savol\Documents\Università\SENSOR Lab\afm-scripts\dati\exp113\iso\campione 4 - 07_03\scan31_um.txt", 'H-CO n3 map32'} };

out_dir = "C:\Users\savol\Documents\Università\SENSOR Lab\afm-scripts\output\exp113\raman intensità 2845 e 2930";

for f = files
    file = f{1};
    Hmap = load_height_map(file{2});
    titolo = file{3};
    
    temp1file = 'temp1file.tsv';
    temp2file = 'temp2file.tsv';

    fid_temp1 = fopen(temp1file, 'w');
    fid_temp2 = fopen(temp2file, 'w');
    
    filename = file{1};
    fid = fopen(filename, 'r');

    if feof(fid)
        return
    end

    line = fgetl(fid);
    fprintf(fid_temp1, '%s\n', line);

    while ~feof(fid)
        line = fgetl(fid);
        if ischar(line)
            fprintf(fid_temp2, '%s\n', line);
        end
    end

    fclose(fid);
    fclose(fid_temp1);
    fclose(fid_temp2);
    clear line;

    shifts = load(temp1file);
    data = load(temp2file);

    y = data(:, 1);
    x = data(:, 2);
    raman_map = data(:, 3:end);

    % Dividi la mappa nelle due bande
    % red_band_values = raman_map(:, (shifts >= red_band(1)) & (shifts <= red_band(2)) );
    % green_band_values = raman_map(:, (shifts >= green_band(1)) & (shifts <= green_band(2)) );

    % Calcola l'area
    % red_areas = trapz(shifts((shifts >= red_band(1)) & (shifts <= red_band(2)))', red_band_values');
    % green_areas = trapz(shifts((shifts >= green_band(1)) & (shifts <= green_band(2)))', green_band_values');

    % Usa l'intensità misurata allo shift più vicino a quello scelto
    [~, red_shift_i] = min(abs(shifts - red_shift));
    [~, green_shift_i] = min(abs(shifts - green_shift));

    % Calcola l'intensità
    red_areas = raman_map(:, red_shift_i);
    green_areas = raman_map(:, green_shift_i);

    red_map = zeros(ly, lx);
    for i = 1:ly
        for j = 1:lx
            red_map(i, j) = red_areas((i-1) * lx + j);
        end
    end

    green_map = zeros(ly, lx);
    for i = 1:ly
        for j = 1:lx
            green_map(i, j) = green_areas((i-1) * lx + j);
        end
    end

    % Calcola il rapporto tra le mappe
    ratio_map = red_map ./ green_map;

    %% Plotta le due mappe una accanto all'altra
    llx = Lx / lx;
    lly = Ly / ly;
    X = linspace(llx / 2, Lx - llx / 2, lx);
    Y = linspace(lly / 2, Ly - lly / 2, ly);

    cstart = [0, 0, 0];
    cend = [1, 0, 0];
    red_cmap = [ linspace(cstart(1), cend(1), 256)', ...
        linspace(cstart(2), cend(2), 256)', ...
        linspace(cstart(3), cend(3), 256)' ];

    cstart = [0, 0, 0];
    cend = [0, 1, 0];
    green_cmap = [ linspace(cstart(1), cend(1), 256)', ...
        linspace(cstart(2), cend(2), 256)', ...
        linspace(cstart(3), cend(3), 256)' ];

    cstart = [0, 0, 0];
    cend = [0, 1, 1];
    ratio_cmap = [ linspace(cstart(1), cend(1), 256)', ...
        linspace(cstart(2), cend(2), 256)', ...
        linspace(cstart(3), cend(3), 256)' ];

    figure;
    tiledlayout(1, 4);

    sgtitle(titolo, 'FontSize', 18, 'FontWeight', 'bold');

    % Plotta la mappa morfologica
    nexttile;
    add_height_map_to_figure(Hmap, 'L', Lx, 'um', 'um', 'title', 'Height', 'cmap', slanCM('heat'));

    nexttile;
    imagesc(X, Y, green_map);
    axis image;
    set(gca, 'YDir', 'normal');
    cb = colorbar(gca);
    colormap(gca, green_cmap);
    % title(sprintf('%d - %d cm^{-1}', green_band(1), green_band(2)));
    title(sprintf('%d cm^{-1} peak', green_shift));
    xlabel(gca, 'x [{\mu}m]');
    ylabel(gca, 'y [{\mu}m]');
    ylabel(cb, 'intensity [a.u.]');
    xticks(linspace(0, Lx, 5));
    yticks(linspace(0, Ly, 5));

    nexttile;
    imagesc(X, Y, red_map);
    axis image;
    set(gca, 'YDir', 'normal');
    cb = colorbar(gca);
    colormap(gca, red_cmap);
    % title(sprintf('%d - %d cm^{-1} band', red_band(1), red_band(2)));
    title(sprintf('%d cm^{-1} peak', red_shift));
    xlabel(gca, 'x [{\mu}m]');
    ylabel(gca, 'y [{\mu}m]');
    ylabel(cb, 'intensity [a.u.]');
    xticks(linspace(0, Lx, 5));
    yticks(linspace(0, Ly, 5));

    % Plotta
    nexttile;
    imagesc(X, Y, ratio_map);
    axis image;
    set(gca, 'YDir', 'normal');
    cb = colorbar(gca);
    colormap(gca, ratio_cmap);
    title(sprintf('Ratio of %d over %d', red_shift, green_shift));
    xlabel(gca, 'x [{\mu}m]');
    ylabel(gca, 'y [{\mu}m]');
    ylabel(cb, 'ratio');
    xticks(linspace(0, Lx, 5));
    yticks(linspace(0, Ly, 5));
    % Restringi la scala ai valori compresi tra il 1% e il 99% centrali
    clim([prctile(ratio_map(:), 1), prctile(ratio_map(:), 99)]);

    %% Salva le mappe appena generate
    % if exist('out_dir', 'var') == 0
    %     out_dir = '.';
    % end
    % 
    % [out_file, out_dir] = uiputfile(sprintf('%s/red.txt', out_dir), 'Scegli dove salvare la mappa red');
    % if ~isequal(out_file, 0)
    %     writematrix(red_map, fullfile(out_dir, out_file));
    % end
    % 
    % [out_file, out_dir] = uiputfile(sprintf('%s/green.txt', out_dir), 'Scegli dove salvare la mappa green');
    % if ~isequal(out_file, 0)
    %     writematrix(green_map, fullfile(out_dir, out_file));
    % end
    % 
    % [out_file, out_dir] = uiputfile(sprintf('%s/ratio.txt', out_dir), 'Scegli dove salvare la mappa ratio');
    % if ~isequal(out_file, 0)
    %     writematrix(ratio_map, fullfile(out_dir, out_file));
    % end

    writematrix(red_map, fullfile(out_dir, sprintf('%s - red.txt', titolo)));
    writematrix(green_map, fullfile(out_dir, sprintf('%s - green.txt', titolo)));
    writematrix(ratio_map, fullfile(out_dir, sprintf('%s - ratio.txt', titolo)));
end

