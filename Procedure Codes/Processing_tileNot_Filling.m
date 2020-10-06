
clear all
close all
clc

location = 'IN_OUT/';
glib_filename = 'HRO2_Lt0_tileNOT_HFSS';
output_filename = 'HRO2_Lt0_tileNOT_CAD';
Cell_name = 'HRO2_Lt0_tileNOT';
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
    
%% 
function [ogstr] = GDS_create_via_gstr(shrinked_gstr,str,units)
    info = GDS_ST55(str{1});
    Mosaic.b = [info.b info.b];
    Mosaic.d = [info.d info.d];
    Mosaic.e = [0 0];
    info = GDS_ST55(str{2});
    VIAs_gstr = GDS_fill_vias(shrinked_gstr,Mosaic,info.layer,Mosaic.d./4,units);

    % check the vias to delete bad vias from the AND operation in fill_vias
    info = GDS_ST55(str{1});
    VIAs_gstr_checked = GDS_checkvias(VIAs_gstr,info.b);
    ogstr = GDS_reset_gstr(VIAs_gstr_checked,GDS_ST55(str{2}));

end
function [ogelm] = GDS_create_gridblock(type,shift)
    switch type
        case 1
        XY = [5.0000    5.0000;...
            4.2000    5.0000;...
            4.2000    0.8000;...
            0.8000    0.8000;...
            0.8000    4.2000;...
            4.2000    4.2000;...
            4.2000    5.0000;...
                 0    5.0000;...
                 0         0;...
            5.0000         0;...
            5.0000    5.0000];
        XY = XY + shift.*ones(length(XY(:,1)),2);
        ogelm = gds_element('boundary','xy',XY);
        case 2
        XY = [5.0000    3.3000;...
            3.3000    3.3000;...
            3.3000    5.0000;...
            1.7000    5.0000;...
            1.7000    3.3000;...
                 0    3.3000;...
                 0    1.7000;...
            1.7000    1.7000;...
            1.7000         0;...
            3.3000         0;...
            3.3000    1.7000;...
            5.0000    1.7000;...
            5.0000    3.3000];
        XY = XY + shift.*ones(length(XY(:,1)),2);
        ogelm = gds_element('boundary','xy',XY);
        otherwise
            error("ZAIN: GDS_create_grid, type is unknown")
    end
end
function [ogstr] = generate_edge_grid(igelm,units)

    Mosaic.b = [5 5];
    Mosaic.d = [0 0];
    Mosaic.e = [0 0];

    box_gelm = GDS_create_gridblock(1,[-2.5 -2.5]);
    [RC,Center] = GDS_Mosaic_calc(igelm,Mosaic);
    gstr = GDS_Mosaic_gelm(box_gelm,[0 0],Mosaic.d,RC);
    Mos_gstr1 = GDS_shift_gstr(gstr,Center);

    box_gelm = GDS_create_gridblock(2,[-2.5 -2.5]);
    [RC,Center] = GDS_Mosaic_calc(igelm,Mosaic);
    gstr = GDS_Mosaic_gelm(box_gelm,[0 0],Mosaic.d,RC);
    Mos_gstr2 = GDS_shift_gstr(gstr,Center);


    GDS_plot_gstr(Mos_gstr1,0,'k-'),hold on
    GDS_plot_gelm(igelm,'r-'),hold on
    %% produce a mask

    box = bbox(Mos_gstr1);
    c(1) = mean([box(1) box(3)]);
    c(2) = mean([box(2) box(4)]);
    d = abs([box(3)-box(1) box(4)-box(2)]) + [0.1 0];
    boxgelm = GDS_Create_box(d,c,1);

    [pc,hf] = poly_boolmex(xy(boxgelm),xy(igelm),'diff',units);
    ogstr = gds_structure('MATLAB');
    for idx = 1:length(pc)
        XY = cell2mat(pc(idx));
        XY(end+1,:) = XY(1,:);
        ogstr(1+end) = gds_element('boundary','xy',XY);
    end
    GDS_plot_gstr(ogstr,0,'-')
    % manually, now choose which is the inner structure and which is outer

    inner_maskgelm = ogstr(1);
    outer_maskgelm = ogstr(2);
    GDS_plot_gelm(inner_maskgelm,'b-'),hold on
    GDS_plot_gelm(outer_maskgelm,'r-'),hold on

    %%  Anding and Anding -- inner
    % take elmenet by element and do "and" with the igelm, keep any that gives output
    % and the mosiac witht the inner mask
    Mos_inner_gstr = GDS_find_intersections(inner_maskgelm,Mos_gstr1,units);
    % and the mosaic with the original layer
    Mos_inner_gstr_1 = GDS_find_intersections(igelm,Mos_inner_gstr,units);

    % do again for the other type
    % and the mosiac witht the inner mask
    Mos_inner_gstr = GDS_find_intersections(inner_maskgelm,Mos_gstr2,units);
    % and the mosaic with the original layer
    Mos_inner_gstr_2 = GDS_find_intersections(igelm,Mos_inner_gstr,units);
    
    figure
    GDS_plot_gstr(Mos_inner_gstr_1,0,'b-'),hold on
    GDS_plot_gstr(Mos_inner_gstr_2,0,'r-'),hold on
    GDS_plot_gelm(igelm,'k-')


    %%  Anding and Anding -- outer
    % take elmenet by element and do "and" with the igelm, keep any that gives output
    % and the mosiac witht the inner mask
    Mos_outer_gstr = GDS_find_intersections(outer_maskgelm,Mos_gstr1,units);
    % and the mosaic with the original layer
    Mos_outer_gstr_1 = GDS_find_intersections(igelm,Mos_outer_gstr,units);
    
    % do again for the other type
    % and the mosiac witht the inner mask
    Mos_outer_gstr = GDS_find_intersections(outer_maskgelm,Mos_gstr2,units);
    % and the mosaic with the original layer
    Mos_outer_gstr_2 = GDS_find_intersections(igelm,Mos_outer_gstr,units);

    figure
    GDS_plot_gstr(Mos_outer_gstr_1,0,'b-'),hold on
    GDS_plot_gstr(Mos_outer_gstr_2,0,'r-'),hold on
    GDS_plot_gelm(igelm,'k-')
    
    
        clear ogstr;
ogstr{1} =  Mos_inner_gstr_1;
ogstr{2} =  Mos_inner_gstr_2;
ogstr{3} =  Mos_outer_gstr_1;
ogstr{4} =  Mos_outer_gstr_2;
end
function [ogstr] = GDS_find_intersections(igelm,igstr,units)
% finds the elements in igstr that intersects with igelm and return those
% only in ogstr_in, the others are in ogstr_out

    ogstr_in = gds_structure('MATLAB');
    ogstr_out = gds_structure('MATLAB');
    for e_idx = 1:length(igstr(:))
        [pc,hf] = poly_boolmex(xy(igelm),xy(igstr(e_idx)),'and',units);
        if ~isempty(pc)        
            ogstr_in(1+end) = igstr(e_idx);
        else
            ogstr_out(1+end) = igstr(e_idx);
        end
    end
    ogstr = {ogstr_in ogstr_out};
end
% function [ogstr] = GDS_
% % --------------------------------NEW Functions--------------------------------
% function [ogstr] = GDS_ST55_Generate_tileNot(igstr);
% function [ogstr] = GDS_Merge(igstr,units)
% function [ogstr] = GDS_MATH(igelm1,igelm2,operation,units)
% function [ogelm] = GDS_Create_Octagonal(d_side, center, L)
% function [ogstr] = GDS_combine_gstr(igstr)
% function [gelm] = GDS_Create_box(d,c,L)
% function [gstr] = GDS_Mosaic_gelm(gelm,d_edge,d,RC)
% function [ogstr] = GDS_AND(gelm,igstr,layer,units)
% function [ogstr] = GDS_diff(gelm,igstr,layer,units)
% function [RC,Center] = GDS_Mosaic_calc(igelm,Mosaic)
% function [ogstr] = GDS_shift_gstr(igstr,shift)
% function [ogelm] = GDS_shift_gelm(igelm,shift)
% function [ogstr] = GDS_fill_vias(igstr,Mosaic,layer,seperation,units)
% function [ogelm] = GDS_reset_gelm(igelm,info)
% function [ogstr] = GDS_reset_gstr(igstr,info)
% function [ogelm] = GDS_shrink_gelm(igelm,d,units)
% function [ogelm] = GDS_expand_gelm(igelm,d,units)
% function [ogstr] = GDS_checkvias(igstr,d)
% function [iglib] = GDS_auto_rename_glib(iglib,sname)
% function [info] = GDS_ST55(str)
% % --------------------------------Functions--------------------------------
% function GDS_plot_gstr(gstr,L_sel,str)
% function GDS_plot_gelm(gelm,str)
% function GDS_plot_XY(data,str)
% function [ogstr]    = GDS_Discretize_gstr(igstr,minGrid,units)
% function [ogstr]    = GDS_Combine_gstr(igstr,units)
% function [box_str]  = GDS_CreateMask(gst,NxN)
% function [ogstr]    = GDS_Split_gstr(igstr,NxN)
% function [ogelm]    = GDS_minWidth_gelm(igelm,minWidth,minGrid,SmallestWireWidth,units)
% function [ogstr]    = GDS_minWidth_gstr(igstr,minWidth,minGrid,SmallestWireWidth,units)
% function [ogelm1,ogelm2]    = GDS_Fix_hollow_gelm(igelm,units)
% function [ogstr]    = GDS_Fix_hollow_gstr(igstr,units)
% function [glib]     = GDS_Export(location,name,istr,uunit,dbunit)
% 