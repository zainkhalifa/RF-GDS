% This code generates the layout for the vias in the solid shiledings using 
% the inner shield mask from HFSS to have clearance for the vias away from 
% the edges (DRC)
%

clear all
close all
clc

location = 'IN_OUT/';
glib1_filename = 'HRO_InnerShields_HFSS';
glib3_filename = 'HRO_bbox_HFSS';   

output_filename = 'HRO_Shields_CAD';
Cell_name = 'HRO_Shields';

[in_glib] = read_gds_library(strcat(location,glib1_filename,'.gds'));
[bbox_glib] = read_gds_library(strcat(location,glib3_filename,'.gds'));

uunit  = get(in_glib,'uunit' );
dbunit = get(in_glib,'dbunit');
units = uunit/dbunit;
gdsii_units(uunit, dbunit);


%% Create the output gds library 
Output_glib = gds_library('z_MATLAB','uunit',uunit, 'dbunit',dbunit);

%% Discretize to the needed grid > minGrid(for M8) and > minWidth for the rest
in_gstr = GDS_Discretize_gstr(in_glib(1),100,units);
bbox_gstr = bbox_glib(1);

%% This can be done in Cadence. here I am making the simple via block
str = {"VIAz_box" "VIA6_layer"};
Mosaic = GDS_ST55(str{1});
Mosaic.b = Mosaic.b*[1 1];
Mosaic.d = 1-Mosaic.b;
Mosaic.e = Mosaic.d/2;
via_box = GDS_Create_box(Mosaic.b,[0 0]);
block_bbox = GDS_Create_box([5 5],[0 0]);
[RC,Center] = GDS_Mosaic_calc(block_bbox,Mosaic);
via6_block =  GDS_Mosaic(via_box,Mosaic,RC,Center);
via6_block = GDS_combine_gstrcells(via6_block);

str = {"VIAu_box" "VIA7_layer"};
Mosaic = GDS_ST55(str{1});
Mosaic.b = Mosaic.b*[1 1];
Mosaic.d = 1-Mosaic.b;
Mosaic.e = Mosaic.d/2;
via_box = GDS_Create_box(Mosaic.b,[0 0]);
block_bbox = GDS_Create_box([5 5],[0 0]);
[RC,Center] = GDS_Mosaic_calc(block_bbox,Mosaic);
via7_block =  GDS_Mosaic(via_box,Mosaic,RC,Center);
via7_block = GDS_combine_gstrcells(via7_block);

%%
figure
GDS_plot(in_gstr,'-'),hold on
GDS_plot(via6_block,'-'),hold on
GDS_plot(via7_block,'-'),hold on
GDS_plot(block_bbox,'-'),hold on

GDS_plot(bbox_gstr,'-'),hold on
%%
bbox_block = bbox(block_bbox);
output_via6_gstr = GDS_Mosaic_imprint(via6_block,bbox_block,in_gstr,bbox_gstr,units);
output_via7_gstr = GDS_Mosaic_imprint(via7_block,bbox_block,in_gstr,bbox_gstr,units);

str = {"VIAz_box" "VIA6_layer"};
info = GDS_ST55(str{1});
output_via6_gstr = GDS_checkvias(output_via6_gstr,info.b);
str = {"VIAu_box" "VIA7_layer"};
info = GDS_ST55(str{1});
output_via7_gstr = GDS_checkvias(output_via7_gstr,info.b);

output_via6_gstr = GDS_Discretize_gstr(output_via6_gstr,20,units);
output_via7_gstr = GDS_Discretize_gstr(output_via7_gstr,20,units);

figure
GDS_plot(output_via6_gstr,'-')

%%
clear ogstr
ogstr = {};
ogstr(1+end) = {GDS_reset(output_via6_gstr,GDS_ST55("VIA6_layer"))};
ogstr(1+end) = {GDS_reset(output_via7_gstr,GDS_ST55("VIA7_layer"))};

[Output_glib] = add_struct(Output_glib,ogstr);

%% rename all structures so that we dont get importing error in CAD
[Output_glib] = GDS_auto_rename_glib(Output_glib,Cell_name);

%% add reference to all elements
lol = gds_structure(convertStringsToChars(Cell_name));
for idx = 1:length(Output_glib(:))
    lol = add_ref(lol,Output_glib(idx));
end
[Output_glib] = add_struct(Output_glib,lol);
%% Export the library as a gds file
write_gds_library(Output_glib, strcat(location,output_filename,'.gds'));
%%

   