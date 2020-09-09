function [ogstr] = GDS_Mosaic(igds,Mosaic,RC,Center)
% GDS_Mosaic will create a Mosaic of the input igds which can be 
% gds_structure or a gds_element. The parameter Mosaic contains
% Mosaic.b (for box dimentions), Mosaic.d (for separation between
% elements) and Mosaic.e (for edge separation). RC is the number of rows
% and cols RC = [rows cols]. Center is the shift from the origion by 
% [xo yo]. The output is a cell of gds_structures with each element of the
% Mosaic as a cell. 
% 
% Example:
%     Mosaic.b = [5 5];
%     Mosaic.d = [0 0];
%     Mosaic.e = [0 0];
% 
%     block_gelm = GDS_Create_box(Mosaic.b,[0 0]);
%     [RC,Center] = GDS_Mosaic_calc(DSt(1),Mosaic);
%     Mosaic_gstr = GDS_Mosaic(block_gelm,Mosaic,RC,Center);
%
% Author : Zainulabideen Khalifa            Last Revision : 09/01/2020
%
% function [ogstr] = GDS_Mosaic(igds,Mosaic,RC,Center)

    fprintf("Running GDS_Mosaic...");

    if strcmp(class(igds),'gds_element')
        igstr = gds_structure('MATLAB');
        igstr(1) = igds;
        igc(1) = {igstr};
    elseif strcmp(class(igds),'gds_structure')
        igc(1) = {igds};
    elseif iscell(igds)
        igc = igds;
    else
        error('ZAIN: Input must be cell, gds_structure or gds_element !')
    end

    ogstr = {};
    rows = RC(1); cols = RC(2);
    for r_idx = 1:rows
    for c_idx = 1:cols
       gstr = gds_structure('Mosaic');
       for cell_idx = 1:length(igc(:))
            igstr = igc{cell_idx};
            box = bbox(igstr);
            for s_idx = 1:length(igstr(:))
                gelm = igstr(s_idx);
                if is_etype(gelm,'boundary')
                    for e_idx = 1:length(gelm(:))
                        layer = gelm.layer;
                        dtype = gelm.dtype;

                        XY = gelm(e_idx);
                        % centering XY around (0.0)
                        XY_dxy = abs([box(1)-box(3) box(2)-box(4)]./2);
                        d = Mosaic.d + 2*XY_dxy;
                        d_edge = Mosaic.e + XY_dxy;
                        dx = d(1); dy = d(2);
                        dx_edge = d_edge(1); dy_edge = d_edge(2);
                        shift = [dx_edge+(c_idx-1)*dx dy_edge+(r_idx-1)*dy].*ones(size(XY));
                        shift = shift + Center.*ones(size(XY));
                        gstr(1+end) = gds_element('boundary','xy',XY + shift  ,'layer',layer,'dtype',dtype);                      

                    end
                else
                    warning('ZAIN: Some elements are not boundry type.')
                end
            end
        end
        ogstr(1+end) = {gstr};
    end
    end  
    
    fprintf("DONE!\n");
end

