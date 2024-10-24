clc;
clear;
close all;

data = load("mappa_E_ps-lpde-12m_11-07-2024.txt");
s = size(data);
rows = s(1)
columns = s(2)
% Nella prima riga troviamo la distanza dal campione (le x -> zSweep)
dist = data(1,:);
% Ciascuna riga partendo dalla seconda contiene la curva f-d relativa ad un
% punto della mappa
f_map = data(2:rows, :);
% Dividi tra le curve di load e unload
dist_load = dist(1:end/2);
dist_unload = dist((end/2+1):end);
f_map_load = f_map(:, 1:end/2);
f_map_unload = f_map(:, (end/2+1):end);

% Per ciascun punto fitta una retta e salvati m
m_map_load = zeros([(rows - 1) 1]);

x_start = 4;
x_end = -3;

for i = 1:1:length(m_map_load)
    m = fitta_retta_parziale(dist_load, f_map_load(i,:),x_start, x_end);
    m_map_load(i) = abs(m);
end

% Crea una mappa quadrata e riempila con i valori in m_map_load
dim = ceil( sqrt(rows - 1) );
m_square_load = zeros([dim dim]);
for i = 1:1:dim
    for j = 1:1:dim
        m_square_load(i,j) = m_map_load((i-1)*dim + j);
    end
end

% Imposta le caratteristiche della punta
slope = 326;
k = 5;

im = image(m_square_load);
colormap(jet);
colorbar;
