function [X_out, Y_out] = pad_with_NaN(X, Y)

    lx = length(X(:));
    ly = length(Y(:));
    maxl = max(lx, ly);

    X_out = zeros(maxl, 1);
    Y_out = zeros(maxl, 1);
    
    X_out(1:lx) = X(:);
    Y_out(1:ly) = Y(:);

    if lx < maxl
        X_out((lx + 1):end) = NaN;
    end
    if ly < maxl
        Y_out((ly + 1):end) = NaN;
    end
end
