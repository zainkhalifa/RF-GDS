function [ogstr]    = GDS_Split_gstr(igstr,NxN,units)
% GDS_Split_gstr Splits igstr gds_strcuture to NxN boxes so it can be 
% exportable under gdsii file limitations making each element has fewer 
% number of vertices. The func will  maintain the elements information 
% (layer and dtype).
% This function uses GDS_Create_Grid, GDS_MATH
%
% inputs:   igstr is a gds_structure
%           NxN is a number like 5 for 5x5 grid
%
% Author : Zainulabideen Khalifa            Last Revision : 09/02/2020
%
% function [ogstr]    = GDS_Split_gstr(igstr,NxN,units)

    fprintf("\nRunning Split_gstr...\n");
    t = cputime;
    [box_str] = GDS_Create_Grid(igstr,NxN);
    Len = [];
    % initiate the output gds_strcut
    ogstr = gds_structure(get(igstr,'sname'));
        
    for b_idx = 1:length(box_str(:))
        fprintf("Split_gstr #%0.0f or %0.0f...",b_idx,NxN*NxN)
        for S_idx = 1:length(igstr(:))
           gstr = GDS_MATH(box_str(b_idx),igstr(S_idx),'and',units);

           A = igstr(S_idx);
           L = A.layer;
           dtype = A.dtype;
           if length(gstr(:)) == 0
               continue;
           else
               for idx = 1:length(gstr(:))
                   gelm = gstr(idx);
                   XY = cell2mat(xy(gelm));
                   XY = round(200*XY)./200;
                   ogstr(1+end) = gds_element('boundary', 'xy',XY,'layer',L,'dtype',dtype);
                   Len(1+end) = length(XY(:,1));
               end
           end
        end
        fprintf("Total elapsed time = %0.1f s\n",cputime-t)
    end
    fprintf("\nSplit_gstr:Maximum number of vertices = %0.0f\n",max(Len))
    fprintf("DONE!\n",max(Len));
end


