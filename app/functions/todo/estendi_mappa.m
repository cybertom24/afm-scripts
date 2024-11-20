function ext = estendi_mappa(map, newDim)
    ext = zeros(newDim);
    factor = newDim ./ size(map);
    for i = 0:1:(newDim(1) - 1)
        for j = 0:1:(newDim(2) - 1)
            ext(i + 1, j + 1) = map( floor(i/factor(1)) + 1, floor(j/factor(2)) + 1);
        end
    end
end