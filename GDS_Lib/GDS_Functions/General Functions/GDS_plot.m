function GDS_plot(igds,str)
% GDS_plot will plot all elements given in the input parameter. The input
% can be a cell array of gds_structures, a gds_structure or a gds_element.
% The line type in the plot can be assigned in the input 'str' similar to
% the MATLAB command plot. 
% 
%
% Author : Zainulabideen Khalifa            Last Revision : 09/02/2020
%
% function GDS_plot(igds,str)

    if strcmp(class(igds),'gds_element')
        igstr = gds_structure('MATLAB');
        igstr(1) = igds;
        igc(1) = {igstr};
    elseif strcmp(class(igds),'gds_structure')
        igc(1) = {igds};
    elseif iscell(igds)
        igc = igds;
    else
        error('ZAIN: Input to GDS_plot must be cell, gds_structure or gds_element !')
    end

    hold on
    for c_idx = 1:length(igc(:))
        gstr = igc{c_idx};
        for s_idx = 1:length(gstr(:))
            gelm = gstr(s_idx);
            if is_etype(gelm,'boundary')
                for e_idx = 1:length(gelm(:))
                    XY = gelm(e_idx);
                    plot(XY(:,1),XY(:,2),str)
                end
            else
                warning('ZAIN: Some elements are not boundry type.')
            end
        end
    end
    hold off
    axis equal
end


















