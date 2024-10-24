function y = gaussian(x, a, b)
    y = x*0;
    for i = 1:1:length(x)
        y(i) = (1/(b*sqrt(2*pi))) * exp( -( ((x(i) - a)^2)/(2*b^2) ) );
    end
end