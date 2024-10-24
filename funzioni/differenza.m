function [x, y] = differenza(x1, y1, x2, y2)
    %DIFFERENZA Calcola la differenza tra due funzioni quando queste non hanno
    %le x centrate 
    %   y = y1 - y2
    %   dove le x non si trovano, verrà assunto y = 0
    if length(x1) > length(x2)
        x = x1;
        y = x * 0;
        for i = 1:1:length(x1)
            % Se esiste un punto in cui x2 == x1(i)
            if ismember(x1(i), x2)
                % Calcola la differenza
                y(i) = y1(i) - y2(x2 == x1(i));
            else
                % Altrimenti assumi y2 = 0
                y(i) = y1(i) - 0;
            end
        end
    else
        x = x2;
        y = x * 0;
        for i = 1:1:length(x2)
            % Se esiste un punto in cui x1 == x2(i)
            if ismember(x2(i), x1)
                % Calcola la differenza
                y(i) = y1(x1 == x2(i)) - y2(i);
            else
                % Altrimenti assumi y1 = 0
                y(i) = 0 - y2(i);
            end
        end
    end
end

