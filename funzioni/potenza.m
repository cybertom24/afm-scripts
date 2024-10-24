function y = potenza(x, p)
    y = sign(x) .* (abs(x) .^ p);
end