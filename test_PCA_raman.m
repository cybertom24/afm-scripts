%% --- Carica la mappa Raman ---
clear;

[file, dir] = uigetfile('*.txt');
filename = fullfile(dir, file);

temp1file = 'temp1file.tsv';
temp2file = 'temp2file.tsv';

fid_temp1 = fopen(temp1file, 'w');
fid_temp2 = fopen(temp2file, 'w');

fid = fopen(filename, 'r');

% Salta la prima riga
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

shift = load(temp1file);
data = load(temp2file);

delete(temp1file);
delete(temp2file);

x = data(:, 1);
y = data(:, 2);
intensities = data(:, 3:end);

% start = 600;
% stop = 3000;
% intensities = intensities(:, (shift >= start & shift <= stop));
% shift = shift(shift >= start & shift <= stop);

%% --- Analizza la mappa ---

% Per la PCA servono
% X = matrice dei dati PxN
%     Le righe contengono gli spettri disposti come appunto vettori riga,
%     ovvero 1xN
%     Le colonne sono quindi i conteggi per ciascuno shift raman per ogni
%     punto misurato
%     Sono stati misurati P punti e quindi altrettanti spettri composti da
%     N coppie shift-intensità
%     Lo shift n-esimo è contenuto nel vettore x_spect

% Normalizza i dati
% Rispetto allo zscore (non va bene)
% int_norm = zscore(intensities);
% Rispetto al massimo
int_norm = intensities; %./ max(intensities, [], 2);

figure;
grid on;
hold on;
plot(shift, int_norm(1, :));
plot(shift, int_norm(2, :));
plot(shift, int_norm(3, :));

% Esegui la PCA
[coeff, score, latent, ~, explained] = pca(int_norm);

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

s = size(score);
l = sqrt(s(1));
L = 25;
% Rendi una matrice anche le x e le y
X = linspace(0, 25, l);
Y = linspace(0, 25, l);

% Crea la cmap
cstart = [0, 1, 0];
cend = [1, 0, 0];
cmap = [ linspace(cstart(1), cend(1), 256)', ...
         linspace(cstart(2), cend(2), 256)', ...
         linspace(cstart(3), cend(3), 256)' ];

% Per ciascuna componente q-esima
for q = 1:5
    % Recupera i coefficienti
    coeff_PC = coeff(:, q);

    % Plotta i coefficienti per generare la PC in funzione dello shift raman
    % ovvero mostra come ogni shift raman contribuisce alla PC
    figure;
    tiledlayout(1, 2);

    nexttile;
    hold on;
    grid on;
    title(['Peso di ciascuno shift raman sulla PC ' num2str(q)]);
    xlabel('shift [cm^{-1}]');
    ylabel('coeff');
    plot(shift', coeff_PC);

    % Mostra per ciascun punto misurato il proprio score lungo la PC
    score_PC = score(:, q);
    % Rendila un quadrato
    l = round(sqrt(length(x)));
    map_PC = zeros(l, l);
    for i = 1:l
        for j = 1:l
            map_PC(i, j) = score_PC((i-1) * l + j);
        end
    end

    nexttile;
    imagesc(X, Y, map_PC);
    axis image;
    set(gca, 'YDir', 'normal');
    cb = colorbar;
    colormap(cmap);
    title(['mappa PC ' num2str(q)]);
end

