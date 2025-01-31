function salva_figure(fig, dir, name, options)
    arguments
        fig             (1, 1)
        dir             (1, :)  char    
        name            (1, :)  char
        options.ext     (1, :)  char    = 'png';
    end

    filename = sprintf('%s/%s.%s', dir, name, options.ext);
    saveas(fig, filename);
end
