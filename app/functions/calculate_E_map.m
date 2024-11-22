function [Emap, Eridmap] = calculate_E_map(filename, slope, k, R, v, n, Rsq_min)
    % Calculates Young's modulus' map from file containing the points taken
    % by AFM software.
    % ----
    % Arguments
    % filename = map file's complete name.
    % k [N/m] = spring constant of the cantilever in N/m.
    % R [m] = Tip's radius in meters.
    % v [ ] = Material's Poisson's ratio. If unknown, put 1.
    % n [ ] = Moving Average Filter's size in points. It is also used to 
    % define the derivative's window's size.
    % Rsq_min [] = Every point fit must have a Rsq value higher than this. 
    % By putting Rsq_min = 0 no point is excluded, even the ones with 
    % terrible (Rsq ~ 0) fit.
    % Returns:
    % Emap [Pa] = Matrix containing Young's modulus computed for every 
    % curve. If the fit failed or it's not acceptable (Rsq < Rsq_min) 
    % the value is NaN.
    % Eridmap [Pa] = Matrix containing Young's modulus computed for every 
    % curve. Usefull if the Poisson's ratio is unknown or if tip's elastic 
    % modulus is comparable with the material's.

    % Load map's curves
    data = load(filename);
    s = size(data);
    rows = s(1);
    columns = s(2);
    % Nella prima riga troviamo la posizione verticale del piezo.
    % Sono le coordinate orizzontali delle curve z-Nf
    % Calcola la trasposta in modo da utilizzare colonne al posto di righe
    zul = data(1,:)';
    % Ciascuna riga partendo dalla seconda contiene la coordinata Nf
    % relativa a ciascun punto della mappa
    % Calcola la trasposta in modo da utilizzare colonne al posto di righe
    Nful_list = data(2:rows, :)';
    % Dividi tra le curve di load e unload
    zl = zul(1:end/2);
    zu = zul((end/2+1):end);
    Nfl_list = Nful_list(1:end/2, :);
    Nfu_list = Nful_list((end/2+1):end, :);

    % Il modulo di Young viene calcolato solo sulle curve di unload
    % [Kontomaris 2017, pag. 11]
    z = zu * 1e-9;
    Nf_list = Nfu_list;

    % Per ciascuna curva calcola E e mettilo nella mappa
    dim = ceil( sqrt(rows - 1) );
    Emap = zeros([dim dim]);
    Eridmap = zeros([dim dim]);
    for i = 1:1:dim
        for j = 1:1:dim
            curva = (i-1)*dim + j;
            [Emap(i,j), Eridmap(i,j)] = calculate_E_curve(z, (Nf_list(:, curva) / slope) * 1e-9, k, R, v, n, Rsq_min);
        end
    end
end 