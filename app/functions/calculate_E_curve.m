function [E, Erid, u_E, u_Erid] = calculate_E_curve(z, d, k, R, v, n, Rsq_min)
    % Calculates Young's modulus from a position (z) - defection (d) force
    % curve.
    % Note: backround must be removed beforehand.
    % ----
    % Arguments
    % z [m] = vector containing the vertical position of the cantilever (z)
    % meters.
    % d [m] = vector containing the deflection of the cantilever (d) in
    % meters.
    % k [N/m] = spring constant of the cantilever in N/m.
    % R [m] = Tip's radius in meters.
    % v [ ] = Material's Poisson's ratio. If unknown, put 1.
    % n [ ] = Moving Average Filter's size in points. It is also used to 
    % define the derivative's window's size.
    % Rsq_min [] = Every point fit must have a Rsq value higher than this. 
    % By putting Rsq_min = 0 no point is excluded, even the ones with 
    % terrible (Rsq ~ 0) fit.
    % Returns:
    % E [Pa] = Young's modulus computed. If the fit failed or it's not
    % acceptable (Rsq < Rsq_min) the value is NaN.
    % Erid [Pa] = Reduced Young's modulus computed. Usefull if the
    % Poisson's ratio is unknown or if tip's elastic modulus is comparable
    % with the material's.


    % -- Clean curve --

    % Flip vectors if necessary
    [~, i_max] = max(d);
    [~, i_min] = min(d);

    if i_max < i_min
        d = flip(d);
        z = flip(z);
    end

    % --- Moving Average Filter ---
    % Create coefficients' vector in order to calculate the average (point
    % has equal weight)
    coefficients = ones(1, n) / n;
    
    d_mov_avg = filter(coefficients, 1, d);
    % compensate filter's native delay (filter_length - 1) / 2
    fDelay = (length(coefficients) - 1) / 2;
    z_mov_avg = z + abs(z(1) - z(2)) * fDelay;

    % From now on work on the clean curve
    z = z_mov_avg;
    d = d_mov_avg;

    % Compute first derivative
    [dx, dy] = local_derivative(z, d, n);

    % --- Fitting region recognition ---

    % Begin of the fit region coincides with curve's minimum
    [~, i_start] = min(d);

    % End of the fit region coincides with the point where the tip ceases
    % to indent.
    % Pick the first value under -1
    under_minus1 = dx(dy <= -1);
    [~, i_end] = min(z);
    if ~isempty(under_minus1)
        [~, i] = max(under_minus1);
        z_end = under_minus1(i);
        % Find the point in z which corresponds to the firs d point under
        % -1
        % Find the most similar z(i) to z_end
        [~, i_end] = min( abs(z - z_end) );
    end

    % Those are the limits of the fit region. There is no point to fit 
    % outside those limits.
    
    % Calculate the minimum points to fit
    h_max = 0.10 * R;
    delta_z = abs(z(1) - z(2));
    min_pt = h_max / delta_z;
    
    % Set the fit as invalid if there are too few points to be fitted
    if abs(i_start - i_end) < min_pt
        E = NaN;
        Erid = NaN;
        return;
    end

    % Flip vectors if needed
    if i_start > i_end
        i_end = length(z) + 1 - i_end;
        i_start = length(z) + 1 - i_start;

        z = flip(z);
        d = flip(d);
    end

    
    % --- Try every fit and find the best one ---

    % Modify fit's begin and end in order to find the best region to fit

    Rsq_best = 0;
    Rsq_best_start = 0;
    Rsq_best_stop = 0;
    Rsq_best_m = 0;
    Rsq_best_q = 0;

    for i = i_start:1:(i_end - min_pt)
        % i defines the begin of the fit region
        
        % Isolate the fit region
        d_fit = d(i:i_end);
        z_fit = z(i:i_end);

        % Remove offset
        d_fit = d_fit - d_fit(1);
        z_fit = z_fit - z_fit(1);

        % Compute identation
        h_fit = (-z_fit) - d_fit;

        % h(1) = 0 while h(i_max) = h_max. Find that point
        [~, i_max] = min(abs(h_fit - h_max));

        % Shrink again the fit region
        h2fit = h_fit(1:i_max);
        d2fit = d_fit(1:i_max);

        % The fit region must have at least 90% of the minimum points
        % (less than min_pt would be impossible, beacuse it would mean
        % that the tip had idented more than the z had moved)
        if length(h2fit) < 0.9 * min_pt
            continue;
        end

        % Linearize
        d_lin = potenza(d2fit, 2/3);

        % Fit
        [m, q, Rsq] = fit_line(h2fit, d_lin);

        if m <= 0 || isnan(m) || Rsq > 1
            % Cannot be accepted
            continue;
        end

        % Compare the fit goodness
        if Rsq > Rsq_best
            % This is the best fit found (for now)
            Rsq_best = Rsq;
            % Save fit's parameters
            Rsq_best_start = i;
            Rsq_best_stop = i_max;
            Rsq_best_m = m;
            Rsq_best_q = q;
        end
    end
    
    % Fit goodness too low
    if Rsq_best < Rsq_min
        E = NaN;
        Erid = NaN;
        return
    end

    % Compute E
    Erid = (Rsq_best_m ^ 1.5) * 0.75 * k / sqrt(R);
    E = Erid * (1 - v^2);
end