function [method, optimalV] = zoomOptimizeParameter(setNum,method,parameter,values,iterations)
% OPTIMIZEPARAMETER Optimize single parameter iteratively

pathTypes = 1:6;
runInParallel = true;

minV = values(1,:);
maxV = values(end,:);

diary optimizeParameter.out
disp(['Optimizing parameter: ' parameter]);
diary off

% Iterate
for i = 1:iterations
    diary optimizeParameter.out
    disp([timestamp() ' Iteration ' num2str(i) ', values: ' nums2str(values)]);
    diary off
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

    diary optimizeParameter.out
    disp(['Optimal this iteration: ' nums2str(optimalV)]);
    disp(['optimal PRAUC: ' num2str(optimalPRAUC)]);
    diary off

    load paths;
    optDir = [dtuResults '/optimize'];
    if ~exist(optDir,'dir')
        mkdir(optDir);
    end
    save([optDir '/zoomOptimize_' strrep(datestr(now),':','-') '_' parameter '_iteration-' num2str(i)]);

    if i < iterations
        % 20% interval (10% in each direction) with same number
        % of values equally distributed
        r = (values(end,:)-values(1,:)) * 0.1;

        for j = 1:size(r,2);
            values(:,j) = min(max(optimalV(j),minV(j)+r(j)),maxV(j)-r(j)) + ...
                linspace(-r(j),r(j),size(values,1));
        end
    end
end
diary optimizeParameter.out
disp(['Final optimal value: ' nums2str(optimalV)]);
diary off

end
