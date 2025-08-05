%% Preliminari
addpath ./app/more-colormaps/
set(0, 'DefaultAxesFontSize', 11);
set(0, 'DefaultTextFontSize', 11);

%% Carica la mappa raman
[file_name, dir_name] = uigetfile('*.txt', 'Scegli il file contenente la mappa Raman');

fprintf('\t%s\n', file_name);

% Apri la mappa
fullfname = fullfile(dir_name, file_name);

temp1file = 'temp1file.tsv';
temp2file = 'temp2file.tsv';

fid_temp1 = fopen(temp1file, 'w');
fid_temp2 = fopen(temp2file, 'w');

fid = fopen(fullfname, 'r');

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

%% Calcola l'area sotto alla banda

% band = [2781, 3075];
band = [1403, 1518];
shift = shifts(shifts >= band(1) & shifts <= band(2));
areas = 0 * data(:, 1);

for i = 1:length(areas)
    intensities = data(i, shifts >= band(1) & shifts <= band(2));
    areas(i) = trapz(shift', intensities')';
end

% Converti in matrice quadrata

% Scopri le dimensioni in x e in y
% I pixel lungo le y sono pari al numero di volte in cui la x si ripete
% uguale
ly = sum(x == x(1));
% Stessa cosa per le x
lx = sum(y == y(1));

map = zeros(ly, lx);
for i = 1:ly
    for j = 1:lx
        map(i, j) = areas((i-1) * lx + j);
    end
end

%% Plotta

% Dimensioni in um della mappa (da personalizzare)
Lx = lx;
Ly = ly;

n_pixel = lx;
l_pixel = Lx / n_pixel;
X = linspace(l_pixel / 2, Lx - l_pixel / 2, n_pixel);
Y = linspace(l_pixel / 2, Ly - l_pixel / 2, n_pixel);


figure;
img = imagesc(X, Y, map); % Indica gli assi prima della matrice
axis('image'); % imposta l'aspect ratio giusto
set(gca, 'YDir', 'normal');
colormap(flipud(slanCM('Blues')));
cb = colorbar;
xlabel('x [{\mu}m]');
ylabel('y [{\mu}m]');
ylabel(cb, 'peak area [a.u.]');
title('Peak @ 1450cm^{-1} - H-CO');
xticks(linspace(0, Lx, 5));
yticks(linspace(0, Ly, 5));