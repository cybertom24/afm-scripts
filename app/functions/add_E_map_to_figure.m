function img = add_E_map_to_figure(Emap, varargin)
    % Adds Young's modulus map to the current figure window.
    % ----
    % Arguments:
    % - Mandatory:
    % Emap [x] = matrix containing Young's modulus map in any unity of
    % measure.
    % - Optional:
    % L [um] = Edge size of the map in micrometers. Default: 1 um.
    % um = unity of measure string. Default: 'Pa'.
    % title_s = title_s of the map. Default: 'Elastic modulus map'.
    % cmap = color map to be used. Default: jet.
    %
    % Returns:
    % img = the img handler of the map
    
    nargin = length(varargin);

    L = 1;
    if nargin >= 1
        L = varargin{1};  
    end

    um = 'Pa';
    if nargin >= 2
        um = varargin{2};
    end
    
    title_s = 'Elastic modulus map';
    if nargin >= 3
        title_s = varargin{3};
    end

    cmap = jet;
    if nargin >= 4
        cmap = varargin{4};
    end

    % Create the map's axis
    n_pixel = length(Emap);
    l_pixel = L / n_pixel;
    x = linspace(l_pixel / 2, L - l_pixel / 2, n_pixel);
    y = linspace(l_pixel / 2, L - l_pixel / 2, n_pixel);

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
    ylabel(cb, ['E [' um ']']); % Imposta la label della colorbar
    title(['' title_s]);
    xticks(linspace(0, L, 5));
    yticks(linspace(0, L, 5));

    % Impostare il colore di sfondo a grigio
    set(gca, 'Color', [0.65 0.65 0.65]); % Colore grigio (RGB [0.5, 0.5, 0.5])
    % Rendi i NaN trasparenti
    set(img, 'AlphaData', ~isnan(Emap)); % Alpha 1 per i valori, 0 per i NaN
end