function [ogstr] = GDS_Merge(igstr,units)
% GDS_Merge will merge all elements in the input structures or cell of
% structures into as little elements as possible. The output is a cell of
% gds_structure. The first cell is the merged one adn the second contians 
% what has not merge. Not to be confused with GDS_Combine !
% Warning: GDS_Merge will lose your layer and dtype info.
%
% Author : Zainulabideen Khalifa            Last Revision : 10/04/2020
%
% function [ogstr] = GDS_Merge(igstr,units)

    if strcmp(class(igstr),'gds_element')
        error('ZAIN: Input must be a gds_structure or cells of gds_structures.');
    end
    if iscell(igstr)
        igstr = GDS_combine_gstrcells(igstr);
    end

    ogstr = gds_structure('MATLAB');
    ogstr(1) = igstr(1);
    
    control = 0;
     while(numel(igstr)>0 && control<100)
         control = control+1;
         tempgstr= gds_structure('MATLAB');
         for idx = 1:length(igstr(:))
            ogstr = GDS_MATH(ogstr(1),igstr(idx),'or',units);
            if numel(ogstr)>1
                for temp_idx = 2:length(ogstr(:))
                   tempgstr(1+end) = ogstr(temp_idx);
                end
            end
         end
         % re-sort the gelms randomly 
         tempgstr = tempgstr(randperm(length(tempgstr(:))));
         igstr = gds_structure('MATLAB');
         for idx = 1:length(tempgstr(:))
             igstr(idx) = tempgstr{idx};
         end
%          igstr = tempgstr;%(randperm(length(tempgstr(:))));
     end
     
     if numel(igstr)>0 % couldnt combine them
         warning("ZAIN: some elements in GDS_Merge could not be merged !")
     end
     ogstr = {ogstr igstr};
end