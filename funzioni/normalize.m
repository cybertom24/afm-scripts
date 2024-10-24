% Normalizzazione rispetto al valore maggiore
function y = normalize(x)
  factor = max(x);
  y = x ./ factor;
end