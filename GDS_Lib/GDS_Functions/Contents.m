% Created By Zainulabideen Khalifa , November, 2019
% Last edited on                    Last Revision : 09/06/2020
%
% To work with this file you need to do few thnigs:
% 1) install mex compiler by running the file "mingw.mlpkginstall" or
% google it for other methods if you dont have that file. 
% 2) copy the library to any fixed folder prefereably store it in 
% "C:\Program Files\MATLAB\R2017b\toolbox\gds2-toolbox"
% 3) set path in matlab to include all subfolders in your location of the
% toolbox. you can do that from HOME --> Set Path.
% 4) compile the library by running "makemex.m". you need to do this only
% once. 


% % ----------------------General Functions--------------------------------
% function GDS_plot(igds,str)
% function [ogstr] = GDS_MATH(ig1,ig2,operation,units)
% function [ogstr] = GDS_Merge(igstr,units)
% function [ogstr] = GDS_combine_gstrcells(igstr)
% function [ogelm] = GDS_Create_box(d,c)
% function [ogelm] = GDS_Create_Octagonal(d_side, center, max45)
% function [ogstr] = GDS_Create_Grid(igstr,NxN)
% function [ogstr] = GDS_Split_gstr(igstr,NxN,units)
% function [RC,Center] = GDS_Mosaic_calc(igelm,Mosaic)
% function [ogstr] = GDS_Mosaic(igds,Mosaic,RC,Center)
% function [ogds] = GDS_Shift(igds,shift)
% function [ogds] = GDS_reset(igds,info)
% function [iglib] = GDS_auto_rename_glib(iglib,sname)

% % ----------------------Layout specific Functions------------------------
% function [ogstr] = GDS_checkvias(igstr,d)
% function [ogstr] = GDS_Mosaic_intersections(igds,Mosaic_gstr,units)
% function [ogstr] = GDS_Mosaic_imprint(block_gstr,bbox_block,igstr,bbox_gstr,units)
% function [ogstr]    = GDS_Discretize_gstr(igstr,minGrid,units)
% function [ogelm]    = GDS_minWidth_gelm(igelm,minWidth,minGrid,SmallestWireWidth,units)
% function [ogstr]    = GDS_minWidth_gstr(igstr,minWidth,minGrid,SmallestWireWidth,units)
% function [xo,yo]    = Discritize_2P(X,Y,minGrid)
% function [XY,count] = minWidth_corr(XY,minWidth,minGrid,SmallestWireWidth,units)

% % ----------------------ST55 Functions-----------------------------------
% function [info] = GDS_ST55(str)
% function [ogstr] = GDS_ST55_Generate_tileNot(igstr)

% % --------------------Unsorted Functions--------------------------------
% function [ogstr]    = Many_Belm_to_single(gstr_name,igelm)
% function [ogelm]    = Connect_gelm(igelm1,igelm2,units)
%==========================================================================


% % --------------------------The Graveyard--------------------------------
% function [glib] = Export_GDS_data(name,data,Layer,uunit,dbunit)
% function [Cdata] = Stupid_Combine_GDS(data,E_Layer)
% function [Cdata] = Combine_GDS(data,E_Layer)
% function [Con] = Get_GDSCon(igstr)
% function [ogelm] = oldConnect_gelm(igelm1,igelm2,units)
% function [ogstr] = GDS_combine_gstr(igstr)
% function [ogstr] = GDS_AND(gelm,igstr,layer,units)
% function [ogstr] = GDS_diff(gelm,igstr,layer,units)
% function GDS_plot_gstr(gstr,L_sel,str)
% function GDS_plot_gelm(gelm,str)
% function GDS_plot_XY(data,str)
% function [gstr] = GDS_Mosaic_gelm(gelm,d_edge,d,RC)
% function [ogstr] = GDS_shift_gstr(igstr,shift)
% function [ogelm] = GDS_shift_gelm(igelm,shift)
% function [ogelm] = GDS_reset_gelm(igelm,info)
% function [ogstr] = GDS_reset_gstr(igstr,info)
% function [ogstr]    = GDS_Combine_gstr(igstr,units)
% function [ogelm] = GDS_shrink_gelm(igelm,d,units)
% function [ogelm] = GDS_expand_gelm(igelm,d,units)
% function [glib]     = GDS_Export(location,name,istr,uunit,dbunit)
% function [ogstr] = GDS_fill_vias(igstr,Mosaic,layer,seperation,units)
% function [ogelm1,ogelm2]    = GDS_Fix_hollow_gelm(igelm,units)
% function [ogstr]    = GDS_Fix_hollow_gstr(igstr,units)
