function [method,optimal] = enumOptimizeParameter(setNum, method, varargin)
% ENUMOPTIMIZEPARAMETER Optimize enumerated sets of parameters

assert(numel(varargin) >= 2,'Specify at least one parameter,value pair');
assert(mod(numel(varargin),2) == 0,'Wrong formatting of (param,value) pairs');

parameters = varargin(1:2:end);
values = varargin(2:2:end);

valueNum = numel(values{1});

% Create methods for each input
paramMethods(1:valueNum) = method;
for i = 1:numel(parameters)
    for j = 1:numel(values{i})
        paramMethods(j) = modifyDescriptor(paramMethods(j),parameters{i},values{i}{j});
    end
end

% Compute performance of each method and find optimal
[matchROCAUC, matchPRAUC] = dtuTest(setNum, paramMethods, 1:6, false, true, 'train');
ROCAUC = mean(matchROCAUC,1);
PRAUC = mean(matchPRAUC,1);
[optimalPRAUC,optimal] = max(PRAUC);
method = paramMethods(optimal);

% Display results
for p = 1:numel(parameters)
    param = parameters{p};
    switch class(values{p}{optimal})
        case 'char'
            optimalStr = values{p}{optimal};
        case 'double'
            optimalStr = nums2str(values{p}{optimal});
    end
    disp(['Optimal ' param ': ' optimalStr]);
end

end
