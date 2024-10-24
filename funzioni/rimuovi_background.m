function [y, b] = rimuovi_background(x, y, x_start, x_end)
    [m, q] = fitta_retta_parziale(x,y,x_start,x_end);
    b = m*x + q;
    y = y - b;
end