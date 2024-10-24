close all;

rho = exp(j * deg2rad(180));
theta = deg2rad(30);
lambda0 = 10^-6;
n1 = 1;

k = (2 * pi * n1 / lambda0) * [sin(theta); cos(theta); 0];

E0y = 1;
dy = 10^-9;
y = -20 * 10^-7 : dy : 0;

Ei = 0 * y;
Er = 0 * y;

Hi = 0 * y;
Hr = 0 * y;

E0 = [0; 0; E0y];

for i = 1:length(y)
    Ei(i) = E0y * exp(-j * 2 * pi * n1 * cos(theta) / lambda0 * y(i));
    Er(i) = E0y * rho * exp(j * 2 * pi * n1 * cos(theta) / lambda0 * y(i));
    S = j * k;
    Ei_t = [0; 0; Ei(i)];
    Hi(i) = abs(norm(cross(S, Ei_t) / (2 * 120*pi / n1)));
    % Hr(i) = cross(j * k, [0; 0; Ei(i)]) / (2 * 120*pi / n1);
end

plot(y, Ei, 'b');
hold on;
plot(y, Hr, 'r');

Etot = abs(Ei + Er);
plot(y, Etot);