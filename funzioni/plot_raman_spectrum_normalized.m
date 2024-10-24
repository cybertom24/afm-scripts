% Normalizzazione rispetto al valore più alto
function plot_raman_spectrum_normalized(file, width, name)
  data = load(file);
  wl  = data(:,1);
  int = normalize( data(:,2) );
  plot(wl, int, "LineWidth", width, "DisplayName", name);
endfunction