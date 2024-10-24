% Calcola la derivata locale della funzione x-y nell'intorno [i-n; i+n]
function [dx, dy] = derivata_locale(x, y, n)
  dx = x((n+1):(end-n));
  dy = 0 * dx;
  % Per ciascun punto fitta i punti nell'intorno [i-n; i+n] 
  % e recupera il coefficiente angolare
  for i = (n+1):1:(length(x) - n)
    [m, q] = fitta_retta( x((i-n):(i+n)), y((i-n):(i+n)) );
    dy(i-n) = m;
  end
end