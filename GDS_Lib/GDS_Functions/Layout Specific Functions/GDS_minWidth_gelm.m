function [ogelm]    = GDS_minWidth_gelm(igelm,minWidth,minGrid,SmallestWireWidth,units)
% Author : Zainulabideen Khalifa            Last Revision : 05/02/2020

L = layer(igelm);

XY = igelm(1);
[XY,c(1)] = minWidth_corr(XY,minWidth,minGrid,SmallestWireWidth,units);

XY = flip(XY);
[XY,c(2)] = minWidth_corr(XY,minWidth,minGrid,SmallestWireWidth,units);
XY = flip(XY);

ogelm = gds_element('boundary', 'xy',XY,'layer',L);

fprintf("Total number of corrections = %0.0f\n",sum(c))
fprintf("DONE!\n")
end

