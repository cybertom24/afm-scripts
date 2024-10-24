function [ml, mu] = calibrazione(file)
    figure;
    hold on;
    grid on;
    legend show;
    xlabel('z sens [nm]');
    ylabel('cantilever defl. [a.u.]');
    title(['calibrazione ' file]);

    [zl, Nfl, zu, Nfu] = load_curva_forza(file);
    %calcola_E_modH(zu, Nfu, 276, 10, 35, 0.25)

    scatter(zl, Nfl, 'DisplayName','load - raw','Marker','.');

    % Rimuovi il background iniziale fittando la parte piatta
    [m, q] = fitta_retta_parziale(zl, Nfl, 40, 100);
    plot(zl, (m*zl + q), 'DisplayName','background - load');
    Nfl = Nfl - (m*zl + q);

    scatter(zl, Nfl, 'DisplayName','load - no bkgr', 'Marker','.');

    % A questo punto fitta la parte che va da 0 a -2
    [ml, q] = fitta_retta_parziale(zl, Nfl, -2, 0);
    plot(zl, (ml*zl + q), 'DisplayName','fit defl. - load');
    % m indica quindi la sensibilità del sensore alla deflessione del
    % cantilever
    ['m = ' int2str(abs(ml)) ' au/nm (load)']

    % Rifai per l'unload
    scatter(zu, Nfu, 'DisplayName','unload - raw','Marker','.');

    % Rimuovi il background iniziale fittando la parte piatta
    [m, q] = fitta_retta_parziale(zu, Nfu, 40, 100);
    plot(zu, (m*zu + q), 'DisplayName','background - unload');
    Nfu = Nfu - (m*zu + q);

    scatter(zu, Nfu, 'DisplayName','unload - no bkgr', 'Marker','.');

    % A questo punto fitta la parte che va da 0 a -2
    [mu, q] = fitta_retta_parziale(zu, Nfu, -2, 0);
    plot(zu, (mu*zu + q), 'DisplayName','fit defl. - unload');
    % m indica quindi la sensibilità del sensore alla deflessione del
    % cantilever
    ['m = ' int2str(abs(mu)) ' au/nm (unload)']
end