%% --- Seleziona tutti i file ISO ---
[files_iso, dir_iso] = uigetfile('*.txt', 'Scegli il/i file contenente la mappa Raman ISO', 'MultiSelect', 'on');

%% --- Seleziona tutti i file ACM ---
[files_acm, dir_acm] = uigetfile('*.txt', 'Scegli il/i file contenente la mappa Raman ACM', 'MultiSelect', 'on');

%% --- Carica le mappe ---
maps_iso = cell(length(files_iso), 1);
fprintf('Mappe ISO:\n');
for i = 1:length(files_iso)
    fname = files_iso{i};
    fprintf('\t%s\n', fname);

    % Apri la mappa
    fullfname = fullfile(dir_iso, fname);

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

    maps_iso{i} = raman_map;
end
fprintf('Fine mappe ISO\n');

% Stessa cosa con le ACM
maps_acm = cell(length(files_acm), 1);
fprintf('Mappe ACM:\n');
for i = 1:length(files_acm)
    fname = files_acm{i};
    fprintf('\t%s\n', fname);

    % Apri la mappa
    fullfname = fullfile(dir_acm, fname);

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

    maps_acm{i} = raman_map;
end
fprintf('Fine mappe ACM\n');

%% --- Accorpa le mappe ed esegui la PCA ---

points_per_map = size(maps_acm{1}, 1);

mega_map = zeros(points_per_map * (length(maps_acm) + length(maps_iso)), length(shifts));

% Prima le mappe ISO
for i = 1:length(maps_iso)
    mega_map( (points_per_map*(i-1) + 1):(points_per_map*i) , 1:end) = maps_iso{i};
end

% Poi quelle ACM
for i = 1:length(maps_acm)
    mega_map( (points_per_map*(i-1+length(maps_iso)) + 1):(points_per_map*(i+length(maps_iso))) , 1:end) = maps_acm{i};
end

fprintf('Mega map pronta\n');

[coeff, score, latent, ~, explained] = pca(mega_map);

fprintf('PCA completata\n');

%% --- Mostra i risultati ---

% Scopri le dimensioni in x e in y
% I pixel lungo le y sono pari al numero di volte in cui la x si ripete
% uguale
ly = sum(x == x(1));
% Stessa cosa per le x
lx = sum(y == y(1));

% Dimensioni in um della mappa (da personalizzare)
Lx = lx;
Ly = ly;

X = linspace(0, Lx, lx);
Y = linspace(0, Ly, ly);

% Crea la cmap
cstart = [0, 1, 0];
cend = [1, 0, 0];
cmap = [ linspace(cstart(1), cend(1), 256)', ...
         linspace(cstart(2), cend(2), 256)', ...
         linspace(cstart(3), cend(3), 256)' ];

% Per ciascuna mappa mostra la PC selezionata
pc = 3;
% Mostra i loadings (coefficients) per questa PC
figure;
grid on;
hold on;
% Recupera i coefficienti
coeff_PC = coeff(:, pc);
if length(shifts) > 100
    plot(shifts', coeff_PC, 'LineWidth', 2);
else
    stem(shifts', coeff_PC, 'filled', 'LineWidth', 2);
end
title(sprintf('Loadings of PC%d', pc));
xlabel('Raman shift [cm^{-1}]');
ylabel('loading');

figure;
tiledlayout('flow');
for m = 1:(length(maps_iso) + length(maps_acm))
    % Mostra per ciascun punto misurato il proprio score lungo la PC
    i_start = points_per_map * (m - 1) + 1;
    i_end = i_start + points_per_map - 1;
    score_PC = score(i_start:i_end, pc);
    % Rendila una matrice (anche non quadrata)
    map_PC = zeros(ly, lx);
    for i = 1:ly
        for j = 1:lx
            map_PC(i, j) = score_PC((i-1) * lx + j);
        end
    end

    nexttile;
    imagesc(X, Y, map_PC);
    axis image;
    set(gca, 'YDir', 'normal');
    cb = colorbar;
    colormap(cmap);
    clim([-1500, 1500]);
    
    if m <= length(maps_iso)
        title(sprintf('map ISO%d PC%d', m, pc));
    else
        title(sprintf('map ACM%d PC%d', m - length(maps_iso), pc));
    end
end

%% --- Mostra nello spazio 3D delle prime 3 PC ---

figure;
tiledlayout(1, 2);

nexttile;
grid on;
hold on;
legend('show', 'Location', 'best');
for i = 1:3
    coeff_PC = coeff(:, i);
    if length(shifts) > 100
        plot(shifts', coeff_PC, 'LineWidth', 2, 'DisplayName', sprintf('PC%d', i));
    else
        stem(shifts', coeff_PC, 'filled', 'LineWidth', 2, 'DisplayName', sprintf('PC%d', i));
    end
end
title('Loadings');
xlabel('Raman shift [cm^{-1}]');
ylabel('loading');

nexttile;
grid on;
hold on;
for m = 1:(length(maps_iso) + length(maps_acm))
    % Mostra per ciascun punto misurato il proprio score lungo la PC
    i_start = points_per_map * (m - 1) + 1;
    i_end = i_start + points_per_map - 1;
    score_PC1 = score(i_start:i_end, 1);
    score_PC2 = score(i_start:i_end, 2);
    score_PC3 = score(i_start:i_end, 3);
    

    if m <= length(maps_iso)
        scatter3(score_PC1, score_PC2, score_PC3, 'blue', 'Marker', '.', 'DisplayName', sprintf('ISO%d', m), 'SizeData', 30);
    else
        scatter3(score_PC1, score_PC2, score_PC3, 'red', 'Marker', '.', 'DisplayName', sprintf('ACM%d', m - length(maps_iso)), 'SizeData', 30);
    end

    title('Points in 3D space');
    xlabel('PC1');
    ylabel('PC2');
    zlabel('PC3');
    subtitle('blue: ISO | red: ACM');

    % legend('show', 'Location', 'best');
end

%% --- Mostra le 3 viste ---

figure;
tiledlayout(1, 3);

nexttile;
grid on;
hold on;
for m = 1:(length(maps_iso) + length(maps_acm))
    % Mostra per ciascun punto misurato il proprio score lungo la PC
    i_start = points_per_map * (m - 1) + 1;
    i_end = i_start + points_per_map - 1;
    score_PC1 = score(i_start:i_end, 1);
    score_PC2 = score(i_start:i_end, 2);
    score_PC3 = score(i_start:i_end, 3);
    
    if m <= length(maps_iso)
        scatter(score_PC1, score_PC2, 'blue', 'Marker', '.', 'DisplayName', sprintf('ISO%d', m));
    else
        scatter(score_PC1, score_PC2, 'red', 'Marker', '.', 'DisplayName', sprintf('ACM%d', m - length(maps_iso)));
    end

    title('PC2 vs PC1');
    xlabel('PC1');
    ylabel('PC2');
    subtitle('blue: ISO | red: ACM');

    %legend('show', 'Location', 'best');
end

nexttile;
grid on;
hold on;
for m = 1:(length(maps_iso) + length(maps_acm))
    % Mostra per ciascun punto misurato il proprio score lungo la PC
    i_start = points_per_map * (m - 1) + 1;
    i_end = i_start + points_per_map - 1;
    score_PC1 = score(i_start:i_end, 1);
    score_PC2 = score(i_start:i_end, 2);
    score_PC3 = score(i_start:i_end, 3);
    
    if m <= length(maps_iso)
        scatter(score_PC2, score_PC3, 'blue', 'Marker', '.', 'DisplayName', sprintf('ISO%d', m));
    else
        scatter(score_PC2, score_PC3, 'red', 'Marker', '.', 'DisplayName', sprintf('ACM%d', m - length(maps_iso)));
    end

    title('PC3 vs PC2');
    xlabel('PC2');
    ylabel('PC3');
    subtitle('blue: ISO | red: ACM');

    %legend('show', 'Location', 'best');
end

nexttile;
grid on;
hold on;
for m = 1:(length(maps_iso) + length(maps_acm))
    % Mostra per ciascun punto misurato il proprio score lungo la PC
    i_start = points_per_map * (m - 1) + 1;
    i_end = i_start + points_per_map - 1;
    score_PC1 = score(i_start:i_end, 1);
    score_PC2 = score(i_start:i_end, 2);
    score_PC3 = score(i_start:i_end, 3);
    
    if m <= length(maps_iso)
        scatter(score_PC1, score_PC3, 'blue', 'Marker', '.', 'DisplayName', sprintf('ISO%d', m));
    else
        scatter(score_PC1, score_PC3, 'red', 'Marker', '.', 'DisplayName', sprintf('ACM%d', m - length(maps_iso)));
    end

    title('PC3 vs PC1');
    xlabel('PC1');
    ylabel('PC3');
    subtitle('blue: ISO | red: ACM');

    %legend('show', 'Location', 'best');
end