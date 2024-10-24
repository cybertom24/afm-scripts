function [xm, ym] = mediate(x1, y1, x2, y2)
  l = min(length(x1), length(x2))
  xm = 1:1:l;
  ym = xm;
  
  for i = 1:1:l
    xm(i) = (x1(i) + x2(i)) / 2;
    ym(i) = (y1(i) + y2(i)) / 2;
  endfor
endfunction