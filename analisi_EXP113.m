%% --- Setup ---
set(0, 'DefaultAxesFontSize', 14);
set(0, 'DefaultTextFontSize', 14);

%% --- Carica tutti i file ---

iso_files = {  { 
                 '.\output\exp113\iso\n1 p1 - k4.61, R30, v0.5, n15, Rsq0.80, b0.90.csv', ...
                 '.\output\exp113\iso\n1 p2 - k4.61, R30, v0.5, n15, Rsq0.80, b1.csv', ...
                 '.\output\exp113\iso\n1 p3 - k4.61, R30, v0.5, n15, Rsq0.80, b0.80.csv', ...
                 '.\output\exp113\iso\n1 p4 - k4.61, R30, v0.5, n15, Rsq0.80, b0.80.csv' ...
               }, ...
               { 
                 '.\output\exp113\iso\n3 p1 - k4.61, R30, v0.5, n15, Rsq0.80, b0.80.csv', ...
                 %'.\output\exp113\iso\n3 p2 - k4.61, R30, v0.5, n15, Rsq0.80, b0.80.csv'
               }, ...
               { 
                 '.\output\exp113\iso\n4 p1 - k4.61, R30, v0.5, n2, Rsq0.80, b1, interp.csv', ...
                 '.\output\exp113\iso\n4 p2 - k4.61, R30, v0.5, n2, Rsq0.80, b0.80, interp.csv', ...
                 '.\output\exp113\iso\n4 p3 - k4.61, R30, v0.5, n2, Rsq0.80, b0.80, interp.csv', ...
                 '.\output\exp113\iso\n4 p4 - k4.61, R30, v0.5, n2, Rsq0.80, b0.85, interp.csv' ...
               }, ...
            };

acm_files = {  { 
                 '.\output\exp113\acm\n1 p1 - k4.2, R30, v0.5, n10, Rsq0.80, b0.90.csv', ...
                 '.\output\exp113\acm\n1 p2 - k4.2, R30, v0.5, n10, Rsq0.80, b0.80.csv', ...
                 '.\output\exp113\acm\n1 p3 - k4.2, R30, v0.5, n10, Rsq0.80, b0.80.csv', ...
                 '.\output\exp113\acm\n1 p4 - k4.2, R30, v0.5, n10, Rsq0.80, b0.80.csv' ...
               }, ...
               { 
                 '.\output\exp113\acm\n2 p1 - k4.2, R30, v0.5, n10, Rsq0.80, b0.90.csv', ...   
                 '.\output\exp113\acm\n2 p2 - k4.2, R30, v0.5, n10, Rsq0.80, b0.80.csv', ...
                 '.\output\exp113\acm\n2 p3 - k4.2, R30, v0.5, n10, Rsq0.80, b0.80.csv', ...
                 '.\output\exp113\acm\n2 p4 - k4.2, R30, v0.5, n10, Rsq0.80, b0.80.csv' ...
               }, ...
               { 
                 '.\output\exp113\acm\n3 p1 - k4.2, R30, v0.5, n10, Rsq0.80, b1.csv', ...
                 '.\output\exp113\acm\n3 p2 - k4.2, R30, v0.5, n10, Rsq0.80, b1.csv', ...
                 '.\output\exp113\acm\n3 p3 - k4.2, R30, v0.5, n10, Rsq0.80, b1.csv', ...
                 %'.\output\exp113\acm\n3 p4 - k4.2, R30, v0.5, n10, Rsq0.80, b0.90.csv', ...
                 %'.\output\exp113\acm\n3 p1bis - k4.2, R30, v0.5, n10, Rsq0.80, b0.80.csv' ...
               }, ...
             };

iso = [];
acm = [];

for sample = iso_files
    sample_files = sample{1};
    for file = sample_files
        iso = [iso load(file{1})];
    end
end

for sample = acm_files
    sample_files = sample{1};
    for file = sample_files
        acm = [acm load(file{1})];
    end
end

%% --- Genera gli istogrammi ---

h_limits = [0 10000];
bin_size = 100;

figure;
grid on;
hold on;
legend show;
h_iso = histogram(iso * 1e-6, 'BinWidth', bin_size, 'DisplayName', 'H-CO', 'Normalization', 'count');
h_acm = histogram(acm * 1e-6, 'BinWidth', bin_size, 'DisplayName', 'D-CO', 'Normalization', 'count');
title('EXP113');
xlabel('E [MPa]');
ylabel('count');
xlim(h_limits);

bin_centers = (min(h_limits) + bin_size/2):bin_size:(max(h_limits) - bin_size/2);

% Recupera i valori
values_ACM = h_acm.Values;
values_ISO = h_iso.Values;

% Aggiungi il padding se necessario
if length(values_ACM) < length(bin_centers)
    values_ACM = [values_ACM, zeros(1, length(bin_centers) - length(values_ACM))];
end

if length(values_ISO) < length(bin_centers)
    values_ISO = [values_ISO, zeros(1, length(bin_centers) - length(values_ISO))];
end

% Fondi gli istogrammi
values = [values_ISO(1:length(bin_centers))', values_ACM(1:length(bin_centers))'];

figure;
grid on;
hold on;
legend show;
title('E distributions - H-CO vs D-CO');
xlabel('E [MPa]');
ylabel('count');
bar(bin_centers, values, 'FaceAlpha', 0.65, 'BarWidth', 1, 'GroupWidth', 0.85);

%% --- Genera lo swarm chart ---

figure;
grid on;
hold on;
legend show;
swarmchart(iso(:) * 0 + 1, iso(:), 'SizeData', 50, 'DisplayName', 'H-CO', 'Marker', '.','XJitterWidth', 0.5);
swarmchart(acm(:) * 0 + 2, acm(:), 'SizeData', 50, 'DisplayName', 'D-CO', 'Marker', '.','XJitterWidth', 0.5);
title('EXP113');
% xlabel('');
ylabel('E [Pa]');

%% --- Genera il box plot logaritmico ---

[padded_iso, padded_acm] = pad_with_NaN(iso, acm);

figure;
grid on;
hold on;
set(gca, 'YScale', 'log');
boxplot([padded_iso, padded_acm], 'Notch', 'off', 'Labels', {'H-CO', 'D-CO'});
% title('PCx score between two classes');
ylabel('E [Pa]');
