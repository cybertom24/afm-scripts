function salva_mappa_come_vettore(map, filename)
    v = map(:);
    writematrix(v, filename);
end