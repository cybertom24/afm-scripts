% Normalizzazione rispetto al valore più alto e più basso
function plot_raman_spectrum_normalized_minmax(file, width, name)
  data = load(file);
  wl  = data(:,1);
  int = normalize_minmax( data(:,2) );
  plot(wl, int, "LineWidth", width, "DisplayName", name);
end