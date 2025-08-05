[file_name, dir_name] = uigetfile('*.txt', 'Scegli il file contenente lo spettro di background');

if ~isequal(file_name, 0)
    data = load(fullfile(dir_name, file_name));
    shift_bkgr = data(:, 1);
    int_bkgr = data(:, 2);
end

[file_name, dir_name] = uigetfile(fullfile(dir_name, '*.txt'), 'Scegli il file contenente lo spettro misurato');

if ~isequal(file_name, 0)
    data = load(fullfile(dir_name, file_name));
    shift_meas = data(:, 1);
    int_meas = data(:, 2);
end

%% Applica la SVD per ottenere lo spettro normalizzato
% Forse un po' complicato
% Ottieni infine la matrice di proiezione

X = int_bkgr;
[U, S, V] = svd(X);
u = U(:, 1);    % Da notare come la norma di u sia 1

% Costruisci la matrice di proiezione
P = u * u';

%% Rimuovi la componente di background

% Calcola la componente di background nello spettro misurato calcolando la
% proiezione di meas sullo spettro bkgr

int_comp = P * int_meas;

% L'operazione sopra è equivalente a questa:
% a = (int_bkgr / norm(int_bkgr)) * (int_meas' * int_bkgr / norm(int_bkgr));

% Rimuovi la componente di background
int_clean = int_meas - int_comp;

figure;
hold on;
grid on;
legend('show', 'location', 'best');
plot(shift_meas, int_meas, 'DisplayName', 'Spettro misurato');
plot(shift_meas, int_bkgr, 'DisplayName', 'Spettro di background');
plot(shift_meas, int_comp, 'DisplayName', 'Componente di background');
plot(shift_meas, int_clean, 'DisplayName', 'Spettro ripulito');
plot(shift_meas, a, 'DisplayName', 'Spettro boh', 'LineStyle', '--');

% Rimuovi un background lineare
