% This code generates the layout for via 5 in the solid shieldings using 
% the inner shield mask from HFSS to have clearance for the vias away from 
% the edges (DRC) and a bbox mask and the mask of via fillings on layer 5
%

clear all
close all
clc

location = 'IN_OUT/';
Walls_filename = 'HRO2_Lt0_Walls_HFSS';
mask_filename = 'z_FloorShieldVias5_mask_5x5'; % This is tricky 
box_filename = 'HRO2_Lt0_Box_HFSS';   
% use bbox form HFSS to have the same reference for the blocks

output_filename = 'HRO2_Lt0_Shieldsvia5_CAD';
Cell_name = 'HRO2_Lt0_Shieldsvia5';

[walls_glib] = read_gds_library(strcat(location,Walls_filename,'.gds'));
[block_glib] = read_gds_library(strcat(location,mask_filename,'.gds'));
[bbox_glib] = read_gds_library(strcat(location,box_filename,'.gds'));

uunit  = get(walls_glib,'uunit' );
dbunit = get(walls_glib,'dbunit');
units = uunit/dbunit;
gdsii_units(uunit, dbunit);

%% Create the output gds library 
Output_glib = gds_library('z_MATLAB','uunit',uunit, 'dbunit',dbunit);

%% Discretize to the needed grid > minGrid(for M8) and > minWidth for the rest
in_gstr = GDS_Discretize_gstr(walls_glib(1),100,units);

bbox_gstr = bbox_glib(1); 
block_gstr = block_glib(1);
viaEN_gstr = gds_structure('MATLAB');
block_vias = gds_structure('MATLAB');
for idx=1:length(block_gstr(:))
    if(layer(block_gstr(idx)) == 35)
        viaEN_gstr(1+end) = block_gstr(idx);
    else
        block_vias(1+end) = block_gstr(idx);
    end
end

%%
figure
GDS_plot(in_gstr,'-'),hold on
GDS_plot(block_gstr,'-'),hold on
GDS_plot(bbox_gstr,'-'),hold on
%%

bbox_block = bbox(GDS_Create_box([5 5],[0 0]));
output_viaEN = GDS_Mosaic_imprint(viaEN_gstr,bbox_block,in_gstr,bbox_gstr,units);
output_viaEN = GDS_checkvias(output_viaEN,[1.16 1.16]);
Doutput_viaEN = GDS_Discretize_gstr(output_viaEN,20,units);

str = {"VIAz_box" "VIA5_layer"};
info = GDS_ST55(str{1});
via5_gelm = GDS_Create_box(info.b*[1 1],[0 0]);


output_via5_gstr = gds_structure('MATLAB');

for idx = 1:length(Doutput_viaEN(:))
    fprintf("Processing %0.2f\n",100*idx/length(Doutput_viaEN(:)))
    box = bbox(Doutput_viaEN(idx));
    center = [mean([box(1) box(3)])  mean([box(2) box(4)])];
    output_via5_gstr(1+end) = GDS_Create_box(info.b*[1 1],center);
end

figure
GDS_plot(output_via5_gstr,'r-'), hold on
GDS_plot(in_gstr,'k-')

%%

clear ogstr
ogstr = {};

ogstr(1+end) = GDS_reset({output_via5_gstr},GDS_ST55("VIA5_layer"));

% Store the layers in the Output_glib
[Output_glib] = add_struct(Output_glib,ogstr);
fprintf("Done reseting layers.\n");
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


 