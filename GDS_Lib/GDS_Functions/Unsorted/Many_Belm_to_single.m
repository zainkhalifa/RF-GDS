function [ogstr] = Many_Belm_to_single(gstr_name,igelm)
% convert from multiple bounderies to single boundey per element in a
% strcuture
% input is one element with many boundaries
% output is a gds_strcuture with many elements
           ogstr = gds_structure(gstr_name);
           L = get(igelm,'layer');
           for idx=1:length(igelm(:))
               ogstr(1+end) = gds_element('boundary', 'xy',igelm(idx),'layer',L);
           end
end

