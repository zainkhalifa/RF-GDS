function [RC,Center] = GDS_Mosaic_calc(igstr,Mosaic)
% GDS_Mosaic_calc will calculate how many rows and columns are needed to
% fill the bbox of igstr using a basic Mosaic element described in Mosiac.
% Mosaic input must has three data as follows:
%     Mosaic.b = [dx dy];   That is the distance in x and y
%     Mosaic.d = [separation_x separation_y];
%     Mosaic.e = [edge_x edge_y];   distance from the edges
% The function will return the center point of the igstr. 
% RC will be as[rows cols]
%
% This function is often used with GDS_Mosaic
% Author : Zainulabideen Khalifa            Last Revision : 09/01/2020
%
% function [RC,Center] = GDS_Mosaic_calc(igstr,Mosaic)

    box = bbox(igstr);

    % figuring out the # of rows and cols to fill the whole igelm
    dxy = [abs(box(3)-box(1)) abs(box(4)-box(2))];
    RC(2) = ceil((dxy(1) - Mosaic.e(1))/(Mosaic.b(1)+Mosaic.d(1)));
    RC(1) = ceil((dxy(2) - Mosaic.e(2))/(Mosaic.b(2)+Mosaic.d(2)));
    Center = [box(1) box(2)];
end
