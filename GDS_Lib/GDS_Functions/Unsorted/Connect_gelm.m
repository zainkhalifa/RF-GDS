function [ogelm] = Connect_gelm(igelm1,igelm2,units)
% Connect two gds_elements that are connected together at one point while
% maintaing the shapes without any distrotion, 
% Author : Zainulabideen Khalifa            Last Revision : 05/02/2020

    if layer(igelm1) ~= layer(igelm2)
        error("ZAIN: Layers of input elements don't match !")
        return;
    end
    L = layer(igelm1);                  % store the layer
    XY1 = {igelm1(1)};
    XY2 = {igelm2(1)};   % get the data in the gelms
    [XY1, hf] = poly_boolmex(XY1, XY2, 'or', units);
    if length(XY1(:))>2
        % get the biggest two elements, most likely the small things are
        % noise because of the descretization
        for idx=1:length(XY1(:))
            XY = XY1{idx};
            len(idx) = length(XY(:,1));
        end
        IDX = 1:length(XY1(:));
        [m,I1] = max(len(IDX));      
        IDX(I1) = [];
        [m,I2] = max(len(IDX));
        IDX(I2) = [];
        XY1(IDX) = [];  % remove all others except the largest two 
        hf(IDX)  = [];
    end
    if (length(XY1(:))==2 & any(hf)) %any(hf)
        XYinner = XY1{find(hf==1)};
        XYouter = XY1{find(hf==0)};
        XYinner = cat(1,XYinner,XYinner(1,:));
        XYouter = cat(1,XYouter,XYouter(1,:));

        % find the center of the proper element
        Xleft = min(XYouter(:,1));
        Xright = mean(XYinner(:,1));
        Y = mean(XYinner(:,2));
        e = 0.5/(100*units);
        XY_line = [ Xleft   Y-e;...
                    Xright  Y-e;...
                    Xright  Y+e;...
                    Xleft   Y+e;...
                    Xleft   Y-e];
        
        [XYouter, hf] = poly_boolmex({XYouter}, {XY_line}, 'diff', 1000*units);
        XYouter = cell2mat(XYouter);XYouter = cat(1,XYouter,XYouter(1,:));
        [XY1, hf] = poly_boolmex({XYouter}, {XYinner}, 'diff', 1000*units);
        XY1 = cell2mat(XY1);XY1 = {cat(1,XY1,XY1(1,:))};
    elseif (length(XY1(:))==1)
        XY1 = XY1{1};
        XY1 = cat(1,XY1,XY1(1,:));
        XY1 = {XY1};
    else
        XY1, hf
        error("ZAIN: The two elements are not connected !\n or the minGrid choise was too big creating holes in corners\n")
        return;
    end
    ogelm = gds_element('boundary', 'xy',XY1{1},'layer',L);
end

