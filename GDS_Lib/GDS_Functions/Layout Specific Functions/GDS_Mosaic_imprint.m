function [ogstr] = GDS_Mosaic_imprint(block_gstr,bbox_block,igstr,bbox_gstr,units)
% GDS_Mosaic_imprint will find the imprint of the block in a mosiac filling
% the bbox on the input igstr. It will do that by creating a mosaic of the 
% block filling the bbox then find the intersections between the mosiac and
% the input gstr. It will return the intersection part of the mosiac. 
% This is useful to fill vias in the shielding walls while maintaining a
% reference point using the bbox structure. 
% Get bbox_block = bbox(block_gstr); so that it is the same for metals and
% vias to have the same reference.
%
% Author : Zainulabideen Khalifa            Last Revision : 09/08/2020
%
% function [ogstr] = GDS_Mosaic_imprint(block_gstr,bbox_block,igstr,bbox_gstr,units)

    fprintf("Running GDS_Mosaic_imprint...\n");
    if iscell(block_gstr) && length(block_gstr(:))==1
        block_gstr = GDS_combine_gstrcells(block_gstr);
    end

% Create Mosaic of the block to find intersections later
    Mosaic.b = abs([bbox_block(3)-bbox_block(1) bbox_block(4)-bbox_block(2)]);
    Mosaic.d = [0 0];
    Mosaic.e = [0 0];
    block_gelm = GDS_Create_box(Mosaic.b,[0 0]);
    [RC,Center] = GDS_Mosaic_calc(bbox_gstr(1),Mosaic);
    Mosaic_dummy = GDS_Mosaic(block_gelm,Mosaic,RC,Center);
    
% find the blocks that intersects with the shield mask then replace it with
% the basic block. This step is just to save processing time incase there
% are too many gelm in Mosaic
    inter_Mosaic_dummy = GDS_Mosaic_intersections(igstr,Mosaic_dummy,units);
    inter_Mosaic_dummy = GDS_Discretize_gstr(inter_Mosaic_dummy{1},2500,units);
    
% replace elements of inter_Mosaic_dummy with block_gstr
    inter_block_gstr = {};
    for idx = 1:length(inter_Mosaic_dummy(:))
        box = bbox(inter_Mosaic_dummy(idx));
        center = [mean([box(1) box(3)])  mean([box(2) box(4)])];
        inter_block_gstr(1+end) = {GDS_Shift(block_gstr,center)};
    end

% This will find the imprints of block_gstr on igstr 
    ogstr = GDS_MATH(inter_block_gstr,igstr,'and',units);

    fprintf("DONE!\n");
end











