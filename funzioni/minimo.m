% Trova il valore massimo tra TUTTI gli elementi del vettore o della
% matrice
function [m, i] = minimo(x)
    % Trasforma x in vettore
    x = x(:);
    % Trova il minimo
    [m, i] = min(x);
end