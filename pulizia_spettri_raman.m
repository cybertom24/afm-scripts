% La pulizia che ho implementato è stata fatta seguendo il paper intitolato
% "SVD-based method for intensity normalization, background correction and
%   solvent subtraction in Raman spectroscope exploiting the properties of
%   water stretching vibrations"
% di Jan Palacky et al.
% Journal of Raman Spectroscopy, 42: 1528-1539
% 2011

% La funzione di rimozione della baseline è basata su quest'articolo
% Schulze, H. Georg, et al. "A small-window moving average-based fully automated baseline estimation method for Raman spectra." Applied spectroscopy 66.7 (2012): 757-764.
% ed è al link
% https://it.mathworks.com/matlabcentral/fileexchange/69649-raman-spectrum-baseline-removal
% Occhio! Serve l'addon "Signal Processing Toolbox"

addpath ./app/baseline/

%% Importa i dati necessari

if ~exist('dir_name', 'var')
    dir_name = pwd;
end

[file_name, dir_name] = uigetfile(fullfile(dir_name, '*.txt'), 'Scegli il file contenente gli spettri misurati');

if ~isequal(file_name, 0)
    % Apri la mappa
    temp1file = 'temp1file.tsv';
    temp2file = 'temp2file.tsv';

    fid_temp1 = fopen(temp1file, 'w');
    fid_temp2 = fopen(temp2file, 'w');

    fid = fopen(fullfile(dir_name, file_name), 'r');

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
end

Y = raman_map';
Y_shift = shifts';

[file_name, dir_name] = uigetfile('*.txt', 'Scegli il file contenente lo spettro di background');

if ~isequal(file_name, 0)
    data = load(fullfile(dir_name, file_name));
    shifts = data(:, 1);
    int = data(:, 2);
end

Ys = int;
Ys_shift = shifts;

%% Eguaglia gli shift

% Trova lo shift maggiore con cui partono e quello minore con cui finiscono

start = max(Ys_shift(1), Y_shift(1));
stop = min(Ys_shift(end), Y_shift(end));

% Scegli come numero di punti quello minimo tra l'inizio e la fine
n1 = length(Y(Y_shift >= start & Y_shift <= stop, 1));
n2 = length(Ys(Ys_shift >= start & Ys_shift <= stop, 1));
n = min(n1, n2);

% Crea un vettore lineare che vada da start a stop con n punti
shift = linspace(start, stop, n)';

% Usa l'interpolazione lineare per trovare i punti mancanti e ridefinire
% gli spettri sul vettore appena calcolato
Ys_old = Ys;
Ys = interp1(Ys_shift, Ys, shift);

Y_old = Y;
Y = interp1(Y_shift, Y, shift);

%% Rimuovi il rumore e il background non-Raman

% Unisci tra loro i dataset
X = [Y, Ys];

% Esegui la SVD
[S, W, V] = svd(X);

% Plotta i valori singolari per poter riconoscere quale sia la
% dimensionalità

% Recupera i valori singolari
w = diag(W);

figure;
hold on;
grid on;
title('Valori singolari');
ylabel('Valore [a.u.]');
xlabel('Indice');
scatter(1:length(w), w, 'Marker', '.');
set(gca, 'YScale', 'log');

%% ... continuo ...

% Inserisci la dimensionalità
d = 7;

% Isola i sottospettri
Sd = S(:, 1:d);

% Per ciascuno spettro fitta la baseline e rimuovila

figure;
hold on;
grid on;
title('Sottospettri considerati (normalizzati)');
xlabel('Shift [cm^{-1}]');
ylabel('Indice');

N = 50;
Sdc = 0 * Sd;
for i = 1:d
    sd = Sd(:, i);
    
    % Fitta la baseline usando la funzione apposita
    
    % Trova gli N punti più vicini allo zero
    mins = zeros(N, 1);
    sd_ = abs(sd);
    for j = 1:N
        % Trova il prossimo minimo
        [~, mins(j)] = min(sd_);
        % Toglilo dallo spettro
        sd_(mins(j)) = NaN;
    end

    % Fitta una retta tra questi punti
    mins_y = sd(mins);
    mins_x = shift(mins);
    p = polyfit(mins_x, mins_y, 1);
    sdb = polyval(p, shift);

    plot(shift, (0.5 * sd / max(abs(sd))) + i, 'Color', 'b');
    scatter(mins_x, (0.5 * mins_y / max(abs(sd))) + i, 'Marker', 'o', 'MarkerEdgeColor', 'r');
    plot(shift, (0.5 * sdb / max(abs(sd))) + i, 'Color', 'r');

    sdc = sd - sdb;
    Sdc(:, i) = sdc;
end

% Sistema il riconoscimento della baseline

P = Sd * Sd';

% Ripulisci il dataset
Xc = P * X;

Yc  = Xc(:, 1:size(Y, 2));
Ysc = Xc(:, (size(Y, 2) + 1):end);

figure;
hold on;
grid on;
plot(shift, Xc(:, end), 'Marker', '*');
plot(shift, X(:, end));

%% Rimuovi la componente dell'acqua

[Ssc, Wsc, Vsc] = svd(Ysc);

figure;
hold on;
grid on;
plot(shift, Yc, "Color", 'b', 'LineWidth', 0.3);

%% ... continuo ...

% Inserisci la dimensionalità
ds = 1;

% Isola i sottospettri inutili
Sscc = Ssc(:, 1:ds);

% Restringi le matrici agli shift compresi tra
band = [3150, 3900];

Ycr = Yc(shift >= band(1) & shift <= band(2), :);
Ssccr = Sscc(shift >= band(1) & shift <= band(2), :);

% Rimuovi in ciascuno spettro la componente acquosa
Ycf = 0 * Yc;
for i = 1:size(Yc, 2)
    yr = Ycr(:, i);
    

    Ycf(:, i) = Yc(:, i) - (yr' * Ssccr) * Sscc;
end

figure;
hold on;
grid on;
plot(shift, Ycf, "Color", 'b', 'LineWidth', 0.3);

%% Dagli più passate

% Z = Ycf;
Z = Zf;

Zr = Z(shift >= band(1) & shift <= band(2), :);

% Rimuovi in ciascuno spettro la componente acquosa
Zf = 0 * Z;
for i = 1:size(Z, 2)
    yr = Zr(:, i);
    

    Zf(:, i) = Z(:, i) - (yr' * Ssccr) * Sscc;
end

figure;
hold on;
grid on;
plot(shift, Zf, "Color", 'b', 'LineWidth', 0.3);