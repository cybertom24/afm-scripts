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
    % acceptable (Rsq < Rsq_min) the value is NaN. +Inf means that no
    % elastic data is present in the curve, meaning the tip has not
    % indented the surface.
    % Erid [Pa] = Reduced Young's modulus computed. Usefull if the
    % Poisson's ratio is unknown or if tip's elastic modulus is comparable
    % with the material's.
    
  
    % Absolute minimum points to begin the fit. Under this number of points
    % the fit is considered Inf.
    min_pt = 5;

    % -- Clean curve --

    % Flip vectors if necessary
    [~, i_max] = max(d);
    [~, i_min] = min(d);

    if i_max < i_min
        d = flip(d);
        z = flip(z);
    end

    % Smooth the curve and work only on that
    [z, d] = moving_average_filter(z, d, n);

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
    
    h_max = 0.10 * R;

    % Set the fit as invalid if there are too few points to be fitted
    if abs(i_start - i_end) < min_pt
        % This means that the curve has not indented the surface enough
        % The elastic modulus is then considered +Inf
        E = +Inf;
        Erid = +Inf;

        % fprintf('exp: %f, found: %f\n', min_pt, abs(i_start - i_end));
        % figure;
        % grid on;
        % yyaxis left;
        % plot(z, d);
        % yyaxis right;
        % plot(dx, dy);
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

    best.val = 0;
    best.start = 0;
    best.stop = 0;
    best.m = 0;
    best.q = 0;
    best.h = 0;
    best.dlin = 0;

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

        % Since h(1) = 0, find i_max such that h(i_max) = h_max
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
        d_lin = custom_power(d2fit, 2/3);

        % Fit
        [m, q, Rsq] = fit_line(h2fit, d_lin);

        if m <= 0 || isnan(m) || Rsq > 1 || ~isreal(Rsq) || ~isreal(m)
            % Cannot be accepted if:
            % m is negative, zero, NaN or complex
            % Rsq is greater than 1 or complex
            continue;
        end

        % Compare the fit goodness
        if Rsq > best.val
            % This is the best fit found (for now)
            best.val = Rsq;
            % Save fit's parameters
            best.start = i;
            best.stop = i_max;
            best.m = m;
            best.q = q;
            best.h = h2fit;
            best.dlin = d_lin;
        end
    end
    
    % Fit goodness too low
    if best.val < Rsq_min
        E = NaN;
        Erid = NaN;
        
        % fprintf('min_pt: %f => %f nm, h/R pt: %f\n', min_pt, min_pt * delta_z * 1e9, abs_min_hR * R / delta_z);
        % figure;
        % grid on;
        % yyaxis left;
        % plot(z, d);
        % yyaxis right;
        % plot(dx, dy);
        return
    end
    
    % Show the best fit
    % fig = figure;
    % grid on;
    % hold on;
    % scatter(best.h, best.dlin, 'Marker', '.', 'DisplayName', 'curve');
    % plot(best.h, best.m*best.h + best.q, 'DisplayName', 'fit');
    % legend('show', 'location', 'best');
    % title('best fit found');
    % xlabel('h [m]');
    % ylabel('d^{2/3} [N^{2/3}]');
    % close(fig);

    % Compute E
    Erid = (best.m ^ 1.5) * 0.75 * k / sqrt(R);
    E = Erid * (1 - v^2);
end