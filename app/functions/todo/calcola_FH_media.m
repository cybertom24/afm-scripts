function [hl, Fl, hu, Fu] = calcola_FH_media(filename_map, filename_calib, k)
    %CALCOLA_FH_MEDIA Calcola la curva FH media su tutta la mappa che viene
    %passata tramite filename
    %   filename_map = nome del file che contiene la mappa
    %   filename_calib = nome del file che contiene la curva di
    %   calibrazione
    %   k = costante elastica del cantilever (dopo calibrazione)
    %   Ritorna:
    %   hl-Fl = curva in load
    %   hu-Fu = curva in unload
    
    
    % Carica le curve della mappa
    data = load(filename_map);
    s = size(data);
    rows = s(1);
    columns = s(2);
    % Nella prima riga troviamo la posizione verticale del piezo.
    % Sono le coordinate orizzontali delle curve z-Nf
    zul = data(1,:);
    % Ciascuna riga partendo dalla seconda contiene la coordinata Nf
    % relativa a ciascun punto della mappa
    Nful_list = data(2:rows, :);
    % Dividi tra le curve di load e unload
    zl = zul(1:end/2);
    zu = zul((end/2+1):end);
    Nfl_list = Nful_list(:, 1:end/2);
    Nfu_list = Nful_list(:, (end/2+1):end);
    
    % Prepara la curva
    hl= 0*zl;
    hu = 0*zl;
    Fl = 0*hl;
    Fu = 0*hl;

    % Calibra
    [slopel, slopeu] = calibra(filename_calib);
    
    % Per ciascuna curva...
    for i = 1:1:size(Nfl_list, 1)
        % Rimuovi il background
        Nfl = rimuovi_background(zl, Nfl_list(i, :), max(zl)/2, max(zl));
        Nfu = rimuovi_background(zu, Nfu_list(i, :), max(zu)/2, max(zu));

        % Converti in deflessione
        dl = Nfl / slopel;
        du = Nfu / slopeu;

        % Calcola l'indentazione
        hl_i = (-zl) - dl;
        hu_i = (-zu) - du;

        % Calcola la forza
        Fl_i = k * dl;
        Fu_i = k * du;
        
        % Aggiungi al totale (così dopo verrà mediato)
        hl = hl + hl_i;
        hu = hu + hu_i;
        Fl = Fl + Fl_i;
        Fu = Fu + Fu_i;
    end

    % Dividi per il numero di elementi
    hl = hl / size(Nfl_list, 1);
    hu = hu / size(Nfl_list, 1);
    Fl = Fl / size(Nfl_list, 1);
    Fu = Fu / size(Nfl_list, 1);
end

