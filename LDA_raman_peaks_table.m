%% --- Carica la peaks table ---

[file, dir] = uigetfile('*.txt', 'Scegli il file contenente la peaks table');
filename = fullfile(dir, file);

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

peaks = load(temp1file);
data = load(temp2file);

y = data(:, 1);
x = data(:, 2);
peaks_table = data(:, 3:end);

% La PCA viene eseguita sulla matrice data_matrix
data_matrix = peaks_table;
% I picchi invece vanno messi in data_vector
data_vector = peaks;

%% --- Mostra i primi 3 spettri ---

figure;
grid on;
hold on;
stem(peaks, peaks_table(1, :), 'filled', 'DisplayName', 'Spettro 1', 'LineWidth', 2);
stem(peaks, peaks_table(2, :), 'filled', 'DisplayName', 'Spettro 2', 'LineWidth', 2);
stem(peaks, peaks_table(3, :), 'filled', 'DisplayName', 'Spettro 3', 'LineWidth', 2);
legend('show', 'Location', 'best');
title('I primi 3 spettri della mappa');
xlabel('shift Raman [cm^{-1}]');
ylabel('intensità [au]');

%% --- Carica la maschera ---

[file, dir] = uigetfile('*.txt', 'Scegli il file contenente la maschera');
filename = fullfile(dir, file);

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

x = load(temp1file);
data = load(temp2file);
y = data(:, 1);
mask_data = data(:, 2:end);

%% --- Mostra la maschera ---

% Prendi solo i valori superiori ad un certo numero
mask = mask_data > 0.75e4;

% X = linspace(0, size(mask_data, 2), size(mask_data, 2));
% Y = linspace(0, size(mask_data, 1), size(mask_data, 1));

figure;
imagesc(x, y, mask);
axis image;
% set(gca, 'YDir', 'normal');
cb = colorbar;
colormap('gray');
title('maschera');

%% --- Mostra i dati in un grafico 2D ---

ly = length(y);
lx = length(x);

% Rendi la maschera un vettore
mask_v = zeros(length(peaks_table), 1);
for i = 1:ly
    for j = 1:lx
        mask_v((i-1) * lx + j) = mask(i, j);
    end
end

% Separa i punti
peaks_table_out = peaks_table(mask_v == 0, :);
peaks_table_in = peaks_table(mask_v == 1, :);

px = 6;
py = 4;

figure;
hold on;
grid on;
title('Punti rappresentanti gli spettri nella mappa');
xlabel(['Intensità picco ' num2str(peaks(px)) ' cm^{-1}']);
ylabel(['Intensità picco ' num2str(peaks(py)) ' cm^{-1}']);
scatter(peaks_table_out(:, px), peaks_table_out(:, py), 'Marker', 'o');
scatter(peaks_table_in(:, px), peaks_table_in(:, py), 'Marker', 'x');