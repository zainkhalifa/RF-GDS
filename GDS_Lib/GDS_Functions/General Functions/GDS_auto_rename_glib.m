function [iglib] = GDS_auto_rename_glib(iglib,sname)
%GDS_auto_rename_glib will rename all gds_structures in the gds_library so
%that they all have different names as sname_idx for idx 1:number of gstr.
%This is needed so Cadence doesnt give you errors when importing.
%
% Author : Zainulabideen Khalifa            Last Revision : 09/06/2020
%
% function [iglib] = GDS_auto_rename_glib(iglib,sname)

    for s_idx = 1:length(iglib(:))
        name = convertStringsToChars(sprintf("%s_%0.0f",sname,s_idx));
        iglib(s_idx) = rename(iglib(s_idx), name);
    end
end