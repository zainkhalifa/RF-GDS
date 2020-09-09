function [ogstr] = GDS_MATH(ig1,ig2,operation,units)
% GDS_MATH will apply an operation on the gds_elements/gds_structure
% in the inputs. The inputs can be gds_structure, cells of gds_structures 
% or gds_elements. The operations are 'and', 'or', 'xor' or 'diff' , 'notb'
% Warning: GDS_MATH will lose your layer and dtype info.
%
% Author : Zainulabideen Khalifa            Last Revision : 09/01/2020
%
% function [ogstr] = GDS_MATH(ig1,ig2,operation,units)

%     fprintf("\nRunning GDS_MATH...\n");    t = cputime;
    ogstr = gds_structure('MATLAB');
    % convert all inputs to structures cells
    igstr1 = {gds_structure('MATLAB')};
    igstr2 = {gds_structure('MATLAB')};
    if ~iscell(ig1)
        if strcmp(class(ig1),'gds_element')
            igstr1{1}(1) = ig1;
        elseif strcmp(class(ig1),'gds_structure')
            igstr1{1} = ig1;
        end
    else
        igstr1 = ig1;
    end
    if ~iscell(ig2)
        if strcmp(class(ig2),'gds_element')
            igstr2{1}(1) = ig2;
        elseif strcmp(class(ig2),'gds_structure')
            igstr2{1} = ig2;
        end
    else
        igstr2 = ig2;
    end
        clear ig1;
        clear ig2;
    % sweep the operation for every element and store everything in ogstr
    for cidx1 = 1:length(igstr1(:))
        ig1 = igstr1{cidx1};
    for cidx2 = 1:length(igstr2(:))
        ig2 = igstr2{cidx2};
        for  eidx1 = 1:length(ig1(:))
        for  eidx2 = 1:length(ig2(:))
            [pc,hf] = poly_boolmex(xy(ig1(eidx1)),xy(ig2(eidx2)),operation,units);
            for idx = 1:length(pc) % fill the output gelm in one gstr
                XY = cell2mat(pc(idx));
                XY(end+1,:) = XY(1,:);
                ogstr(1+end) = gds_element('boundary','xy',XY);
            end
            if any(hf)
                warning('ZAIN: Hole created !!\n')
            end
        end
        end
    end
    end

%     fprintf("GDS_MATH: Elapsed time = %0.2f s\n",(cputime-t));
end
