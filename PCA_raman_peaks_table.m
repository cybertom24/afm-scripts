%% --- Crea il file per la peaks table ---
clear

% Scegli la cartella da aprire
d = uigetdir(pwd, 'Scegli la cartella contenente i file dei picchi');

% Apri tutti i file
files = dir(fullfile(d, '*.txt'));

% Crea la tabella dei picchi
% Sarà una matrice sulle quali righe ci sono i punti della mappa e sulle
% colonne i picchi che sono stati riconosciuti con le relative ampiezze
% Il vettore riga peaks riporta il centro dei picchi riconosciuti
% La matrice peaks_table elenca uno sotto l'altro il vettore riga riportante
% l'ampiezza di ciascun picco per ogni punto della mappa
peaks = zeros(1, length(files));
peaks_table = zeros(1, length(files));

fprintf('Trovati %d picchi\n', length(files));
for i = 1:length(files)
    fprintf('Processando file %d/%d\n', i, length(files));
    f = files(i);

    % Apri il file e recupera la mappa Raman. Quest'ultima conterrà un solo
    % picco
    temp1file = 'temp1file.tsv';
    temp2file = 'temp2file.tsv';
    
    % Lavora con il file temp1 solo se è il primo file che processi in modo
    % da non continuare a leggere sempre gli stessi shift
    if i == 1
        fid_temp1 = fopen(temp1file, 'w');
    end
    fid_temp2 = fopen(temp2file, 'w');

    fid = fopen(fullfile(d, f.name), 'r');
    % Controlla che non sia vuoto
    if feof(fid)
        return
    end

    line = fgetl(fid);
    if i == 1
        fprintf(fid_temp1, '%s\n', line);
    end

    while ~feof(fid)
        line = fgetl(fid);
        if ischar(line)
            fprintf(fid_temp2, '%s\n', line);
        end
    end

    fclose(fid);
    if i == 1
        fclose(fid_temp1);
    end
    fclose(fid_temp2);
    
    if i == 1
        shift = load(temp1file);
    end
    data = load(temp2file);
    
    if i == 1
        y = data(:, 1);
        x = data(:, 2);
    end
    intensities = data(:, 3:end);

    % Ora riconosci il picco
    % Cerca il massimo per ciascuno spettro e salvati shift e intensità
    % Ricordati di trasporre altrimenti sbaglia
    [picchi, picchi_i] = max(intensities');
    % Come picco scegli quello corrispondente al picco più alto che è
    % presente nella mappa
    [~, p] = max(picchi);
    picco_i = picchi_i(p);
    % A questo punto prendi shift e amp per ciascuno spettro
    sft = shift(picco_i);
    amp = intensities(:, picco_i);

    % Aggiungi quanto trovato nella tabella dei picchi
    peaks(i) = sft;
    
    % Inizializza la peaks_table se ce n'è bisogno
    if i == 1
        peaks_table = zeros(length(amp), length(peaks));
    end

    % Genera la peaks table con le ampiezze
    peaks_table(:, i) = amp;
    
    % Oppure con le aree
    % Calcola le aree di ciascun picco
    % areas = trapz(shift', intensities')';
    % peaks_table(:, i) = areas;
end

% Printa i picchi riconosciuti
fprintf('Picchi presenti nella mappa (non sono in ordine, colpa di LabSpec):\n');
for i = 1:length(peaks)
    fprintf('\t%5.2f cm^-1\n', peaks(i));
end

% Normalizza
% peaks_table = normalize(peaks_table, 2, 'range');

% Mostra i primi 3 spettri
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

% Salva la peaks table
% Scegli il percorso
[fileName, dirName] = uiputfile('*.txt', 'Scegli dove salvare la peaks table', 'peaks_table.txt');

% Apri il file e replica la struttura del file txt di LabSpec
% Senza le due tabulazioni prima degli shifts
% Vettore degli shift dei picchi
writematrix(peaks, fullfile(dirName, fileName));
% Matrice
data = [y, x, peaks_table];
writematrix(data, fullfile(dirName, fileName), 'WriteMode','append');

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

%peaks_table = peaks_table(:, peaks >= 300 & peaks <= 500);
%peaks = peaks(peaks >= 300 & peaks <= 500);

% La PCA viene eseguita sulla matrice data_matrix
data_matrix = peaks_table;
% I picchi invece vanno messi in data_vector
data_vector = peaks;

% Mostra i primi 3 spettri
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

%% --- Carica una mappa Raman ---

[file, dir] = uigetfile('*.txt', 'Scegli il file contenente la mappa Raman');
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

shifts = load(temp1file);
data = load(temp2file);

y = data(:, 1);
x = data(:, 2);
raman_map = data(:, 3:end);

% Per restringere i punti
% y = y(x >= -10);
% raman_map = raman_map(x >= -10, :);
% x = x(x >= -10);

% La PCA viene eseguita sulla matrice data_matrix
data_matrix = raman_map;
% Gli shift invece vanno messi in data_vector
data_vector = shifts;

% Mostra i primi 3 spettri
figure;
grid on;
hold on;
plot(shifts, raman_map(1, :), 'DisplayName', 'Spettro 1', 'LineWidth', 2);
plot(shifts, raman_map(2, :), 'DisplayName', 'Spettro 2', 'LineWidth', 2);
plot(shifts, raman_map(3, :), 'DisplayName', 'Spettro 3', 'LineWidth', 2);
legend('show', 'Location', 'best');
title('I primi 3 spettri della mappa');
xlabel('shift Raman [cm^{-1}]');
ylabel('intensità [au]');

%% --- Esegui la PCA ---

% Per la PCA servono
% X = matrice dei dati PxN
%     Le righe contengono gli spettri disposti come appunto vettori riga,
%     ovvero 1xN
%     Le colonne sono quindi i conteggi per ciascuno shift raman per ogni
%     punto misurato
%     Sono stati misurati P punti e quindi altrettanti spettri composti da
%     N coppie shift-intensità
%     Lo shift n-esimo è contenuto nel vettore x_spect

% Esegui la PCA
[coeff, score, latent, ~, explained] = pca(data_matrix);

% PCA identifica Q componenti principali all'interno delle N variabili 
% (ovvero i possibili shift nello spettro) e genera uno spazio
% Q-dimensionale sul quale proiettare ciascun punto (che vive in uno spazio
% N-dimensionale). Le distanze tra i vari punti sono molto più accentuate
% nello spazio Q al posto che in quello N (degli spettri).
% ATTENZIONE: la componente q-esima non è uno shift singolo ma bensì una
% combinazione (penso lineare) di tutti gli shift. I coefficienti di queste
% combinazioni lineari sono riportati nella matrice 'coeff'.
%
% coeff = matrice NxQ dove ciascuno shift raman (identificato come 
%         variabile a sé) viene proiettato lungo le Q componenti principali
%         identificate dalla tecnica. La proiezione genera quindi Q valori
%         che indicano come lo shift contribuisce su ciascuna direzione.
%         Sono i coefficienti delle combinazioni lineari che formano
%         ciascuna direzione.
% score = matrice PxQ dove per ciascun punto misurato viengono proposte le
%         proprie coordinate nel nuovo spazio delle componenti (spazio 
%         Q-dimensionale).
% latent = matrice Qx1 che mostra la varianza spiegata da ciascuna
%          componente principale.
% explained = matrice Qx1 come latent ma come varianza percentuale al posto
%             che assoluta.
%
% Il problema è che le componenti delle matrici sono in ordine di 
% importanza e non nell'ordine in cui sono nella matrice degli spettri.
% Perciò bisogna trovare un modo per passare da componenti a shift raman

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

[filename, dirname] = uigetfile('*.txt', 'Carica il file della morfologia');
Hmap = 0;
if filename ~= 0
    Hmap = load_height_map(fullfile(dirname, filename));
end

da_mostrare = 1:5;
% Per ciascuna componente q-esima
for q = da_mostrare
    % Recupera i coefficienti
    coeff_PC = coeff(:, q);

    % Plotta i coefficienti per generare la PC in funzione dello shift raman
    % ovvero mostra come ogni shift raman contribuisce alla PC
    figure;
    if isequal(Hmap, 0)
        tiledlayout(1, 2);
    else
        tiledlayout(1, 3);
    end

    nexttile;
    % Mostra i loadings (coefficients) per questa PC
    grid on;
    hold on;
    if length(data_vector) > 100
        plot(data_vector', coeff_PC, 'LineWidth', 2);
    else
        stem(data_vector', coeff_PC, 'filled', 'LineWidth', 2);
    end
    title(['Peso di ciascuno shift raman sulla PC ' num2str(q)]);
    xlabel('shift Raman [cm^{-1}]');
    ylabel('coeff');
    % pbaspect([3, 2, 1]);

    % Mostra per ciascun punto misurato il proprio score lungo la PC
    score_PC = score(:, q);
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
    title(['mappa PC ' num2str(q)]);

    % Se c'è mostra la morfologia
    if ~isequal(Hmap, 0)
        nexttile;
        add_height_map_to_figure(Hmap, 'L', Lx, 'um', 'um', 'title', 'Morfologia', 'cmap', slanCM('heat'));
    end
end

%% --- Salva i risultati ---

% Scegli la cartella dove salvare tutti i dati
d = uigetdir(pwd, 'Scegli la cartella dove salvare i risultati della PCA');

if d == 0
    return;
end

writematrix(coeff, fullfile(d, 'coeff.txt'));
writematrix(score, fullfile(d, 'score.txt'));
writematrix(latent, fullfile(d, 'latent.txt'));
writematrix(explained, fullfile(d, 'explained.txt'));

%% Carica i coeff e gli score
[filename, dirname] = uigetfile('*.txt', 'Carica il file dei coeff');
if isequal(filename, 0)
    return
end
coeff = load(fullfile(dirname, filename));

[filename, dirname] = uigetfile('*.txt', 'Carica il file degli score', [dirname '\score.txt']);
if isequal(filename, 0)
    return
end
score = load(fullfile(dirname, filename));

%% --- Salva le PC ---
da_salvare = [1, 2];

% Scopri le dimensioni in x e in y
% I pixel lungo le y sono pari al numero di volte in cui la x si ripete
% uguale
ly = sum(x == x(1));
% Stessa cosa per le x
lx = sum(y == y(1));

dirName = '';
for q = da_salvare
    % Recupera i dati
    coeff_PC = coeff(:, q);
    score_PC = score(:, q);

    % Rendila una matrice (anche non quadrata)
    % Scopri le dimensioni in x e in y
    % I pixel lungo le y sono pari al numero di volte in cui la x si ripete
    % uguale
    ly = sum(x == x(1));
    % Stessa cosa per le x
    lx = sum(y == y(1));
    map_PC = zeros(ly, lx);
    for i = 1:ly
        for j = 1:lx
            map_PC(i, j) = score_PC((i-1) * lx + j);
        end
    end
    
    % Salva la mappa
    [fileName, dirName] = uiputfile('*.txt', ['Scegli dove salvare la mappa della PC' num2str(q)], [dirName 'PC' num2str(q) '_map.txt']);
    if isequal(fileName, 0)
        break
    end
    writematrix(map_PC, fullfile(dirName, fileName));
    
    % Salva i coeff
    [fileName, dirName] = uiputfile('*.txt', ['Scegli dove salvare i coeff della PC' num2str(q)], [dirName 'PC' num2str(q) '_coeff.txt']);
    if isequal(fileName, 0)
        break
    end
    writematrix([data_vector', coeff_PC], fullfile(dirName, fileName));
end

%% --- Plotta i coeff relativi ad una PC---

[filename, dirname] = uigetfile('*.txt', 'Carica il file dei coeff della PC da mostrare');
if isequal(filename, 0)
    return
end
data = load(fullfile(dirname, filename));
data_vector = data(:, 1);
coeff_PC = data(:, 2);

figure;
grid on;
hold on;
if length(data_vector) > 100
    plot(data_vector', coeff_PC, 'LineWidth', 2);
else
    stem(data_vector', coeff_PC, 'filled', 'LineWidth', 2);
end
title('Coeff relativi alla PC');
xlabel('shift Raman [cm^{-1}]');
ylabel('coeff');
