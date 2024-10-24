close all;
clear;
clc;

x = 0:0.01:6*pi;
y = 2 * x .^2;
[dx, dy] = derivata_locale(x, y, 2);

figure;
hold on;
grid on;
plot(x, y, 'DisplayName', 'y');
plot(dx, dy, 'DisplayName', 'dy');
legend show;
