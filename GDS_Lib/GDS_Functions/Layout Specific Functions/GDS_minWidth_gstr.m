function [ogstr]    = GDS_minWidth_gstr(igstr,minWidth,minGrid,SmallestWireWidth,units)
% Author : Zainulabideen Khalifa            Last Revision : 05/02/2020

    fprintf("\nRunning GDS_minWidth_gstr...\n");
    % initiate the output gds_strcut
    ogstr = gds_structure(get(igstr,'sname'));
	for idx = 1:length(igstr(:))
		ogstr(idx) = GDS_minWidth_gelm(igstr(idx),minWidth,minGrid,SmallestWireWidth,units);
	end
	fprintf("minWidth_gstr...DONE!\n");beep;
end

