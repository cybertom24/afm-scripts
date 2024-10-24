function n = normalizza_minmax(x)
    up = max(x);
    down = min(x);
    factor = up - down;

    n = (x - down) / factor;
end