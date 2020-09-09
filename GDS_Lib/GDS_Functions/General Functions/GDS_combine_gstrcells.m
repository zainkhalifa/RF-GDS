function [ogstr] = GDS_combine_gstrcells(igstr)
% GDS_MATH GDS_combine_gstrcells will combine all gds_elements in all cells 
% of gds_structure into one structure 
%
% Author : Zainulabideen Khalifa            Last Revision : 09/02/2020
%
% function [ogstr] = GDS_combine_gstrcells(igstr)

    ogstr = gds_structure('MATLAB');
    if iscell(igstr)
        for s_idx = 1:length(igstr(:))
            G = igstr{s_idx};
            for e_idx = 1:length(G(:))
               ogstr(1+end) = G(e_idx); 
            end
        end
        if length(ogstr(:))>4000
            warning("ZAIN: Combined gds structure has more then 4000 elements.")
        end
    else
        error("ZAIN: in GDS_combine_gstr, the input should be a cell array.")
    end
end
