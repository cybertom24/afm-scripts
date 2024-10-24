function plot_raman_spectrum(file, width, name)
  data = load(file);
  wl  = data(:,1);
  int = data(:,2);
  plot(wl, int, "LineWidth", width, "DisplayName", name);
end