% Normalizzazione rispetto al valore maggiore e minore
function y = normalize_minmax(x)
  up = max(x);
  down = min(x);
  factor = up - down;
  y = (x - down) / factor;
end