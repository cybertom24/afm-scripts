function img = add_height_map_to_figure(Hmap, options)
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
    
    arguments
        Hmap                (:,:)           {mustBeNumeric,mustBeReal}
        options.L           (1, 1)          {mustBeNumeric,mustBeReal}  = 1
        options.um          (1, 1)  string                              = 'nm'
        options.title       (1, 1)  string                              = 'Heigth map'
        options.cmap        (:, 3)          {mustBeNumeric,mustBeReal}  = jet
        options.axes        (1, 1)                                      = 0;
    end
    
    if options.axes == 0
        options.axes = gca;
    end

    % Create the map's axis
    n_pixel = length(Hmap);
    l_pixel = options.L / n_pixel;
    x = linspace(l_pixel / 2, options.L - l_pixel / 2, n_pixel);
    y = linspace(l_pixel / 2, options.L - l_pixel / 2, n_pixel);
    
    img = imagesc(options.axes, x, y, Hmap); % Indica gli assi prima della matrice
    axis(options.axes, 'image'); % imposta l'aspect ratio giusto
    set(options.axes, 'YDir', 'normal');
    colormap(options.axes, options.cmap);
    cb = colorbar(options.axes);
    xlabel(options.axes, 'x [{\mu}m]');
    ylabel(options.axes, 'y [{\mu}m]');
    ylabel(cb, sprintf('z [%s]', options.um));
    title(['' options.title]);
    xticks(linspace(0, options.L, 5));
    yticks(linspace(0, options.L, 5));
end