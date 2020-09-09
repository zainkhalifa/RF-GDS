clear all 
clc
close all

units = 1000;
gstr = gds_structure('Example');
gstr(1+end) = GDS_Create_box([10 10], [10 25]);
XY = [  5 5;...
        30 5;...
        30 30;...
        20 30;...
        20 15;...
        5 15;...
        5 5];
gstr(1+end) = gds_element('boundary','xy',XY);
gstr = GDS_Shift(gstr,[50 0]);

XY = [  50 50;...
        100 25;...
        150 50;...
        125 75;...
        50 50]+0.01;

gstr(1+end) = gds_element('boundary','xy',XY);
gstr(1+end) = GDS_Create_Octagonal(20, [130 20], 0)
GDS_plot(gstr,'-o'), grid on, axis equal
xlim([40 150])
xticks([40:10:150])
%% ---------------------------------------------------
DSt = GDS_Discretize_gstr(gstr,1000,units);
figure
GDS_plot(DSt,'-'), grid on, axis equal
xlim([40 150])
xticks([40:10:150])
%% ---------------------------------------------------
WSt = GDS_minWidth_gstr(DSt,10000,1000,10,units);
figure
GDS_plot(WSt,'-'), grid on, axis equal
xlim([40 150])
xticks([40:10:150])













