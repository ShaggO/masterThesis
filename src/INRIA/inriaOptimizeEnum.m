function [method,svmArgs] = inriaOptimizeEnum( ...
    data,diaryFile,method,svmArgs,varargin)
% ENUMOPTIMIZEPARAMETER Optimize enumerated sets of parameters

assert(numel(varargin) >= 2,'Specify at least one parameter,value pair');
assert(mod(numel(varargin),2) == 0,'Wrong formatting of (param,value) pairs');

splits = 6;
runInParallel = false;

parameters = varargin(1:2:end);
values = varargin(2:2:end);

nValues = numel(values{1});

% Create methods for each input
paramMethods(1:nValues) = method;
paramSvmArgs(1:nValues) = svmArgs;
PRAUC = zeros(1,nValues);
for j = 1:nValues
    for i = 1:numel(parameters)
        if ismember(parameters{i},{'s','c','logc','p'})
            paramSvmArgs(j).(parameters{i}) = values{i}{j};
        else
            paramMethods(j) = modifyDescriptor(paramMethods(j),parameters{i},values{i}{j});
        end
    end
    PRAUC(j) = inriaCrossValidateSvm(data,splits,paramMethods(j),paramSvmArgs(j),runInParallel);
end

% Compute performance of each method and find optimal
PRAUC
[optimalPRAUC,optimalInd] = max(PRAUC);
method = paramMethods(optimalInd);
svmArgs = paramSvmArgs(optimalInd);

% Display results
diary(diaryFile)
for p = 1:numel(parameters)
    param = parameters{p};
    switch class(values{p}{optimalInd})
        case 'char'
            optimalStr = values{p}{optimalInd};
        case 'double'
            optimalStr = nums2str(values{p}{optimalInd});
    end
    disp(['Optimal ' param ': ' optimalStr]);
end
disp(['Optimal PRAUC: ' num2str(optimalPRAUC) sprintf('\n')]);
diary off

end
