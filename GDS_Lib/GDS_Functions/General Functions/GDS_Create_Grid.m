function [ogstr]  = GDS_Create_Grid(igstr,NxN)
% GDS_Create_Grid create an NxN boxes based on the bbox of igstr for masking 
% based on an input structure. The boxes must follow min_Grid restriction
% inputs:   igstr is a gds_structure
%           NxN is a number like 5 for 5x5 grid
%
% Author : Zainulabideen Khalifa            Last Revision : 09/02/2020
%
% function [ogstr]  = GDS_Create_Grid(igstr,NxN)

    box_max = bbox(igstr);
    dx = box_max(3)-box_max(1);
    x1 = box_max(1);
    dy = box_max(4)-box_max(2);
    y1 = box_max(2);
    x = [0:NxN].*(1/NxN).*ones(NxN+1,NxN+1); x = x.*dx + x1;
    y = [0:NxN]'.*(1/NxN).*ones(NxN+1,NxN+1);y = y.*dy + y1;
    % Discretize 
    minGrid = 5/1000;          % it is better to do this as an input later on
    x = round(x./minGrid).*minGrid;
    y = round(y./minGrid).*minGrid;
    ogstr = gds_structure('masks');
    for i_idx = 1:NxN
        for j_idx = 1:NxN
            box = [ x(i_idx,j_idx)      y(i_idx,j_idx);...
                    x(i_idx,j_idx+1)    y(i_idx,j_idx+1);...
                    x(i_idx+1,j_idx+1)  y(i_idx+1,j_idx+1);...
                    x(i_idx+1,j_idx)    y(i_idx+1,j_idx);...
                    x(i_idx,j_idx)      y(i_idx,j_idx)];
            ogstr(1+end) = gds_element('boundary', 'xy', box);
        end
    end
end

