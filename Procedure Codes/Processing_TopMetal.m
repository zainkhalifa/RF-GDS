clear all
close all
clc

location = 'IN_OUT/';
glib_filename = 'HRO2_Lt0_M8_HFSS';
output_filename = 'HRO2_Lt0_M8_CAD';
Cell_name = 'HRO2_Lt0_M8';

[in_glib] = read_gds_library(strcat(location,glib_filename,'.gds'));

St = get(in_glib,'st');
St = St{1};
uunit  = get(in_glib,'uunit' );
dbunit = get(in_glib,'dbunit');
units = uunit/dbunit;

% Create the output gds library 
Output_glib = gds_library('z_MATLAB','uunit',uunit, 'dbunit',dbunit);

%% Plot the structure to make sure you are on the right path
figure,GDS_plot(in_glib(1),'-')

%% Discretize to the needed grid > minGrid(for M8) and the correct for minWidth
% GDS_minWidth_gstr does blind correct for miWidth so it needs to be called
% more than once !
DSt = GDS_Discretize_gstr(St,20,units);
WSt = GDS_minWidth_gstr(DSt,600,20,2000,units);
WSt = GDS_minWidth_gstr(WSt,600,20,2000,units);
WSt = GDS_minWidth_gstr(WSt,600,20,2000,units);

figure,GDS_plot(WSt,'-')

%% here you have to choose the splitting so that it produces less than 8000 vertices
Splited_St = GDS_Split_gstr(WSt,10,units);
figure,GDS_plot(Splited_St,'-')

%% Copy the the_diffring_mask to the required layers in CAD
clear ogstr
ogstr = {};
ogstr(1+end) = {GDS_reset(Splited_St,GDS_ST55("M8_layer"))};

% Store the layers in the Output_glib
[Output_glib] = add_struct(Output_glib,ogstr);

%% rename all structures so that we dont get importing error in CAD
[Output_glib] = GDS_auto_rename_glib(Output_glib,Cell_name);

lol = gds_structure(convertStringsToChars(Cell_name));
for idx = 1:length(Output_glib(:))
    lol = add_ref(lol,Output_glib(idx));
end
[Output_glib] = add_struct(Output_glib,lol);

%% Export the library as a gds file
write_gds_library(Output_glib, strcat(location,output_filename,'.gds'));
%%
 