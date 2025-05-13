% --- Parametri ---
    red_band = [2922, 3120];
    green_band = [2830, 2920];
    Lx = 25;    % Dimensione in um lungo x
    Ly = 25;    % Dimensione in um lungo y
    lx = 25;    % Numero di punti lungo x
    ly = 25;    % Numero di punti lungo y
    titolo = 'H-CO n2 map4';
% -----------------

set(0, 'DefaultAxesFontSize', 14);
set(0, 'DefaultTextFontSize', 14);

addpath app\functions\
addpath app\more-colormaps\

% Apri il file contenente la mappa Raman
if exist('raman_dir', "var") == 0
    raman_dir = '.';
end
[raman_file, raman_dir] = uigetfile(sprintf('%s/*.txt', raman_dir), 'Scegli il file contenente la mappa Raman');
filename = fullfile(raman_dir, raman_file);

% Carica anche la morfologia
if exist('height_dir', "var") == 0
    height_dir = '.';
end
[height_file, height_dir] = uigetfile(sprintf('%s/*.txt', height_dir), 'Carica il file della morfologia');
Hmap = load_height_map(fullfile(height_dir, height_file));

temp1file = 'temp1file.tsv';
temp2file = 'temp2file.tsv';

fid_temp1 = fopen(temp1file, 'w');
fid_temp2 = fopen(temp2file, 'w');

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
red_band_values = raman_map(:, (shifts >= red_band(1)) & (shifts <= red_band(2)) );
green_band_values = raman_map(:, (shifts >= green_band(1)) & (shifts <= green_band(2)) );

% Calcola l'area
red_areas = trapz(shifts((shifts >= red_band(1)) & (shifts <= red_band(2)))', red_band_values');
green_areas = trapz(shifts((shifts >= green_band(1)) & (shifts <= green_band(2)))', green_band_values');

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

figure;
tiledlayout(1, 3);

sgtitle(titolo, 'FontSize', 20, 'FontWeight', 'bold');

nexttile;
imagesc(X, Y, red_map);
axis image;
set(gca, 'YDir', 'normal');
cb = colorbar(gca);
colormap(gca, red_cmap);
title(sprintf('%d - %d cm^{-1} band', red_band(1), red_band(2)));
xlabel(gca, 'x [{\mu}m]');
ylabel(gca, 'y [{\mu}m]');
ylabel(cb, 'area [a.u.]');
xticks(linspace(0, Lx, 5));
yticks(linspace(0, Ly, 5));

nexttile;
imagesc(X, Y, green_map);
axis image;
set(gca, 'YDir', 'normal');
cb = colorbar(gca);
colormap(gca, green_cmap);
title(sprintf('%d - %d cm^{-1}', green_band(1), green_band(2)));
xlabel(gca, 'x [{\mu}m]');
ylabel(gca, 'y [{\mu}m]');
ylabel(cb, 'area [a.u.]');
xticks(linspace(0, Lx, 5));
yticks(linspace(0, Ly, 5));

% Plotta anche la mappa morfologica
nexttile;
add_height_map_to_figure(Hmap, 'L', Lx, 'um', 'um', 'title', 'Height', 'cmap', slanCM('heat'));

%% Salva le mappe appena generate
if exist('out_dir', 'var') == 0
    out_dir = '.';
end
[out_file, out_dir] = uiputfile(sprintf('%s/red.txt', out_dir), 'Scegli dove salvare la mappa red');
writematrix(red_map, fullfile(out_dir, out_file));
[out_file, out_dir] = uiputfile(sprintf('%s/green.txt', out_dir), 'Scegli dove salvare la mappa green');
writematrix(green_map, fullfile(out_dir, out_file));

%% Calcola il rapporto tra le mappe
ratio_map = red_map ./ green_map;

cstart = [0, 0, 0];
cend = [0, 1, 1];
ratio_cmap = [ linspace(cstart(1), cend(1), 256)', ...
               linspace(cstart(2), cend(2), 256)', ...
               linspace(cstart(3), cend(3), 256)' ];

figure;
imagesc(X, Y, ratio_map);
axis image;
set(gca, 'YDir', 'normal');
cb = colorbar(gca);
colormap(gca, ratio_cmap);
title(sprintf('Ratio of %d - %d over %d - %d', red_band(1), red_band(2), green_band(1), green_band(2)));
xlabel(gca, 'x [{\mu}m]');
ylabel(gca, 'y [{\mu}m]');
ylabel(cb, 'area [a.u.]');
xticks(linspace(0, Lx, 5));
yticks(linspace(0, Ly, 5));