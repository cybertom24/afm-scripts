% Test della tecnica SVD (Singular Value Decomposition) secondo quanto
% indicato da Ramponi

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

%% Accorpa le mappe in due matrici separate
points_per_map = size(maps_acm{1}, 1);

mega_map_iso = zeros(points_per_map * length(maps_iso), length(shifts));
mega_map_acm = zeros(points_per_map * length(maps_acm), length(shifts));

for i = 1:length(maps_iso)
    mega_map_iso( (points_per_map*(i-1) + 1):(points_per_map*i) , 1:end) = maps_iso{i};
end

for i = 1:length(maps_acm)
    mega_map_acm( (points_per_map*(i-1) + 1):(points_per_map*i) , 1:end) = maps_acm{i};
end

% Gira le matrici in modo che gli spettri siano rappresentati da vettori
% colonna
Xiso = mega_map_iso';
Xacm = mega_map_acm';

fprintf('Mega map pronte\n');

%% Normalizza i dati

Xiso = normalize(Xiso, 1, 'norm');
Xacm = normalize(Xacm, 1, 'norm');

%% Esegui la SVD

[Uiso, Siso, Viso] = svd(Xiso);
[Uacm, Sacm, Vacm] = svd(Xacm);

% Prendi i vettori relativi alla componente principale
u1iso = Uiso(:, 1);
u2iso = Uiso(:, 2);
u3iso = Uiso(:, 3);
u1acm = Uacm(:, 1);
u2acm = Uacm(:, 2);
u3acm = Uacm(:, 3);

%% Mostra i vettori
figure;
grid on;
hold on;
legend show;

plot(shifts, u1iso / max(abs(u1iso)) + 0.5, 'DisplayName', 'u_{1-H}', 'Color', 'b', 'LineWidth', 1.2, 'LineStyle', '-');
plot(shifts, u2iso / max(abs(u2iso)) + 2, 'DisplayName', 'u_{2-H}', 'Color', 'b', 'LineWidth', 1.2, 'LineStyle', ':');
plot(shifts, u3iso / max(abs(u3iso)) + 4, 'DisplayName', 'u_{3-H}', 'Color', 'b', 'LineWidth', 1.2, 'LineStyle', '-.');

plot(shifts, u1acm / max(abs(u1acm)) + 0.5, 'DisplayName', 'u_{1-D}', 'Color', 'r', 'LineWidth', 1.2, 'LineStyle', '-');
plot(shifts, u2acm / max(abs(u2acm)) + 2, 'DisplayName', 'u_{2-D}', 'Color', 'r', 'LineWidth', 1.2, 'LineStyle', ':');
plot(shifts, u3acm / max(abs(u3acm)) + 4, 'DisplayName', 'u_{3-D}', 'Color', 'r', 'LineWidth', 1.2, 'LineStyle', '-.');

title('1st, 2nd and 3rd singular value vector for each class');
xlabel('Raman shift [cm^{-1}]');
ylabel('coefficient [a.u.]');
yticklabels([]);

%% Calcola le matrici di proiezione

Uxiso = Uiso(:, 1:3);
Uxacm = Uacm(:, 1:3);
Piso = Uxiso * Uxiso';
Pacm = Uxacm * Uxacm';

% Per ciascun punto calcola ||x - Pacm*x|| - ||x - Piso*x||
% Il risultato sarà negativo se x è simile a Pacm*x, ovvero viene
% lo spettro proiettato sul sottospazio malato è molto simile a quello 
% originale e perciò lo spettro viene classificato come malato. Un 
% risultato positivo invece indica che la differenza tra lo spettro e la 
% sua proiezione sul sottospazio sano è minore dell'altra e quindi lo
% spettro viene classificato come sano.
scores_iso = zeros(size(Xiso, 2), 1);
for i = 1:length(scores_iso)
    x = Xiso(:, i);
    scores_iso(i) = norm(x - Pacm*x) - norm(x - Piso*x);
end

scores_acm = zeros(size(Xacm, 2), 1);
for i = 1:length(scores_acm)
    x = Xacm(:, i);
    scores_acm(i) = norm(x - Pacm*x) - norm(x - Piso*x);
end

%% Plotta i risultati

% Box plot per classe
figure;
grid on;
hold on;
boxplot([scores_iso, scores_acm], 'Notch', 'off', 'Labels', {'H-CO', 'D-CO'});
title('Scores between two classes');
ylabel('score [a.u.]');

% Box plot per campione
l_iso = length(scores_iso);
l_acm = length(scores_acm);
figure;
grid on;
hold on;
boxplot([scores_iso(1:(l_iso/4)), ...
         scores_iso((l_iso/4 + 1):(2 * l_iso/4)), ...
         scores_iso((2 * l_iso/4 + 1):(3 * l_iso/4)), ...
         ... scores_iso((3 * l_iso/4 + 1):end), ...
         scores_acm(1:(l_iso/4)), ...
         scores_acm((l_acm/4 + 1):(2 * l_acm/4)), ...
         ... scores_acm((2 * l_acm/4 + 1):(3 * l_acm/4)), ...
         scores_acm((3 * l_acm/4 + 1):end)], ...
         'Notch', 'off', 'Labels', {'H-CO n1', 'H-CO n2', 'H-CO n3', 'D-CO n1', 'D-CO n2', 'D-CO n3'});
title('Score between the samples');
ylabel('score [a.u.]');

%% Mostra le proiezioni sugli spazi generati da Pacm e Piso

% Proietta tutta la matrice sullo spazio ISO
Yiso = Piso * Xiso;
% Proietta tutta la matrice sullo spazio ACM
Yacm = Pacm * Xacm;

% Calcola lo spettro medio per ciascuno
mean_spect_iso = mean(Yiso, 2);
mean_spect_acm = mean(Yacm, 2);

% Mostra in figura
figure;
grid on;
hold on;
legend show;
plot(shifts, mean_spect_iso, 'DisplayName', 'Mean spect H-CO');
plot(shifts, mean_spect_acm, 'DisplayName', 'Mean spect D-CO');
title('Spettri medi proiettati sul rispettivo sottospazio');
xlabel('Raman shift [cm^{-1}]');
ylabel('Intensity [a.u.]');

%% Calcola la matrice M
% M è il classificatore
% Infatti se x' * M * x < 0 allora x è considerato 'malato'
% M serve per calcolare:
% x' * M * x = ( ||x - Pacm*x|| )^2 - ( ||x - Piso*x|| )^2 
% E' importante notare come M sia simmetrica

M = 2*(Piso - Pacm) + Pacm * Pacm - Piso * Piso;

x = Xacm(:, 2000);

p = M*x;

figure;
plot(shifts, x');
hold on;
plot(shifts, p);

%% Calcola la p-value
% La p-value indica la probablità che un elemento della classe 1 venga
% interpretato come elemento della classe 2. La stessa cosa viene fatta al
% contrario. Sarebbe in pratica la probabilità che il test fallisca nella
% classificazione.
% Per calcolarlo semplicemente eseguo il test su tutti gli elementi e
% conto gli errori

% Gli errori sono:
%   gli score negativi per gli iso
%   gli score positivi per l'acm
err_count = sum(scores_iso < 0) + sum(scores_acm > 0);

p_value = err_count / (length(scores_acm) + length(scores_iso));

fprintf('Errore del %.1f%%\nAccuratezza del %.1f%%\n', p_value * 100, (1 - p_value)*100);