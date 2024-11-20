% Calcola il modulo di Young e quello ridotto della curva di carico e di
% quella di scarico.
function [El, Eridl, Eu, Eridu] = calcola_E(filename, slope, k, R, v)
    [zl, Nfl, zu, Nfu] =  load_curva_forza(filename);

    [El, Eridl] = calcola_E_da_curva_z_Nf(zl, Nfl, slope, k, R, v);
    [Eu, Eridu] = calcola_E_da_curva_z_Nf(zu, Nfu, slope, k, R, v);
end