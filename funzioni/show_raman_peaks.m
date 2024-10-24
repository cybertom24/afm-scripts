function show_raman_peaks(file, peaks, lineWidth)
  plot_raman_spectrum_normalized_minmax(file, lineWidth, "Spettro Raman");
  hold on;
  
  for i = 1:1:length(peaks)
    p = peaks{i};
    x = p{1};
    n = p{2};
    plot([x x], [-5 5], "color", [rand() rand() rand()], "LineWidth", lineWidth, "linestyle", "--", "DisplayName", [num2str(x) " - " n])
  endfor
  
  legend("location", "northwest");
endfunction