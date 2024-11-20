function [zl, dl, zu, du] = calcola_DZ_media(filename_map, filename_calib)
    %CALCOLA_FH_MEDIA Calcola la curva DZ media su tutta la mappa che viene
    %passata tramite filename
    %   filename_map = nome del file che contiene la mappa
    %   filename_calib = nome del file che contiene la curva di
    %   calibrazione
    %   Ritorna:
    %   zl-dl = curva in load
    %   zu-du = curva in unload
    
    
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
    dl = 0*zl;
    du = 0*dl;

    % Calibra
    [slopel, slopeu] = calibra(filename_calib);
    
    % Per ciascuna curva...
    for i = 1:1:size(Nfl_list, 1)
        % Rimuovi il background
        Nfl = rimuovi_background(zl, Nfl_list(i, :), max(zl)/2, max(zl));
        Nfu = rimuovi_background(zu, Nfu_list(i, :), max(zu)/2, max(zu));

        % Converti in deflessione
        dl_i = Nfl / slopel;
        du_i = Nfu / slopeu;
        
        % Aggiungi al totale (così dopo verrà mediato)
        dl = dl + dl_i;
        du = du + du_i;
    end

    % Dividi per il numero di elementi
    dl = dl / size(Nfl_list, 1);
    du = du / size(Nfl_list, 1);
end

