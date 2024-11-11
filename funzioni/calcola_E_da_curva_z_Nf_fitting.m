% Calcola il modulo di Young a partire dalla curva z-Nf che si ottiene
% dal programma 'aist'. Viene eseguita autonomamente la rimozione del
% background.
function [E, Erid, u_E, U_Erid] = calcola_E_da_curva_z_Nf_fitting(z, Nf, slope, k, R, v, n, p)
    % Rimozione background
    Nf = rimuovi_background(z, Nf, max(z) * 0.80, max(z));

    % Calcolo della deflessione
    d = Nf / slope;

    [E, Erid, u_E, U_Erid] = calcola_E_modH_lineare_fitting(z * 1e-9, d * 1e-9, k, R, v, n, p);
end