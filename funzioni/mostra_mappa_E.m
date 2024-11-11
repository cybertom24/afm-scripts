function mostra_mappa_E(Emap, varargin)
%MOSTRA_MAPPA_E Mostra la mappa del modulo elastico con titolo, assi,
%colori e altro
%   Emap = mappa da visualizzare
%   L = grandezza mappa (in um)
%   titolo = titolo della figura
    
    nargin = length(varargin);

    L = 1;
    if nargin >= 1
        L = varargin{1};  
    end

    uma = 'Mappa del modulo elastico';
    if nargin >= 2
        uma = varargin{2};
    end
    
    titolo = 'Pa';
    if nargin >= 3
        titolo = varargin{3};
    end

    cmap = jet;
    if nargin >= 4
        cmap = varargin{4};
    end

    % Crea gli assi x e y
    n_pixel = length(Emap);
    l_pixel = L / n_pixel;
    x = linspace(l_pixel / 2, L - l_pixel / 2, n_pixel);
    y = linspace(l_pixel / 2, L - l_pixel / 2, n_pixel);

    figure;
    img = imagesc(x, y, Emap); % Indica gli assi prima della matrice
    axis image; % imposta l'aspect ratio giusto
    %set(gca, 'Units', 'pixels', 'Position', [100 100 400 400]); % [left, bottom, width, height]   imposta la dimensione a 400x400 px
    % Imposta a direzione dell'asse verticale come dal basso verso l'alto
    % Non è più necessario flippare l'immagine
    set(gca, 'YDir', 'normal');
    colormap(cmap);
    cb = colorbar;
    % clim([0, 4000]);
    xlabel('x [{\mu}m]');
    ylabel('y [{\mu}m]');
    ylabel(cb, ['E [' uma ']']); % Imposta la label della colorbar
    title(['' titolo]);
    xticks(linspace(0, L, 5));
    yticks(linspace(0, L, 5));

    % Impostare il colore di sfondo a grigio
    set(gca, 'Color', [0.65 0.65 0.65]); % Colore grigio (RGB [0.5, 0.5, 0.5])
    % Rendi i NaN trasparenti
    set(img, 'AlphaData', ~isnan(Emap)); % Alpha 1 per i valori, 0 per i NaN
end

