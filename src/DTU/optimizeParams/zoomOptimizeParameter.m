function optimal = zoomOptimizeParameter(setNum,method,parameter,values,iterations)
% OPTIMIZEPARAMETER Optimize single parameter iteratively
    disp(['Optimizing parameter: ' parameter]);
    optimalInd = 0;
    optimalAUC = [-Inf -Inf];
    tic;

    % Iterate
    for i = 1:iterations

        disp([timestamp() ' Iteration: ' num2str(i) ' Values: ' nums2str(values)]);
        % Create methods
        for v = 1:size(values,1)
            methodV(v) = modifyDescriptor(method,parameter,values(v,:));
        end
        % Perform dtuTest on defined methods and find optimal value
        [matchROCAUC, matchPRAUC] = dtuTest(setNum,methodV,1:6,false,true,'train');
        ROCAUC = mean(matchROCAUC,1);
        PRAUC = mean(matchPRAUC,1);
        [optimalPRAUC optimalInd] = max(PRAUC);
        optimal = values(optimalInd,:);
        disp(['Optimal this iteration: ' nums2str(optimal)]);

        if iterations > 1
            % 20% interval (10% in each direction) with same number
            % of values equally distributed
            r = (values(end,:)-values(1,:)) * 0.1;
            for i = 1:size(r,2);
                values(:,i) = optimal(i) + linspace(-r(i),r(i),size(values,1));
            end
        end
    end
    disp(['Final optimal value: ' num2str(optimal)]);
end
