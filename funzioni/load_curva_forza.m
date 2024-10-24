function [z_load, Nf_load, z_unload, Nf_unload] = load_curva_forza(file)
    data = load(file);
    z = data(:,1);
    Nf = data(:,2);

    z_load = z(1:end/2);
    Nf_load = Nf(1:end/2);

    z_unload = z((end/2+1):end);
    Nf_unload = Nf((end/2+1):end);
end