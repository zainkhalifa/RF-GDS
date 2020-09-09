function [xo,yo] = Discritize_2P(X,Y,minGrid)
% This fucntion will generate many points in xo and yo so that they are all 
% on the grid specified given two points in X and Y. 
% X and Y must have two points only
% Author : Zainulabideen Khalifa            Last Revision : 05/02/2020

    if length(X)~=2 | length(Y)~=2
        error("ZAIN: Discritize_2P function requires two points only")
        return
    end
    if X(2)~=X(1)
        a = (Y(2)-Y(1))/(X(2)-X(1));
        d = Y(1)-a*X(1);
        % I am not sure about the effect of limiting the number of elements
        % in the linear space function here by applying a power function
        x = linspace(X(1),X(2),(abs(X(1)-X(2))+1).^0.75);
        y = a*x+d;
        x = round(x/minGrid)*minGrid;
        y = round(y/minGrid)*minGrid;
        for idx=2:2:length(x)*2-1
            x = [x(1:idx-1) x(idx)   x(idx:end)];
            y = [y(1:idx-1) y(idx-1) y(idx:end)];
        end
        % elminate the repeated points
        xo = x;%(diff([0 x])~=0 | diff([0 y])~=0);
        yo = y;%(diff([0 x])~=0 | diff([0 y])~=0);
        %simplify horizontal and vertical lines
%         if ~any(diff(yo)) | ~any(diff(xo))   % y or x values doesnt change
%             xo = [xo(1) xo(end)]; 
%             yo = [yo(1) yo(end)];
%         end
%         if a==0
%             xo = [xo(1) xo(end)];
%             yo = [yo(1) yo(end)];
%         end
    else
% using this, the straight lines will have only two points and this is faster
% but to have a uniform data points, I use the code as below
        x = X(1:2);
        y = Y(1:2);
        xo = round(x/minGrid)*minGrid;
        yo = round(y/minGrid)*minGrid;
% %below
%         a = (X(2)-X(1))/(Y(2)-Y(1));
%         d = X(1)-a*Y(1);
%         % I am not sure about the effect of limiting the number of elements
%         % in the linear space function here by applying a power function
%         y = linspace(Y(1),Y(2),(abs(Y(1)-Y(2))+1).^0.75);
%         x = a*y+d;
%         x = round(x/minGrid)*minGrid;
%         y = round(y/minGrid)*minGrid;
%         for idx=2:2:length(y)*2-1
%             x = [x(1:idx-1) x(idx-1) x(idx:end)];
%             y = [y(1:idx-1) y(idx)   y(idx:end)];
%         end
%         xo = x;
%         yo = y;
% %end below 
    end
end

