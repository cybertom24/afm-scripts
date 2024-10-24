% Normalizzazione rispetto al valore assunto alla x passata
function plot_raman_spectrum_normalized_x(file, x, width, name)
  data = load(file);
  wl  = data(:,1);
  int = data(:,2);
  % interpola il vettore per ottenere y dato x (in caso non sia presente nel suo vettore)
  factor = interp1(wl, int, x);
  new_int = int ./ factor;
  plot(wl, new_int, "LineWidth", width, "DisplayName", name);
endfunction