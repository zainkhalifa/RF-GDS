function [ogelm] = GDS_Create_Octagonal(d_side, center, max45)
% GDS_Create_Octagonal will create an Octagonal gds_element with 
% inputs:   d_side is the side distance in dbunits
%           center = [xo yo] which is the center 
%           max45 is something >_>
%
% Author : Zainulabideen Khalifa            Last Revision : 09/02/2020
%
% function [ogelm] = GDS_Create_Octagonal(d_side, center, max45)

    minGrid = 10/1000;
if max45 == 0
    a = d_side/(2+sqrt(2));
    f = sqrt(2)/2;
    Octa = [f     -(1+f);...
            (1+f) -f    ;...
            (1+f)  f    ;...
            f      (1+f);...
            -f      (1+f);...
            -(1+f)  f    ;...
            -(1+f) -f    ;...
            -f     -(1+f);...
            f     -(1+f)];
   Octa = Octa.*a + center.*ones(length(Octa(:,1)),2);

else
   a = max45/sqrt(2);
   b = d_side-2*a;
    Octa = [b/2     -(b/2+a);...
            (b/2+a) -b/2    ;...
            (b/2+a) b/2     ;...
            b/2     (b/2+a) ;...
            -b/2     (b/2+a) ;...
            -(b/2+a) b/2     ;...
            -(b/2+a) -b/2    ;...
            -b/2     -(b/2+a);...
            b/2     -(b/2+a)];  
    Octa = Octa + center.*ones(length(Octa(:,1)),2);
end
    Octa = round(Octa./minGrid).*minGrid;

    ogelm = gds_element('boundary','xy',Octa);
end