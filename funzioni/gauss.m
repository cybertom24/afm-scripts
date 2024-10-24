function y = gauss(x, a, b, c)
    y = a * exp( -((x - b) / c).^2 );
end