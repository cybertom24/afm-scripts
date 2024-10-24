function [mu, sigma] = fitta_gaussiana(x, y, start_mu, start_sigma)
    %FITTA_GAUSSIANA Fitta una PDF gaussiana ai punti passati come
    %argomenti
    %   Un po' overkill (sennò non funzionava)
    
    ft = fittype( 'gaussian(x, a, b)' );
    
    opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
    opts.Display = 'Off';
    opts.Robust = 'LAR';
    opts.Lower = [0 0];
    opts.StartPoint = [start_mu start_sigma];
    opts.DiffMinChange = 1e-100;
    opts.DiffMaxChange = 1e-10;
    opts.MaxFunEvals = 1e10;
    opts.MaxIter = 1e10;
    opts.TolFun = 1e-20;
    opts.TolX = 1e-20;

    % Fit model to data.
    [fitresult, gof] = fit( x(:), y(:), ft, opts );

    % Recupera i risultati del fit
    mu = fitresult.a;
    sigma = fitresult.b;
end