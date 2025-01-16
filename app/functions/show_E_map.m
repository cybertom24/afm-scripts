function show_E_map(Emap, varargin)
    % Shows Young's modulus map as a new figure window.
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
    % - nothing -
    
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

    cmap = parula(256);
    if nargin >= 4
        cmap = varargin{4};
    end

    figure;
    add_E_map_to_figure(Emap, 'L', L, 'um', um, 'title', title_s, 'image_cmap', cmap);
end