function [count, avg, maxv, minv, med, Ra, Rms, skew, rkurt, surf_area, proj_area, theta, phi] = analizza_superficie(Hmap, L)
    % Serve il toolbox:
    % Statistics and Machine Learning Toolbox


    data = Hmap(:);

    count = length(data);
    avg = mean(data);
    maxv = max(data);
    minv = min(data);
    med = median(data);
    Ra = mean(abs(data - avg));
    Rms = sqrt(mean((data - avg).^2));
    skew = skewness(data);
    rkurt = kurtosis(data) - 3;
    
    z = Hmap;
    [m,n] = size(z);
    l = L / (n + 1);
    [x, y] = meshgrid(linspace(l/2, L - l/2, n), linspace(l/2, L - l/2, n));

    surf_area = 0;
    for i = 1:m-1
        for j = 1:n-1
            v0 = [x(i,j)     y(i,j)     z(i,j)    ];
            v1 = [x(i,j+1)   y(i,j+1)   z(i,j+1)  ];
            v2 = [x(i+1,j)   y(i+1,j)   z(i+1,j)  ];
            v3 = [x(i+1,j+1) y(i+1,j+1) z(i+1,j+1)];
            a = v1 - v0;
            b = v2 - v0;
            c = v3 - v0;
            A = 1/2*(norm(cross(a, c)) + norm(cross(b, c)));
            surf_area = surf_area + A;
        end
    end

    proj_area = L^2;

    x = 0 * data;
    y = 0 * data;
    for i = 0:1:(m - 1)
        for j = 0:1:(n - 1)
            k = j + m*i + 1;
            y(k) = j;
            x(k) = i;
        end
    end

    plane = fit([x, y], data, 'poly11');
    a = plane.p10;
    b = plane.p01;
    c = -1;
    d = plane.p00;

    theta = acos(c / sqrt(a^2 + b^2 + c^2));
    phi = atan2(b, a);
end