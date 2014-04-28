function [method, optimalV] = zoomOptimizeParameter(setNum,method,parameter,values,iterations)
% OPTIMIZEPARAMETER Optimize single parameter iteratively

pathTypes = 1:6;
runInParallel = true;

disp(['Optimizing parameter: ' parameter]);

% Iterate
for i = 1:iterations
    
    disp([timestamp() ' Iteration: ' num2str(i) ' Values: ' nums2str(values)]);
    % Create methods
    for v = 1:size(values,1)
        methodV(v) = modifyDescriptor(method,parameter,values(v,:));
    end
    % Perform dtuTest on defined methods and find optimal value
    [matchROCAUC, matchPRAUC] = dtuTest(setNum,methodV,pathTypes,false,runInParallel,'train');
    ROCAUC = mean(matchROCAUC,1);
    PRAUC = mean(matchPRAUC,1);
    [optimalPRAUC,optimalInd] = max(PRAUC);
    optimalV = values(optimalInd,:);
    method = methodV(optimalInd);
    disp(['Optimal this iteration: ' nums2str(optimalV)]);
    
    load paths;
    optDir = [dtuResults '/optimize'];
    if ~exist(optDir,'dir')
        mkdir(optDir);
    end
    save([optDir '/zoomOptimize_' parameter '_iteration-' num2str(i)]);
    
    if i < iterations
        % 20% interval (10% in each direction) with same number
        % of values equally distributed
        r = (values(end,:)-values(1,:)) * 0.1;
        for j = 1:size(r,2);
            values(:,j) = optimalV(j) + linspace(-r(j),r(j),size(values,1));
        end
    end
end
disp(['Final optimal value: ' num2str(optimalV)]);

end