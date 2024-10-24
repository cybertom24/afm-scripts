close all;
clear;
clc;

addpath ./funzioni/;

k = 1.8:0.1:13;
R = 10:1:35;
R = R * 1e-9;

fatt_map = zeros([length(k) length(R)]);

for i = 1:1:length(k)
    for j = 1:1:length(R)
        fatt_map(i, j) = k(i) / sqrt(R(j));
    end
end

figure;
imagesc(R, k, fatt_map);
colorbar;
    