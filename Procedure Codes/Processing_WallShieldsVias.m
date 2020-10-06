% This code generates the layout for the vias in the solid shiledings using 
% the normal shield mask from HFSS without the need for the inner shield
% mask. it takes few minutes.
%

clear all
close all
clc

location = 'IN_OUT/';
glib1_filename = 'HRO2_Lt0_Walls_HFSS';
glib3_filename = 'HRO2_Lt0_Box_HFSS';

output_filename = 'HRO2_Lt0_WallsVias_CAD';
Cell_name = 'HRO2_Lt0_WallsVias';

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
bbox_via = GDS_Create_box([5 5],[0 0]);

%%
figure
GDS_plot(in_gstr,'-'),hold on
GDS_plot(bbox_via,'-'),hold on
GDS_plot(bbox_gstr,'-'),hold on

%% replace all vias with spacial enclosure boxes that overlaps 1.6x1.6
X = [-2:2]'*ones(1,5);

center = [];
viaEN_gstr = gds_structure('MATLAB');
EN_box = GDS_Create_box([1.6 1.6],[0,0]);
for x_idx = 1:length(X)
    for y_idx = 1:length(X)
        center(1+end,:) = [X(x_idx) X(y_idx)];
        viaEN_gstr(1+end) = GDS_Shift(EN_box,[X(x_idx) X(y_idx)]);
    end
end
plot(center(:,1),center(:,2),'x'),hold on
GDS_plot(viaEN_gstr,'-'),hold on

%% using variation to GDS_Mosaic_imprint
igstr = in_gstr;
bbox_block = bbox(bbox_via);

output_viaEN = GDS_Mosaic_imprint(viaEN_gstr,bbox_block,in_gstr,bbox_gstr,units);
output_viaEN = GDS_checkvias(output_viaEN,[1.6 1.6]);
Doutput_viaEN = GDS_Discretize_gstr(output_viaEN,20,units);

str = {"VIAz_box" "VIA6_layer"};
info = GDS_ST55(str{1});
via6_gelm = GDS_Create_box(info.b*[1 1],[0 0]);

str = {"VIAu_box" "VIA7_layer"};
info = GDS_ST55(str{1});
via7_gelm = GDS_Create_box(info.b*[1 1],[0 0]);
%%

output_via6_gstr = gds_structure('MATLAB');
output_via7_gstr = gds_structure('MATLAB');

for idx = 1:length(Doutput_viaEN(:))
    output_via6_gstr(1+end) = 0;
    output_via7_gstr(1+end) = 0;    
end
for idx = 1:length(Doutput_viaEN(:))
    fprintf("Processing %0.2f\n",100*idx/length(Doutput_viaEN(:)))
    box = bbox(Doutput_viaEN(idx));
    center = [mean([box(1) box(3)])  mean([box(2) box(4)])];
    output_via6_gstr(idx) = GDS_Shift(via6_gelm,center);
    output_via7_gstr(idx) = GDS_Shift(via7_gelm,center);
end


figure
GDS_plot(output_via6_gstr,'r-'), hold on
GDS_plot(output_via7_gstr,'b-'), hold on
GDS_plot(in_gstr,'k-')

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

   