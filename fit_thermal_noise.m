%% --- Carica lo spettro ---
clear;

[file, dir] = uigetfile('*.txt');
filename = fullfile(dir, file);

tempfile = 'tempfile.tsv';

fid_temp = fopen(tempfile, 'w');
fid = fopen(filename, 'r');

% Salta la prima riga
if feof(fid)
    return
end
fgetl(fid);

while ~feof(fid)
    line = fgetl(fid);
    if ischar(line)
        fprintf(fid_temp, '%s\n', line);
    end
end

fclose(fid);
fclose(fid_temp);
clear line;

data = load(tempfile);

delete(tempfile);

x_misura = data(1:end/2, 1);
y_misura = data(1:end/2, 2);

x_fit = data((end/2 + 1):end, 1);
y_fit = data((end/2 + 1):end, 2);

% Trasforma in pulsazione (compensa per i kHz)
w = x_misura * 2*pi * 1e3; 

% Parametri di fit:
% a: rumore bianco di fondo
% b: coefficiente dell'oscillazione armonica 
% wf: pulsazione naturale dell'oscillazione armonica
% Qf: fattore di qualità dell'oscillazione armonica

% Crea la funzione di fit (è obbligatorio avere da qualche parte la x, qui è al posto di w)
% params = [wf, Qf, a, b]
% ATTENZIONE: i parametri vanno messi in ordine alfabetico
f = @(params, x) params(3) + params(4) * params(1)^4 ./ ((x.^2 - params(1)^2).^2 + (x.^2 * params(1)^2) / (params(2)^2));

% Facendone la radice (no)
% f = @(params, x) params(3) + params(4) * params(1)^2 ./ sqrt((x.^2 - params(1)^2).^2 + (x.^2 * params(1)^2) / (params(2)^2));

% Dal sito https://link.springer.com/chapter/10.1007/978-3-030-44787-8_2
% (no)
% f = @(params, x) params(3) + params(4) ./ ( params(2) * sqrt( (x/params(1) - params(1)./x).^2 + params(2)^(-2) ) );

% Definisci il modello 
% Per mostrare il progresso dell'ottimizzazione
options = optimset('Display', 'iter', 'MaxFunEvals', 1000);
% Limiti inferiori dei parametri (wf e Qf positivi)
lower_lim = [0, 0, -Inf, -Inf];
% Limiti superiori dei parametri
upper_lim = [Inf, Inf, Inf, Inf]; 

% Valori iniziali approssimati
[~, imax] = max(y_misura);
wf_approx = w(imax);
Qf_approx = 100;
a_approx = mean(y_misura);
b_approx = 1;
p0 = [wf_approx, Qf_approx, a_approx, b_approx];

% Ottimizza
p_opt = lsqcurvefit(f, p0, w, y_misura, lower_lim, upper_lim, options);

wf = p_opt(1);
Qf = p_opt(2);
a = p_opt(3);
b = p_opt(4);

figure;
grid on;
hold on;
legend show;
title('Fit rumore termico');
xlabel('f [kHz]');
ylabel('Mag [au]');

plot(x_misura, y_misura, 'DisplayName', 'Spettro misurato', 'Marker', '.');
plot(x_fit, y_fit, 'DisplayName', 'Spettro fit (AIST)', 'Marker', '.');

plot(x_misura, f(p_opt, w), 'DisplayName', 'Spettro fittato (MATLAB)', 'Marker', '.');

xm = linspace(min(x_misura), max(x_misura), 1000);
% plot(xm, f(p_opt, (xm * 2e3 * pi)), 'DisplayName', 'Spettro fittato completo');

fprintf('Valori fittati\nfr: %.3f kHz, Qf: %.1f\n', wf / (2e3*pi), Qf);

% uifig = uifigure;
% uialert(uifig, sprintf('Il fit è risultato nei seguenti valori:\nfr = %.2f kHz\nQ = %.2f\n', wf / (2e3 * pi), Qf), 'Risultato', 'Icon', 'success');

%%

w_fit = x_fit * 2e3 * pi;

% Provo a fittare il fit di AIST
p_opt = lsqcurvefit(f, p0, w_fit, y_fit, lower_lim, upper_lim, options);

wf = p_opt(1);
Qf = p_opt(2);
a = p_opt(3);
b = p_opt(4);

figure;
grid on;
hold on;
legend show;
title('Fit del fit');
xlabel('f [kHz]');
ylabel('Mag [au]');

plot(x_fit, y_fit, 'DisplayName', 'Spettro fittato (AIST)', 'Marker', '.');

plot(x_fit, f(p_opt, w_fit), 'DisplayName', 'Spettro fittato del fit', 'Marker', '.');

plot(x_fit, f([wf, 228.2, a, b * 2/3], w_fit), 'DisplayName', 'Spettro secondo AIST', 'Marker', '.');
fprintf('Valori fittati sul fit\nfr: %.3f kHz, Qf: %.1f\n', wf / (2e3*pi), Qf);
