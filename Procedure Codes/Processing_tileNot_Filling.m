
clear all
close all
clc

location = 'IN_OUT/';
glib_filename = 'HRO_tileNOT_HFSS';
output_filename = 'HRO_tileNOT_CAD';
Cell_name = 'HRO_tileNOT';
% glib_filename = 'GSG_Pad_tileNOT_HFSS';
% output_filename = 'GSG_Pad_tileNOT_CAD';
% Cell_name = 'GSG_Pad_tileNOT';

[in_glib] = read_gds_library(strcat(location,glib_filename,'.gds'));

tileNOT = get(in_glib,'st');
tileNOT = tileNOT{1};
uunit  = get(in_glib,'uunit' );
dbunit = get(in_glib,'dbunit');
units = uunit/dbunit;
gdsii_units(uunit, dbunit);

%% Create the output gds library 
Output_glib = gds_library('z_MATLAB','uunit',uunit, 'dbunit',dbunit);

%% Select your gds element

figure,GDS_plot(tileNOT,'-')

%% Discretize to the needed grid > minGrid(for M8) and > minWidth for the rest
DSt = GDS_Discretize_gstr(tileNOT,400,units);

%% here you have to choose the splitting so that it produces less than 8000 vertices
Splited_St = GDS_Split_gstr(DSt,10,units);

%% Copy the the_diffring_mask to the required layers in CAD

ogstr = GDS_ST55_Generate_tileNot(Splited_St);

% Store the layers in the Output_glib
[Output_glib] = add_struct(Output_glib,ogstr);

%% rename all structures so that we dont get importing error in CAD
[Output_glib] = GDS_auto_rename_glib(Output_glib,Cell_name);

%% Export the library as a gds file
write_gds_library(Output_glib, strcat(location,output_filename,'.gds'));
%%
    
