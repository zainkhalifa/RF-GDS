function [XY,count] = minWidth_corr(XY,minWidth,minGrid,SmallestWireWidth,units)
% This function will use minWidth_scan to do full sweep over a total
% element XY data. It will run scans to determine the best window size and
% ranges with overlap to minimize errors or unneeded diformations.
% Author : Zainulabideen Khalifa            Last Revision : 05/02/2020

    count = [0 0 0];  % for forward and backward and total
    window_size = ceil(minWidth/minGrid);   % ceil to be in the safe side
    t = cputime;
    r = 0.9;             % control this if there is much deformation
    bigwin = round(r*SmallestWireWidth) + mod(round(r*SmallestWireWidth),2);
    for i=1:bigwin/2:length(XY(:,1))-bigwin
        fprintf("minWidth_corr: Processing time elapsed = %0.2f s\n",cputime-t);
        XY1 = XY(i:i+bigwin,:);
        XY2 = flip(XY(i:i+bigwin,:));

        count(1:2) = 0;
        % look by sweeping along x-axis
        [XY1,count(1)]= minWidth_scan(XY1,window_size,minWidth,units,'x');
        % look by sweeping along x-axis
        [XY2,count(2)]= minWidth_scan(XY2,window_size,minWidth,units,'x');

        if (count(1) <= count(2)) && (count(1) ~=0 )
             XY(i:i+bigwin,:) = XY1;count(3) = count(3)+count(1);
        else,XY(i:i+bigwin,:) = flip(XY2);count(3) = count(3)+count(2);
        end
        
        XY1 = XY(i:i+bigwin,:);
        XY2 = flip(XY(i:i+bigwin,:));

        count(1:2) = 0;
        % look by sweeping along y-axis
        [XY1,count(1)]= minWidth_scan(XY1,window_size,minWidth,units,'y');
        % look by sweeping along y-axis
        [XY2,count(2)]= minWidth_scan(XY2,window_size,minWidth,units,'y');

        if (count(1) <= count(2)) && (count(1) ~=0)
              XY(i:i+bigwin,:) = XY1;count(3) = count(3)+count(1);
        else, XY(i:i+bigwin,:) = flip(XY2);count(3) = count(3)+count(2);
        end
    end
    count = count(3);
    % remove consecutive duplicates
    XY(diff(XY(:,1))==0 & diff(XY(:,2))==0,:) = []; 
end

