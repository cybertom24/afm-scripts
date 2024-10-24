% Calcola la slope per ciascuna delle curve di carico e scarico.
function [slopel, slopeu] = calibra(filename)
    [cal_zl, cal_Nfl, cal_zu, cal_Nfu] = load_curva_forza(filename);

    % Rimozione del background
    [cal_Nfl, b_l] = rimuovi_background(cal_zl, cal_Nfl, 60, 100);
    [cal_Nfu, b_u] = rimuovi_background(cal_zu, cal_Nfu, 60, 100);
    
    % Calcola la slope
    slopel = abs(fitta_retta_parziale(cal_zl, cal_Nfl, -Inf, 0));
    slopeu = abs(fitta_retta_parziale(cal_zu, cal_Nfu, -Inf, 0));
end