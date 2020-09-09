function [ogds] = GDS_reset(igds,info)
%GDS_reset will reset all gds_elements in the input to a given layer and 
% dtype. The input can be a gds_element, gds_structure or cells of 
% gds_structures. The output should be in the same class as the input. 
% info is a structure with info.layer and info.dtype
% 
% Author : Zainulabideen Khalifa            Last Revision : 09/06/2020
%
% function [ogds] = GDS_reset(igds,info)
  
    if strcmp(class(igds),'gds_element')
        XY = cell2mat(xy(igds));
        ogds = gds_element('boundary','xy',XY,'layer',info.layer,'dtype',info.dtype);
    elseif strcmp(class(igds),'gds_structure')
    % create gds structure with the same name as the input structure    
        ogds = gds_structure(get(igds,'sname'));

        for e_idx = 1:length(igds(:))
            XY = cell2mat(xy(igds(e_idx)));
            ogds(1+end) = gds_element('boundary','xy',XY,'layer',info.layer,'dtype',info.dtype);
        end
    elseif iscell(igds)
        ogds = {};
        for c_idx = 1:length(igds(:))
            igstr = igds{c_idx};
            ogstr = gds_structure(get(igstr,'sname'));

            for e_idx = 1:length(igstr(:))
                XY = cell2mat(xy(igstr(e_idx)));
                ogstr(1+end) = gds_element('boundary','xy',XY,'layer',info.layer,'dtype',info.dtype);
            end 
            ogds(1+end) = {ogstr};
        end
    else
        error('ZAIN: Input must be cell, gds_structure or gds_element !')
    end
end







