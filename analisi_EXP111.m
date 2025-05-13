%% --- Setup ---
%set(0, 'DefaultAxesFontSize', 14);
%set(0, 'DefaultTextFontSize', 14);

%% --- Carica tutti i file ---

iso_files = {  { 
                 '.\output\exp111\iso exp111 p1 L2.0um MPa k0.50N_m R35.0nm v0.50 n15pt Rsq80% bkg80%.txt', ...
                 '.\output\exp111\iso exp111 p2 L2.0um MPa k0.50N_m R35.0nm v0.50 n15pt Rsq80% bkg80%.txt', ...
                 '.\output\exp111\iso exp111 p3 L2.0um MPa k0.50N_m R35.0nm v0.50 n15pt Rsq80% bkg80%.txt', ...
                 '.\output\exp111\iso exp111 p4 L2.0um MPa k0.50N_m R35.0nm v0.50 n15pt Rsq80% bkg80%.txt' ...
               }, ...
            };

acm_files = {  { 
                 '.\output\exp111\acm exp111 p1 L2.0um MPa k0.50N_m R35.0nm v0.50 n15pt Rsq80% bkg80%.txt', ...
                 '.\output\exp111\acm exp111 p2 L2.0um MPa k0.50N_m R35.0nm v0.50 n15pt Rsq80% bkg80%.txt', ...
                 '.\output\exp111\acm exp111 p3 L2.0um MPa k0.50N_m R35.0nm v0.50 n15pt Rsq80% bkg80%.txt', ...
                 '.\output\exp111\acm exp111 p4 L2.0um MPa k0.50N_m R35.0nm v0.50 n15pt Rsq80% bkg80%.txt' ...
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

h_limits = [0 3000];
bin_size = 100;

hold on;
h_ISO = histogram(iso, 'DisplayName', 'E', 'BinWidth', bin_size, 'Normalization', 'count', 'Visible', 'off');
h_ACM = histogram(acm, 'DisplayName', 'E', 'BinWidth', bin_size, 'Normalization', 'count', 'Visible', 'off');

bin_centers = (min(h_limits) + bin_size/2):bin_size:(max(h_limits) - bin_size/2);

% Recupera i valori
values_ACM = h_ACM.Values;
values_ISO = h_ISO.Values;

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
swarmchart(iso(:) * 0 + 1, iso(:) * 1e6, 'SizeData', 50, 'DisplayName', 'H-CO', 'Marker', '.','XJitterWidth', 0.5);
swarmchart(acm(:) * 0 + 2, acm(:) * 1e6, 'SizeData', 50, 'DisplayName', 'D-CO', 'Marker', '.','XJitterWidth', 0.5);
% title('EXP113');
% xlabel('');
ylabel('E [Pa]');
yscale('log');
gca().XAxis.Visible = 'off';