function img = add_height_map_to_figure(Hmap, varargin)
    % Adds height map to the current figure window.
    % ----
    % Arguments:
    % - Mandatory:
    % Hmap [x] = matrix containing height map in any unity of
    % measure.
    % - Optional:
    % L [um] = Edge size of the map in micrometers. Default: 1 um.
    % um = unity of measure string. Default: 'nm'.
    % title_s = title_s of the map. Default: 'Height map'.
    % cmap = color map to be used. Default: jet.
    %
    % Returns:
    % img = the img handler of the map
    
    nargin = length(varargin);

    L = 1;
    if nargin >= 1
        L = varargin{1};  
    end

    um = 'nm';
    if nargin >= 2
        um = varargin{2};
    end
    
    title_s = 'Height map';
    if nargin >= 3
        title_s = varargin{3};
    end

    cmap = jet;
    if nargin >= 4
        cmap = varargin{4};
    end

    % Create the map's axis
    n_pixel = length(Hmap);
    l_pixel = L / n_pixel;
    x = linspace(l_pixel / 2, L - l_pixel / 2, n_pixel);
    y = linspace(l_pixel / 2, L - l_pixel / 2, n_pixel);

    img = imagesc(x, y, Hmap); % Indica gli assi prima della matrice
    axis image; % imposta l'aspect ratio giusto
    set(gca, 'YDir', 'normal');
    colormap(gca, cmap);
    cb = colorbar;
    xlabel('x [{\mu}m]');
    ylabel('y [{\mu}m]');
    ylabel(cb, ['z [' um ']']);
    title(['' title_s]);
    xticks(linspace(0, L, 5));
    yticks(linspace(0, L, 5));
end