%% --- Carica le mappe degli score ---

if ~exist('dir_name', 'var')
    dir_name = '.';
end

[file_name, dir_name] = uigetfile(fullfile(dir_name, '*.txt'), 'Seleziona gli score degli ISO');
if ~isequal(file_name, 0)
    scores_iso = load(fullfile(dir_name, file_name));
end

[file_name, dir_name] = uigetfile(fullfile(dir_name, '*.txt'), 'Seleziona gli score degli ACM');
if ~isequal(file_name, 0)
    scores_acm = load(fullfile(dir_name, file_name));
end

%% --- Esegui LDA ---

% Raggruppa i dati in un'unica matrice
% Inserisci solo le prime 3 PC
X = [ scores_iso(:, 1), scores_iso(:, 2), scores_iso(:, 3);
      scores_acm(:, 1), scores_acm(:, 2), scores_acm(:, 3) ];

% Crea una lista che indichi come separare i dati
classes = cell(length(scores_iso) + length(scores_iso), 1);
for i = 1:length(scores_iso)
    classes{i} = 'iso';
end
for i = (length(scores_iso) + 1):length(classes)
    classes{i} = 'acm';
end

% Crea un classificatore lineare
classifier = fitcdiscr(X, classes);

% Recupera i coefficienti e le costanti che danno origine al piano che
% separa le due classi
K = classifier.Coeffs(1, 2).Const;
L = classifier.Coeffs(1, 2).Linear;
% Il piano è definito dall'equazione
% [x y z]*L + K = 0
% Crea quindi la funzione che lo rappresenta
% In questo caso le coordinate rappresentano:
% x -> pc1
% y -> pc2
% z -> pc3
piano = @(pc1, pc2, pc3) K + [pc1 pc2 pc3]*L;

%% --- Plotta i dati raccolti ---

figure;
hold on;
grid on;
legend show;
scatter3(scores_iso(:, 1), scores_iso(:, 2), scores_iso(:, 3), 'DisplayName', 'H-CO', 'Marker', '.');
scatter3(scores_acm(:, 1), scores_acm(:, 2), scores_acm(:, 3), 'DisplayName', 'D-CO', 'Marker', '.');
h_piano = fimplicit3(piano, [get(gca, 'XLim') get(gca, 'YLim') get(gca, 'ZLim')]);
h_piano.DisplayName = 'Boundary between H-CO and D-CO';
h_piano.MeshDensity = 5;
h_piano.FaceAlpha = 0.3;
h_piano.FaceColor = [0 1 0];
title('PC space');
xlabel('PC1');
ylabel('PC2');
zlabel('PC3');

%% --- Mostra la sola direzione ortogonale del piano ---

% Il piano è definito dalla terna L = [a, b, c] che è un vettore ortogonale
% al piano
% Per ottenere la componente di un punto P = [x, y, z] lungo la direzione
% ortogonale al piano bisogna fare:
% l = (P * L - K) / ||L||
% Ovvero il prodotto scalare tra P e L diviso poi per la norma di L (per
% normalizzare)
% E' importante però prima rimuovere la costante di scostamento del piano
% dall'origine K

pcx_score_iso = (scores_iso(:, 1:3) * L - K) / norm(L);
pcx_score_acm = (scores_acm(:, 1:3) * L - K) / norm(L);

figure;
grid on;
hold on;
legend show;
swarmchart(pcx_score_iso*0, pcx_score_iso, 'SizeData', 50, 'DisplayName', 'H-CO', 'Marker', '.','XJitterWidth', 0.5);
swarmchart(pcx_score_acm*0 + 1, pcx_score_acm, 'SizeData', 50, 'DisplayName', 'D-CO', 'Marker', '.','XJitterWidth', 0.5);
yline(0, 'DisplayName', 'Boundary', 'Color', [0 0 0], 'LineWidth', 2);
title('New PC space');
% xlabel('');
ylabel('PCx');
xticklabels([]);
set(gca, 'XGrid', 'off');
set(gca().XAxis, 'Visible', 'off');

%% Genera i box plot

% Box plot per classe
figure;
grid on;
hold on;
boxplot([pcx_score_iso, pcx_score_acm], 'Notch', 'off', 'Labels', {'H-CO', 'D-CO'});
title('PCx score between two classes');
ylabel('PCx score');

% Box plot per campione
l_iso = length(pcx_score_iso);
l_acm = length(pcx_score_acm);
figure;
grid on;
hold on;
boxplot([pcx_score_iso(1:(l_iso/4)), ...
         pcx_score_iso((l_iso/4 + 1):(2 * l_iso/4)), ...
         pcx_score_iso((2 * l_iso/4 + 1):(3 * l_iso/4)), ...
         ... pcx_score_iso((3 * l_iso/4 + 1):end), ...
         pcx_score_acm(1:(l_iso/4)), ...
         pcx_score_acm((l_acm/4 + 1):(2 * l_acm/4)), ...
         ... pcx_score_acm((2 * l_acm/4 + 1):(3 * l_acm/4)), ...
         pcx_score_acm((3 * l_acm/4 + 1):end)], ...
         'Notch', 'off', 'Labels', {'H-CO n1', 'H-CO n2', 'H-CO n3', 'D-CO n1', 'D-CO n2', 'D-CO n3'});
title('PCx score between the samples');
ylabel('PCx score');


%% --- Genera i coeff di PCx ---
% Combina i pesi delle PC secondo i coefficienti del piano in modo da
% formare i pesi della nuova PC

% Prima carica i coeff delle PC
[file_name, dir_name] = uigetfile(fullfile(dir_name, '*.txt'), 'Seleziona i loadings della PC1');
if ~isequal(file_name, 0)
    data = load(fullfile(dir_name, file_name));
    shift = data(:, 1);
    pc1_loadings = data(:, 2);
end

[file_name, dir_name] = uigetfile(fullfile(dir_name, '*.txt'), 'Seleziona i loadings della PC2');
if ~isequal(file_name, 0)
    data = load(fullfile(dir_name, file_name));
    shift = data(:, 1);
    pc2_loadings = data(:, 2);
end

[file_name, dir_name] = uigetfile(fullfile(dir_name, '*.txt'), 'Seleziona i loadings della PC3');
if ~isequal(file_name, 0)
    data = load(fullfile(dir_name, file_name));
    shift = data(:, 1);
    pc3_loadings = data(:, 2);
end

% Ora combinali secondo i coefficienti
% Normalizza in modo che poi si possa calcolare lo score semplicemente
% facendo
% score = p_spectrum * pcx_loading
pcx_loadings = (L(1) * pc1_loadings + L(2) * pc2_loadings + L(3) * pc3_loadings) / norm(L);

%% Plotta la PCx
figure;
hold on;
grid on;
legend('show', 'location', 'best');
%plot(shift, (pc1_loadings / max(abs(pc1_loadings))) + 4, 'DisplayName', 'PC1 loadings', 'LineWidth', 2);
%plot(shift, (pc2_loadings / max(abs(pc2_loadings))) + 2, 'DisplayName', 'PC2 loadings', 'LineWidth', 2);
%plot(shift, (pc3_loadings / max(abs(pc3_loadings))), 'DisplayName', 'PC3 loadings', 'LineWidth', 2);
plot(shift, pcx_loadings, 'DisplayName', 'PCx loadings', 'LineWidth', 2);
xlabel('Raman shift [cm^{-1}]');
ylabel('coeff [a.u.]');
title('Spectrum of PCx');
% yticklabels([]);