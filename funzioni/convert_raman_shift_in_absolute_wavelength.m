% Converte lo spettro Raman in lunghezza d'onda assoluta conoscendo la wl di riferimento (wl0)
% Da passare tutto in [m]
function data = convert_raman_shift_in_absolute_wavelength(file, wl0)
  spect = load(file);
  shift = spect(:,1);
  int   = spect(:,2);
  
  wl_abs = shift;
  for i = 1:1:length(shift)
    wl_abs(i) = 1/(1/wl0 - shift(i)*100);
  end
  %wl_abs = wl_abs';
  
  data = [wl_abs int];
end