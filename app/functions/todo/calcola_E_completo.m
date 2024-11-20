% Calcola il modulo di Young e quello ridotto in modo completo, facendo
% automaticamente la calibrazione.
% Bisogna però indicare quale sia la costante elastica del cantilever,
% quale sia il raggio della punta in metri e quale sia il coefficiente di
% Poisson (se non lo si conosce mettere 1).
% Il modulo viene calcolato a partire dalla curva di unloading perché è
% quella che rappresenta meglio le proprietà elastiche del campione
% [Kontomaris 2017, pag. 11]
function [E, Erid, u_E, U_Erid] = calcola_E_completo(curva_filename, calibrazione_filename, k, R, v)
    % Calibra recuperando la slope (interessa solo quella di scarico)
    [slopel, slope] = calibra(calibrazione_filename);
    
    % Recupera la curva di scarico 
    [zl, Nfl, z, Nf] = load_curva_forza(curva_filename);

    % Calcola E
    [E, Erid, u_E, U_Erid] = calcola_E_da_curva_z_Nf(z, Nf, slope, k, R, v);
end