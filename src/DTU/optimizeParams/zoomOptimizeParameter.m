function [methodBest, optimalV] = zoomOptimizeParameter(setNum,method,diaryFile,parameter,values,varargin)
% OPTIMIZEPARAMETER Optimize single parameter iteratively

pathTypes = 1:6;
runInParallel = true;

minV = values(1,:);
maxV = values(end,:);
methodBest = method;

diary(diaryFile)
disp(['Optimizing parameter: ' parameter]);
diary off

% Iterate
for i = 1:numel(varargin)+1
    diary(diaryFile)
    disp(['Iteration ' num2str(i) ', values: ' nums2str(values)]);
    diary off
    % Create methods
    clear methodV
    for v = 1:size(values,1)
        methodV(v) = modifyDescriptor(methodBest,parameter,values(v,:));
    end
    if i == numel(varargin)+1 % add original method to last iteration
        methodV = [methodV method];
    end
    % Perform dtuTest on defined methods and find optimal value
    [matchROCAUC, matchPRAUC] = dtuTest(setNum,methodV,pathTypes,false,runInParallel,'train');
    ROCAUC = mean(matchROCAUC,1);
    PRAUC = mean(matchPRAUC,1)
    [optimalPRAUC,optimalInd] = max(PRAUC);
    optimalV = values(optimalInd,:);
    methodBest = methodV(optimalInd);

    diary(diaryFile)
    disp(['Optimal this iteration: ' nums2str(optimalV)]);
    disp(['Optimal PRAUC: ' num2str(optimalPRAUC)]);
    diary off

    load paths;
    optDir = [dtuResults '/optimize'];
    if ~exist(optDir,'dir')
        mkdir(optDir);
    end
    save([optDir '/zoomOptimize_' strrep(datestr(now),':','-') '_' parameter '_iteration-' num2str(i)]);

    if i <= numel(varargin)
        r = varargin{i};

        values = zeros(size(r));
        for j = 1:size(r,2);
            values(:,j) = min(max(optimalV(j),minV(j)-min(r(:,j))), ...
                maxV(j)-max(r(:,j))) + r(:,j);
        end
    end
end
diary(diaryFile)
disp(['Final optimal value: ' nums2str(optimalV) sprintf('\n')]);
diary off

end
