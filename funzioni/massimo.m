% Trova il valore massimo tra TUTTI gli elementi del vettore o della
% matrice
function [M, i] = massimo(x)
    % Trasforma x in vettore
    x = x(:);
    % Trova il massimo
    [M, i] = max(x);
end