function [ogstr] = GDS_Mosaic_intersections(igds,Mosaic_gstr,units)
% GDS_Mosaic_intersections will find the elements in Mosaic_gstr that
% intersects with igstr in the first output cell as a gds_structure. It
% will return the other elements in the second cell as a gds_strucutre.
% igstr and Mosaic_gstr are gds_structures or cells of gds_structures.
% Currently, Mosaic_gstr is considered as square grids and I dont know what
% will happen if it was complex cells of structures. 
%
% Author : Zainulabideen Khalifa            Last Revision : 10/04/2020
%
% function [ogstr] = GDS_Mosaic_intersections(igstr,Mosaic_gstr,units)

fprintf("Running GDS_Mosaic_intersections...\n");

% convert all types to structure
    if strcmp(class(igds),'gds_element')
        igstr = gds_structure('MATLAB');
        igstr(1) = igds;
    elseif strcmp(class(igds),'gds_structure')
        igstr = igds;
    elseif iscell(igds)
        igstr = GDS_combine_gstrcells(igds);
    else
        error('ZAIN: Input must be cell, gds_structure or gds_element !')
    end
    if strcmp(class(Mosaic_gstr),'gds_element')
        error('ZAIN: Input Mosaic_gstr cannot be a gds_element !')
    elseif strcmp(class(Mosaic_gstr),'gds_structure')
    elseif iscell(Mosaic_gstr)
        Mosaic_gstr = GDS_combine_gstrcells(Mosaic_gstr);
    else
        error('ZAIN: Input  must be cell, gds_structure or gds_element !')
    end
% now both inputs are gds_structures
    
    ogstr_in = gds_structure('MATLAB');
    ogstr_out = gds_structure('MATLAB');
        
     IDX = 1:length(Mosaic_gstr(:));
     for e_idx2 = 1:length(igstr(:))
        for e_idx1 = 1:length(Mosaic_gstr(:))
            gstr = GDS_MATH(Mosaic_gstr(e_idx1),igstr(e_idx2),'and',units);
            if (length(gstr(:))~=0)
                ogstr_in(1+end) = Mosaic_gstr(e_idx1);
                IDX(find(IDX == e_idx1)) = [];
            end
        end
        fprintf("Processing element#%0.0f in the input structure\n",e_idx2);
     end
     
     for idx = 1:length(IDX)
         ogstr_out(idx) = Mosaic_gstr(IDX(idx));
     end
    ogstr = {ogstr_in ogstr_out};
    fprintf("DONE!\n");

end
% 
%     for e_idx2 = 1:length(igstr(:))
%         for e_idx1 = 1:length(Mosaic_gstr(:))
%             gstr = GDS_MATH(Mosaic_gstr(e_idx1),igstr(e_idx2),'and',units);
%             if (length(gstr(:))~=0)       
%                 ogstr_in(1+end) = Mosaic_gstr(e_idx1);
%             else
%                 ogstr_out(1+end) = Mosaic_gstr(e_idx1);
%             end
%         end
%         fprintf("Processing element#%0.0f in the input structure\n",e_idx2);
%     end



