function mostra_curva(xy)
    x = xy(:,1);
    y = xy(:,2);

    y = y - y(1);

    plot(x,y);
end