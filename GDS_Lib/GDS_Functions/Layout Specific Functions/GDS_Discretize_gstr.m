function [ogstr]    = GDS_Discretize_gstr(igstr,minGrid,units)
% This function will discritize a set of points given in Xi and Yi so that
% they are all lies on the grid given minGrid value. The input is a
% gds_structure with all elements. the function will maintian the layer
% information
%
% Author : Zainulabideen Khalifa            Last Revision : 05/02/2020
%
% function [ogstr]    = GDS_Discretize_gstr(igstr,minGrid,units)

    fprintf("\nRunning Discretize_gstr...\n");
    % initiate the output gds_strcut
    ogstr = gds_structure(get(igstr,'sname'));
    
    % loop for each element in igstr
    for idx = 1:numel(igstr)
        t = cputime;fprintf("Elm%0.0f:",idx)
        %--------------Start Discritize of one element-----------
        L    = layer(igstr(idx));
        clear XY Xi Yi
        XY = cell2mat(xy(igstr(idx)));
        Xi(:) = XY(:,1)*units;
        Yi(:) = XY(:,2)*units;

        if length(Xi)<2 | length(Yi)<2
            error("ZAIN: Discretize function requires at least two points")
            return
        end
        % opt is used to speed up the processing by choosing the simpliest
        % reference variable
        opt = sum(abs(diff(Yi))) < sum(abs(diff(Xi)));
        if opt
            temp = Xi;Xi = Yi;Yi = temp;
        end
        X = [];
        Y = [];
        for n=1:length(Xi)-1
            [x,y] =  Discritize_2P(Xi(n:n+1),Yi(n:n+1),minGrid);
            X = [X(1:end) x];
            Y = [Y(1:end) y];
        end
        % Precaution if the end point does not coincide on the first
        if X(end) ~= X(1) | Y(end) ~= Y(1)
           X = [X(1:end) X(1)];
           Y = [Y(1:end) Y(1)];
        end
        if opt
            temp = X;X = Y;Y = temp;
        end
        Ddata = [X;Y]'./units;
        % remove consecutive duplicates
        Ddata(diff(Ddata(:,1))==0 & diff(Ddata(:,2))==0,:) = []; 
    	%--------------End of Discritize of one element----------- 
        ogstr(idx) = gds_element('boundary', 'xy',Ddata,'layer',L);
        T(idx) = (cputime-t);
        fprintf("Discretize: Elapsed time = %0.2f s\n",sum(T));
    end
%     fprintf("\nTotal processing time = %0.2f s\n",sum(T))
    fprintf("Total number of elements = %0.0f\n",numel(igstr))
    fprintf("DONE!\n");beep;
end

