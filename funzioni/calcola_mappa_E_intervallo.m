function [Emap, uEmap] = calcola_mappa_E_intervallo(file, slope, k, r, v, n, Rsq_min)
    % Carica le curve della mappa
    data = load(file);
    s = size(data);
    rows = s(1);
    columns = s(2); %#ok<NASGU>
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
    z = zu;
    Nf_list = Nfu_list;

    % Per ciascuna curva calcola E e mettilo nella mappa
    dim = ceil( sqrt(rows - 1) );
    Emap = zeros([dim dim]);
    uEmap = zeros([dim dim]);
    for i = 1:1:dim
        for j = 1:1:dim
            curva = (i-1)*dim + j;
            [Emap(i,j), ~, uEmap(i,j)] = calcola_E_da_curva_z_Nf_intervallo(z, Nf_list(:, curva), slope, k, r, v, n, Rsq_min);
        end
    end
end 