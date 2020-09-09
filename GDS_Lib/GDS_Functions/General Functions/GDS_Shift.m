function [ogds] = GDS_Shift(igds,shift)
%GDS_Shift will make a shift to the input by shift = [x y]. The input can
%be a gds_element, gds_structure or cells of gds_structures. The output
%should be in the same class as the input. 
%
% Author : Zainulabideen Khalifa            Last Revision : 09/03/2020
%
% function [ogds] = GDS_Shift(igds,shift)

%     fprintf("Running GDS_Shift...");
    
    if strcmp(class(igds),'gds_element')
        L = igds.layer;
        D = igds.dtype;
        el_size = size(cell2mat(xy(igds)));
        XY = cell2mat(xy(igds)) + shift.*ones(el_size);
        ogds = gds_element('boundary','xy',XY,'layer',L,'dtype',D);
    elseif strcmp(class(igds),'gds_structure')
    % create gds structure with the same name as the input structure    
        ogds = gds_structure(get(igds,'sname'));

        for e_idx = 1:length(igds(:))
        % get the layers of all elements in the input structure     
            L = igds(e_idx).layer;
            D = igds(e_idx).dtype;
            el_size = size(cell2mat(xy(igds(e_idx))));
            XY = cell2mat(xy(igds(e_idx))) + shift.*ones(el_size);
            ogds(1+end) = gds_element('boundary','xy',XY,'layer',L,'dtype',D);
        end
    elseif iscell(igds)
        ogds = {};
        for c_idx = 1:length(igds(:))
            igstr = igds{c_idx};
            ogstr = gds_structure(get(igstr,'sname'));

            for e_idx = 1:length(igstr(:))
            % get the layers of all elements in the input structure     
                L = igstr(e_idx).layer;
                D = igstr(e_idx).dtype;
                el_size = size(cell2mat(xy(igstr(e_idx))));
                XY = cell2mat(xy(igstr(e_idx))) + shift.*ones(el_size);
                ogstr(1+end) = gds_element('boundary','xy',XY,'layer',L,'dtype',D);
            end 
            ogds(1+end) = {ogstr};
        end
    else
        error('ZAIN: Input must be cell, gds_structure or gds_element !')
    end

%     fprintf("DONE!\n")
end




















