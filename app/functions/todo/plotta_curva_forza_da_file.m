function [z_load, Nf_load, z_unload, Nf_unload] = plotta_curva_forza_da_file(file_curva, file_calibrazione, nome)
    % Carica la curva
    [z_load, Nf_load, z_unload, Nf_unload] = load_curva_forza(file_curva);
    % Rimuovi il background
    [Nf_load] = rimuovi_background(z_load, Nf_load, Nf_load(1), Nf_load(round(end/2)));
    [Nf_unload] = rimuovi_background(z_unload, Nf_unload, Nf_unload(end), Nf_unload(round(end/2)));
    % Plotta
    scatter(z_load, Nf_load, 'DisplayName',[nome ' - load'], 'Marker', '.');
    scatter(z_unload, Nf_unload,'DisplayName',[nome ' - unload'], 'Marker', '.');
end