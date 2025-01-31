function [img, imageRGB] = add_E_map_to_figure(Emap, options)
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
    % image_cmap = color map to be used. Default: parula.
    % mask_cmap = color map to indicate NaN and Inf points.
    %
    % Returns:
    % img = the img handler of the map
    % imageRGB = the image as an RGB matrix 
    
    arguments
        Emap                (:,:)           {mustBeNumeric,mustBeReal}
        options.L           (1, 1)          {mustBeNumeric,mustBeReal}  = 1
        options.um          (1, 1)  string                              = 'Pa'
        options.title       (1, 1)  string                              = 'Elastic modulus map'
        options.image_cmap  (:, 3)          {mustBeNumeric,mustBeReal}  = parula
        options.nan_color   (1, 3)          {mustBeNumeric,mustBeReal}  = [0.65 0.65 0.65]
        options.num_color   (1, 3)          {mustBeNumeric,mustBeReal}  = [0 1 0];
        options.inf_color   (1, 3)          {mustBeNumeric,mustBeReal}  = [0.75 0 0];
        options.clim        (1, 2)          {mustBeNumeric,mustBeReal}  = [0 0];
        options.scale       (1, :)  char    {mustBeMember(options.scale, {'linear', 'log'})} = 'linear';  
        options.axes        (1, 1)                                      = 0;
    end

    if options.axes == 0
        options.axes = gca;
    end

    options.mask_cmap = [options.nan_color; options.num_color; options.inf_color];

    % Create the map's axis
    n_pixel = length(Emap);
    l_pixel = options.L / n_pixel;
    x = linspace(l_pixel / 2, options.L - l_pixel / 2, n_pixel);
    y = linspace(l_pixel / 2, options.L - l_pixel / 2, n_pixel);
    
    % Compute mask
    mask = 0 * isnan(Emap) + 1 * (~isnan(Emap) & ~isinf(Emap)) + 2 * isinf(Emap);
    scaled = mask / 2;
    scaled = round(scaled * size(options.mask_cmap, 1));
    % Generate RGB image
    maskRGB = ind2rgb(scaled, options.mask_cmap);
    
    % Compute alpha mask
    alpha = isnan(Emap) | isinf(Emap);
    
    % Compute map's image
    map = Emap;
    % Check if color limits are set
    if ~isequal(options.clim, [0, 0])
        % Clip the values
        map = clip(map, options.clim(1), options.clim(2));
        minE = options.clim(1);
        maxE = options.clim(2);
    else
        minE = min(map(~isinf(map) & ~isnan(map)));
        maxE = max(map(~isinf(map) & ~isnan(map)));
    end
    
    options.clim = [minE, maxE];

    if isequal(options.scale, 'log')
        map = log10(map);
        minE = log10(minE);
        maxE = log10(maxE);
    end
    
    delta = maxE - minE;
    scaled = (map - minE) / delta;
    % Use 'ceil' and not 'round' or 'floor' !!!
    scaled = ceil(size(options.image_cmap, 1) * scaled);
    % Generate RGB image
    bkgRGB = ind2rgb(scaled, options.image_cmap);
    
    % Overlay the mask over the background image using the alpha mask
    imageRGB = (1 - alpha) .* bkgRGB + alpha .* maskRGB;
    
    % Display the final image
    img = image(options.axes, x, y, imageRGB);
     % Set the right aspect ratio
    axis(options.axes, 'image');
    % Set the vertical axis direction to high-to-low
    set(options.axes, 'YDir', 'normal');
    colormap(options.axes, options.image_cmap);
    cb = colorbar(options.axes);
    clim(options.axes, options.clim);
    if isequal(options.scale, 'log')
        set(options.axes, 'ColorScale', 'log');
    end
    xlabel(options.axes, 'x [{\mu}m]');
    ylabel(options.axes, 'y [{\mu}m]');
    ylabel(cb, sprintf('E [%s]', options.um));
    title(options.axes, options.title);
    xticks(options.axes, linspace(0, options.L, 5));
    yticks(options.axes, linspace(0, options.L, 5));
    
    % Add NaN and Inf to the legend

    pos = cb.Position; 
    x_start = pos(1);
    y_start = pos(2);
    w = pos(3);
    h = pos(4);
    h2 = h * 0.035;

    % NaN
    annotation('rectangle', 'Position', [x_start, y_start - 3*h2/2, w, -h2] , 'FaceColor', options.nan_color);
    tb = annotation('textbox', [x_start + w, y_start - 5*h2/2, 1, h2], 'String', 'Model failed', 'FontSize', cb.FontSize, 'FontName', cb.FontName, 'FitBoxToText', 'on', 'EdgeColor', 'none', 'VerticalAlignment', 'middle');
    % drawnow;

    % Inf
    annotation('rectangle', 'Position', [x_start, y_start + h + 3*h2/2, w, h2] , 'FaceColor', options.inf_color);
    tb = annotation('textbox', [x_start + w, y_start + h + 3*h2/2, 1, h2], 'String', 'No indent', 'FontSize', cb.FontSize, 'FontName', cb.FontName, 'FitBoxToText', 'on', 'EdgeColor', 'none', 'VerticalAlignment', 'middle');

    % Debug
    % figure;
    % imagesc(x, y, Emap);
    %  % Set the right aspect ratio
    % axis(options.axes, 'image');
    % % Set the vertical axis direction to high-to-low
    % set(options.axes, 'YDir', 'normal');
    % colormap(options.axes, options.image_cmap);
    % cb = colorbar(options.axes);
    % clim(options.axes, options.clim);
    % if isequal(options.scale, 'log')
    %     set(options.axes, 'ColorScale', 'log');
    % end
    % xlabel(options.axes, 'x [{\mu}m]');
    % ylabel(options.axes, 'y [{\mu}m]');
    % ylabel(cb, sprintf('E [%s]', options.um));
    % title(options.axes, options.title);
    % xticks(options.axes, linspace(0, options.L, 5));
    % yticks(options.axes, linspace(0, options.L, 5));
end