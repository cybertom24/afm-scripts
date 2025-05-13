% Tutti in um
center = [53.86, 55.6];
L = 25;

l = 2;
scans = [ [61.29, 64.84]; 
          [50.43, 50.89];
          [59.29, 45.46];
          [56.19, 58.98] ];

color = [0.30,0.75,0.93];
line_width = 2;
font_size = 14;

for i = 1:size(scans, 1)
    point = scans(i, :);
    pos = point - center + [L/2, L/2];
    
    rectangle(gca, "Position", [(pos(1) - l/2) (pos(2) - l/2) l l], "EdgeColor", color, "LineWidth", line_width);
    text(pos(1) - 2*l/3, pos(2), num2str(i), "Color", color, "HorizontalAlignment", "right", "VerticalAlignment", "middle", "FontSize", font_size, "FontWeight", "bold");
end