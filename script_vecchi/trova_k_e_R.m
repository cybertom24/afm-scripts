% Script che testa le combinazioni di k e R e trova quella migliore
close all;
clear;
clc;

addpath './funzioni/';

k = 1.8:0.1:13;
R = 10:1:35;
v = 0.22;

Eps = 2300e6;
Eldpe = 100e6;

% Trova la slope
[~, slope] = calibra('./dati/curva-zaffiro-11_07_2024.txt');

% Carica le curve della mappa
data = load('./dati/mappa_E_ps-lpde-12m_11-07-2024.txt');
s = size(data);
rows = s(1);
columns = s(2);
% Nella prima riga troviamo la posizione verticale del piezo.
% Sono le coordinate orizzontali delle curve z-Nf
% Calcola la trasposta in modo da utilizzare colonne al posto di righe
zul = data(1,:)';
% Ciascuna riga partendo dalla seconda contiene la coordinata Nf
% relativa a ciascun punto della mappa
% Calcola la trasposta in modo da utilizzare colonne al posto di righe
Nful_list = data(2:rows, :)';
% Dividi tra le curve di load e unload
%zl = zul(1:end/2);
zu = zul((end/2+1):end);
%Nfl_list = Nful_list(1:end/2, :);
Nfu_list = Nful_list((end/2+1):end, :);

% Il modulo di Young viene calcolato solo sulle curve di unload
% [Kontomaris 2017, pag. 11]
z = zu;
Nf_list = Nfu_list;
d_list = 0 * Nf_list;

% Per ciascuna curva rimuovi il background e calcola la deflessione
dim = ceil( sqrt(rows - 1) );
for i = 1:1:dim
    for j = 1:1:dim
        curva = (i-1)*dim + j;
        Nf = rimuovi_background(z, Nf_list(:, curva), max(z)/2, max(z));
        d = Nf / slope;
        d_list(:, curva) = d;
    end
end

% converti in m
z = z * 1e-9;
d_list = d_list * 1e-9;

% Ok ora è tutto pronto per il mega ciclo
% Questa tabella conterrà le differenze per ciascuna coppia k-R
diff_map = zeros([length(k) length(R)]);

% Cicla tutti i valori di k e R
for i = 1:1:length(k)
    for j = 1:1:length(R)
        k_ = k(i);
        R_ = R(j);

        % Calcola la mappa E
        Emap = zeros([dim dim]);
        for l = 1:1:dim
            for m = 1:1:dim
                curva = (l-1)*dim + m;
                Emap(l,m) = calcola_E_modH_lineare(z, d_list(:, curva), k_, R_ * 1e-9, v);
            end
        end

        if sum(isnan(Emap), 'all') ~= 0
            % Ci sono degli errori
            % Skippa il calcolo
            diff_map(i, j) = NaN;
            % Stampa a video
            fprintf('testato k = %f, R = %f -> errori\n', k_, R_);
            continue
        end

        % Calcola la media
        E_lim = 500e6;
        
        % LDPE
        % Quindi con E < E_lim
        bin_size = 10;
        Emap_ldpe = Emap(Emap < E_lim);
        Emap_ldpe = Emap_ldpe(:);

        % Se non ce ne sono skippa
        if isempty(Emap_ldpe)
            % Skippa il calcolo
            diff_map(i, j) = NaN;
            % Stampa a video
            fprintf('testato k = %f, R = %f -> no ldpe\n', k_, R_);
            continue
        end

        [pdf, edges] = histcounts(Emap_ldpe, 'Normalization', 'pdf', 'BinWidth', bin_size);
        
        Elist = pdf * 0;
        for n = 1:1:length(Elist)
            Elist(i) = (edges(i) + edges(i+1)) / 2; 
        end

        % Fitta con curva gaussiana
        media_ldpe = fitta_gaussiana(Elist, pdf, media(Emap_ldpe), std(Emap_ldpe, 0, 'all'));
        

        % PS
        % Quindi con E < E_lim
        bin_size = 100;
        Emap_ps = Emap(Emap > E_lim);
        Emap_ps = Emap_ps(:);

        % Se non ce ne sono skippa
        if isempty(Emap_ps)
            % Skippa il calcolo
            diff_map(i, j) = NaN;
            % Stampa a video
            fprintf('testato k = %f, R = %f -> no ps\n', k_, R_);
            continue
        end

        [pdf, edges] = histcounts(Emap_ps, 'Normalization', 'pdf', 'BinWidth', bin_size);
        
        Elist = pdf * 0;
        for n = 1:1:length(Elist)
            Elist(i) = (edges(i) + edges(i+1)) / 2; 
        end

        % Fitta con curva gaussiana
        media_ps = fitta_gaussiana(Elist, pdf, media(Emap_ps), std(Emap_ps, 0, 'all'));

        % Calcola la differenza
        % Somma quadratica dello scarto relativo
        diff = sqrt( (media_ps / Eps - 1)^2 + (media_ldpe / Eldpe - 1)^2 );

        % Salva il valore nella mappa
        diff_map(i, j) = diff;

        % Stampa a video
        fprintf('testato k = %f, R = %f -> Eps = %f, Eldpe = %f, diff = %f\n', k_, R_, media_ps, media_ldpe, diff);
    end
end

% Salva la tabella
writematrix(diff_map, 'diff_map.xlsx');