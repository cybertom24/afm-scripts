function [m, q, sigma, sigma_m, sigma_q] = fitta_retta_parziale_xy(x, y, x_start, x_end, y_start, y_end)
    % Crea un nuovo array x-y che contiene solo i valori che rispettano i
    % vincoli
    new_x = [];
    new_y = [];
    for i = 1:1:length(x)
        if ( x(i) >= x_start && x(i) <= x_end && y(i) >= y_start && y(i) <= y_end )
            % Se il punto va bene aggiungi le coordinate ad entrambi i
            % vettori
            new_x = [new_x x(i)];
            new_y = [new_y y(i)];
        end
    end
    
    % Se non sono stati trovati punti, ritorna 0 indicando nel sigma che è
    % infinito
    if ( isempty(new_x) )
        m = 0;
        q = 0;
        sigma = Inf;
        sigma_m = Inf;
        sigma_q = Inf;
        return
    end

    %xline(new_x(1), 'linestyle', '--','HandleVisibility','off');
    %xline(new_x(end), 'linestyle', '--','HandleVisibility','off');
    %yline(new_y(1), 'linestyle', '--','HandleVisibility','off');
    %yline(new_y(end), 'linestyle', '--','HandleVisibility','off');
    %plot(new_x, new_y);

    [m, q, sigma, sigma_m, sigma_q] = fitta_retta(new_x, new_y);
end