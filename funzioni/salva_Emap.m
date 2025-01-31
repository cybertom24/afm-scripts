function filename = salva_Emap(Emap, dir, k, R, v, n, Rsq_min, b_start, options)
    arguments
        Emap                (:,:)           {mustBeNumeric,mustBeReal}
        dir                 (1, :)  char    
        k                   (1, 1)          {mustBeNumeric,mustBeReal}
        R                   (1, 1)          {mustBeNumeric,mustBeReal}
        v                   (1, 1)          {mustBeNumeric,mustBeReal}
        n                   (1, 1)          {mustBeNumeric,mustBeReal}
        Rsq_min             (1, 1)          {mustBeNumeric,mustBeReal}
        b_start             (1, 1)          {mustBeNumeric,mustBeReal}
        
        options.name        (1, :)  char                                = 'map'
        options.L           (1, 1)          {mustBeNumeric,mustBeReal}  = 1
        options.um          (1, :)  char                                = 'Pa'
        options.ext         (1, :)  char                                = 'txt'
    end
    
    filename = sprintf('%s L%.1fum %s k%.2fN_m R%.1fnm v%1.2f n%dpt Rsq%2.0f%% bkg%2.0f%%', ...
        options.name, options.L, options.um, k, R * 1e9, v, ...
        round(n), Rsq_min * 100, b_start * 100);
    path = sprintf('%s/%s.%s', dir, filename, options.ext);

    writematrix(Emap, path);
end