addpath app\functions\

[filename, dirname] = uigetfile("*.txt", "Scegli il file da convertire", fullfile(pwd, "file.txt"));
outdir = uigetdir(dirname, "Scegli la cartella di output");

data = load_E_map(fullfile(dirname, filename));

slope = 30;

z = data(1, :);
Nf = data(2:end, :);
d = Nf / slope;
L = round(sqrt(size(d, 1)));

for i = 0:(L^2 - 1)
    y = floor(i / L);
    x = i - y * L;
    name = fullfile(outdir, sprintf("curve_x%2d_y%2d.csv", x, y));
    
    fid = fopen(name, "w");
    fprintf(fid, "Z (nm),Deflection (nm)");
    fclose(fid);

    writematrix([z', d(i + 1, :)'], name, "WriteMode", "append");
end