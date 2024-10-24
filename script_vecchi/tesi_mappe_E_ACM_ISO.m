clc;
clear;
close all;

addpath './funzioni/';

dir = 'C:\Users\savol\Documents\Università\Tesi\Dati\AFM\';

[~, slope_iso] = calibra('./dati/curva-zaffiro-11_07_2024.txt');
[~, slope_acm] = calibra('./dati/curva-zaffiro-12_07_2024-s1000.txt');

files = { {'ISO', 'mappa_ISO_map74.txt', slope_iso, [0 0.45 0.74]}, ...
          {'ACM', 'mappa_ACM_map93.txt', slope_acm, [0.85 0.33 0.10]}  };

maps = { {'ISO', 0}, ...
         {'ACM', 0}  };

% Caratteristiche punta e materiale
k = 3.38;      % N/m
R = 30e-9;  % nm
v = 0.5;

bin_size = 50;

for i = 1:1:length(files)
    name = files{i}{1};
    file = files{i}{2};
    slope = files{i}{3};
    color = files{i}{4};

    % Calcola la mappa
    [Emap, uEmap] = calcola_mappa_E([dir file], slope, k, R, v);
    % Rendi in MPa
    Emap = Emap * 1e-6;

    % Conta quanti errori ci sono stati
    numero_NaN = sum(isnan(Emap), 'all');
    tot = length(Emap)^2;
    fprintf('%s: Numero di errori: %d. Successo: %.2f\n', name, numero_NaN, ((tot - numero_NaN) * 100 / tot) );
    
    % Crea gli assi x e y
    n_pixel = length(Emap);
    l_pixel = 2 / n_pixel;
    max_xy = 2;
    x = linspace(l_pixel / 2, max_xy - l_pixel / 2, n_pixel);
    y = linspace(l_pixel / 2, max_xy - l_pixel / 2, n_pixel);

    % Mostra la mappa
    figure;
    img = imagesc(x, y, Emap); % Indica gli assi prima della matrice

    % Imposta a direzione dell'asse verticale come dal basso verso l'alto 
    % Non è più necessario flippare l'immagine
    set(gca, 'YDir', 'normal');
    colormap(jet);
    cb = colorbar;

    % Impostare il colore di sfondo a grigio
    set(gca, 'Color', [0.65 0.65 0.65]); % Colore grigio (RGB [0.5, 0.5, 0.5])
    % Rendi i NaN trasparenti
    set(img, 'AlphaData', ~isnan(Emap)); % Alpha 1 per i valori, 0 per i NaN
    
    % Aggiunge un quadrato grigio sotto la colorbar
    hold on;
    % Ottieni le coordinate della colorbar
    cb_pos = get(cb, 'Position');

    % Imposta le dimensioni e la posizione del quadrato grigio
    xPos = cb_pos(1) + 0.1 * cb_pos(3);
    yPos = cb_pos(2) - 0.05 * cb_pos(4);
    width = cb_pos(3) * 0.8;
    height = 0.02;

    % Aggiungi il testo "NaN" accanto al quadrato grigio
    text(xPos + width + 0.01, yPos + height / 2, 'NaN', 'VerticalAlignment', 'middle');

    % Mantiene l'aspect ratio
    axis image;

    clim([0, 4000]);
    
    title(['Mappa del modulo elastico del campione ' name]);
    xlabel('x [{\mu}m]');
    ylabel('y [{\mu}m]');
    ylabel(cb, 'E [MPa]'); % Imposta la label della colorbar
    
    xticks(0:0.25:max_xy);
    yticks(0:0.25:max_xy);

    % Calcola e mostra l'istogramma
    figure;
    hold on;
    grid on;
    legend show;
    h = histogram(Emap, 'DisplayName', 'E', 'BinWidth', bin_size, 'Normalization', 'pdf', 'FaceColor', color, 'FaceAlpha', 0.65);
    
    xlabel('E [MPa]');
    % ylabel('pdf'); Non serve
    title(['Distribuzione di E del campione ' name]);

    % Fitta con curva gaussiana
    % Come media e dev. std. di partenza dagli numeri a caso
    [mu, sigma, x_fit, y_fit] = fitta_istogramma(h, 1000, 100);

    % Mostra il fit e la media
    plot(x_fit, y_fit, 'DisplayName', 'Fit gaussiano', 'LineWidth', 1.5, 'Color', 'r');
    xline(mu, 'LineStyle','--','Color', 'k', 'DisplayName', [int2str(mu) ' MPa'], 'LineWidth', 1.2);
    
    % Stampa la media e la dev. standard
    fprintf('%s: E = %4.0f MPa +- %4.0f MPa\n', name, mu, sigma);

    maps{i}{2} = Emap;
end

%% Mostra entrambi gli istogrammi uno sopra all'altro
figure;
hold on;
grid on;
legend show;

h_iso = histogram(maps{1}{2}, 'DisplayName', maps{1}{1}, 'BinWidth', bin_size, 'Normalization', 'pdf');
h_acm = histogram(maps{2}{2}, 'DisplayName', maps{2}{1}, 'BinWidth', bin_size, 'Normalization', 'pdf');

%for i = 1:1:length(maps)
%    name = maps{i}{1};
%    Emap = maps{i}{2};
    
%    h = histogram(Emap, 'DisplayName', name, 'BinWidth', bin_size, 'Normalization', 'pdf');
%end

title('Distribuzione di E nelle due mappe');
xlabel('E [MPa]');


% Mostra la differenza tra gli istogrammi

figure;
hold on;
grid on;
% legend show;

% Recupera i dati
y_iso = h_iso.Values;
y_acm = h_acm.Values;
edges_iso = h_iso.BinEdges;
edges_acm = h_acm.BinEdges;
x_iso = edges_iso(1:end-1) + diff(edges_iso)/2;
x_acm = edges_acm(1:end-1) + diff(edges_acm)/2;

% Normalizza le y
%y_iso = normalize(y_iso);
%y_acm = normalize(y_acm);

% scatter(x_iso, y_iso);
% scatter(x_acm, y_acm);

% Calcola la differenza
[x_diff, y_diff] = differenza(x_iso, y_iso, x_acm, y_acm);

% Plotta come se fosse un istogramma
% scatter(x_diff, y_diff, 'Marker','.');
b = bar(x_diff, y_diff, 'DisplayName', 'E_{ISO} - E_{ACM}', 'FaceAlpha', 0.6);

% Colora le barre
for i = 1:length(y_diff)
    if y_diff(i) < 0
        b.FaceColor = 'flat'; % Permette di impostare colori diversi per ciascuna barra
        b.CData(i,:) = [0.85 0.33 0.10]; % Rosso per valori negativi
    else
        b.FaceColor = 'flat';
        b.CData(i,:) = [0 0.45 0.74]; % Blu per valori positivi
    end
end

title('Differenza tra le distribuzioni di E nelle due mappe');
xlabel('E [MPa]');
xlim([-100 3300]);