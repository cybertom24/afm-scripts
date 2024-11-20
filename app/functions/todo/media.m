% Calcola la media di TUTTI gli elementi di un vettore o di una matrice
function m = media(x)%, max_error)
  % Trasforma x in vettore
  x_vettore = x(:);
  x_senza_NaN = [];
  % Scorri tutti gli elementi di x e rimuovi i NaN
  for i = 1:numel(x_vettore)
    % Non conteggiare i NaN
    % Dato che NaN == NaN restituisce falso uso sto trucco
    % Un numero diviso sé stesso deve dare 1. Con i NaN risulta NaN
    if (x_vettore(i) / x_vettore(i)) == 1
      x_senza_NaN = [x_senza_NaN x_vettore(i)];
    end
  end
  % Rimuovi i valori che distano troppo dalla media calcolata all'inizio
  %prima_media = mean(x_senza_NaN);
  %x_buoni = x_senza_NaN( (x <= ((1 + max_error) * prima_media)) & (x >= max_error * prima_media));
  % Calcola la media
  m = mean(x_senza_NaN);
end