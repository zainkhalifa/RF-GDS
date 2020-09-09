function [ogelm] = GDS_Create_box(d,c)
% GDS_Create_Box will create a rectangle gds_element with 
% inputs:   d = [dx dy] where dx and dy are in dbunits
%           c = [xo yo] which is the center 
%
% Author : Zainulabideen Khalifa            Last Revision : 09/02/2020
%
% function [gelm] = GDS_Create_box(d,c)

    xo = c(1);
    yo = c(2);
    dx = d(1);
    dy = d(2);
    XY = [dx/2 dy/2;...
        -dx/2 dy/2;...
        -dx/2 -dy/2;...
        dx/2 -dy/2;...
        dx/2 dy/2];
    XY = XY + [xo yo].*ones(5,2); 
    ogelm = gds_element('boundary','xy',XY);
end
