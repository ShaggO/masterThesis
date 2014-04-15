function optimal = optimizeParameter(method,parameter,values,iterations)
% OPTIMIZEPARAMETER Optimize single parameter iteratively
    disp(['Optimizing parameter: ' parameter]);
    optimalInd = 0;
    optimalAUC = [-Inf -Inf];

    % Iterate
    for i = 1:iterations

        disp([timestamp() ' Iteration: ' num2str(i) ' Values: ' nums2str(values)]);
        % Create methods
        for v = 1:numel(v)
            methodV(v) = method;
            methodV(v).(parameter) = v;
        end
        % Perform dtuTest on defined methods and find optimal value
        [ROCAUC, PRAUC] = dtuTest(setNum,methodV,1:6,false,true,true);
        [optimalPRAUC optimalInd] = max(PRAUC);
        optialROCAUC = ROCAUC(optimalInd);
        optimal = values(optimalInd);
        disp(['Optimal this iteration: ' num2str(optimal)]);

        % 20% interval (10% in each direction) with same number
        % of values equally distributed
        r = (values(end)-values(1)) * 0.1;
        values = optimal + linspace(-r,r,numel(values));
    end
    disp(['Final optimal value: ' num2str(optimal)]);
end
