function [XY,count]= minWidth_scan(XY,window_size,minWidth,units,xy)
% this function scans an XY data for a minWidth DRC violation and correct
% it. it can scan either along x-axis or along y-axis depending on the
% option i
    if      xy=='x', i=2;
    elseif  xy=='y', i=1;
    else,   error("ZAIN: minWidth_corr(xy) is wrong")
    end
    count = 0;
    % look by sweeping along either x or y axis
    for idx = 1:length(XY(:,1))-window_size
        win = idx:idx+window_size-1;
        
        dXY = diff(XY(win,:),1,1);
        sdXY = sign(dXY);
        ywindow = sdXY(:,i);
        dy = abs(XY(idx,2)*ones(length(win),1) - XY(idx:idx+length(win)-1,2));
        dx = abs(XY(idx,1)*ones(length(win),1) - XY(idx:idx+length(win)-1,1));

        ya = ywindow;
        ya(find(ywindow == 0))=[];
        if any(find(diff(ya)))                  %it has a corner
            cor_idx = find(ywindow == -ya(1));
            cor_idx = cor_idx(1);             % the start of the corner
            if (dy(cor_idx) < minWidth/units) && (dx(cor_idx) < minWidth/units)
                count = count +1;                   % count the number of occurances
                cor_win = idx+1:idx+cor_idx-1;
%                IDX = cat(2,IDX,cor_win);% store the location of it
                XY(cor_win,i)=XY(idx,i);
            end
        end
    end

end

