function [ogds] = GDS_checkvias(igds,d)
% GDS_checkvias will remove the boxes that isnt with the dimension
% specified by d = [dx dy] and wil maintain the rest as they are. The input
%  can be a gds_element, gds_structure or cells of gds_structures. 
%
% Author : Zainulabideen Khalifa            Last Revision : 09/06/2020
%
% function [ogds] = GDS_checkvias(igds,d)

fprintf("\nRunning GDS_checkvias...\n")
t=cputime;

    ogds = [];
    if strcmp(class(igds),'gds_element')
        XY = cell2mat(xy(igds));
        % check if it is a box with all sides = d, keep
        if round(abs(nonzeros(diff(XY))).*1000)./1000  == d   
           ogds = igds;
        end
    elseif strcmp(class(igds),'gds_structure')
    % create gds structure with the same name as the input structure    
        ogds = gds_structure(get(igds,'sname'));

        for e_idx = 1:length(igds(:))
            XY = cell2mat(xy(igds(e_idx)));
            % check if it is a box with all sides = d, keep
            if round(abs(nonzeros(diff(XY))).*1000)./1000  == d   
               ogds(1+end) = igds(e_idx);
            end
        end
    elseif iscell(igds)
        ogds = {};
        for c_idx = 1:length(igds(:))
            igstr = igds{c_idx};
            ogstr = gds_structure(get(igstr,'sname'));
            
            for e_idx = 1:length(igstr(:))
                XY = cell2mat(xy(igstr(e_idx)));
                % check if it is a box with all sides = d, keep
                if round(abs(nonzeros(diff(XY))).*1000)./1000  == d   
                   ogstr(1+end) = igstr(e_idx);
                end
            end 
            ogds(1+end) = {ogstr};
        end
    else
        error('ZAIN: Input must be cell, gds_structure or gds_element !')
    end
fprintf("Time elapsed = %0.2f s\nDONE!\n",cputime-t)


end