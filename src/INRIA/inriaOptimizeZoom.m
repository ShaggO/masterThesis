function [methodBest,svmArgsBest,optimalV] = inriaOptimizeZoom( ...
    data,diaryFile,logger,method,svmArgs,parameter,values,varargin)
% OPTIMIZEPARAMETER Optimize single parameter iteratively

splits = 6;
runInParallel = true;

isSvmArg = ismember(parameter,{'s','c','logc','p'});
minV = values(1,:);
maxV = values(end,:);
methodBest = method;

% get original parameter value
if isSvmArg
    origValue = svmArgs.(parameter);
else
    desArgsStruct = struct(method.descriptorArgs{:});
    origValue = desArgsStruct.(parameter);
end

diary(diaryFile)
if isSvmArg
    disp(['Optimizing SVM parameter: ' parameter]);
else
    disp(['Optimizing method parameter: ' parameter]);
end
diary off

% Iterate
for i = 1:numel(varargin)+1
    diary(diaryFile)
    disp(['Iteration ' num2str(i) ', values: ' nums2str(values)]);
    diary off
    % Create methods
    clear methodV
    if i == numel(varargin)+1 % add original method to last iteration
        values = [values; origValue];
    end
    PRAUC = zeros(1,size(values,1));
    dims = PRAUC;
    for v = 1:size(values,1)
        if isSvmArg
            svmArgsV(v) = svmArgs;
            svmArgsV(v).(parameter) = values(v,:);
            [PRAUC(v),dims(v)] = inriaCrossValidateSvm(data,splits,method,svmArgsV(v),runInParallel);
        else
            methodV(v) = modifyDescriptor(methodBest,parameter,values(v,:));
            [PRAUC(v),dims(v)] = inriaCrossValidateSvm(data,splits,methodV(v),svmArgs,runInParallel);
        end
    end
    
    PRAUC
    [optimalPRAUC,optimalInd] = max(PRAUC);
    optimalV = values(optimalInd,:);
    if isSvmArg
        methodBest = method;
        svmArgsBest = svmArgsV(optimalInd);
    else
        methodBest = methodV(optimalInd);
        svmArgsBest = svmArgs;
    end

    diary(diaryFile)
    disp(['PRAUCs: ' num2str(PRAUC)])
    disp(['Optimal this iteration: ' nums2str(optimalV)]);
    disp(['Optimal PRAUC: ' num2str(optimalPRAUC)]);
    diary off
    
    logger.data(end+1) = struct('parameter',parameter,'iteration',i,'values',values,'PRAUC',PRAUC,'dims',dims);

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