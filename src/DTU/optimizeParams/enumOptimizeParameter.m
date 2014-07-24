function [method,optimal] = enumOptimizeParameter( ...
    setNum, method, diaryFile, logger, varargin)
% ENUMOPTIMIZEPARAMETER Optimize enumerated sets of parameters

assert(numel(varargin) >= 2,'Specify at least one parameter,value pair');
assert(mod(numel(varargin),2) == 0,'Wrong formatting of (param,value) pairs');

pathTypes = 1:6;
runInParallel = true;

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
[matchROCAUC, matchPRAUC, dims] = dtuTest(setNum,paramMethods,pathTypes,false,runInParallel,'train');
ROCAUC = mean(matchROCAUC,1);
PRAUC = mean(matchPRAUC,1)
stdPRAUC = std(matchPRAUC,0,1);

[optimalPRAUC,optimal] = max(PRAUC);
method = paramMethods(optimal);

load paths;
optDir = [dtuResults '/optimize'];
if ~exist(optDir,'dir')
    mkdir(optDir);
end
name = interweave(parameters,repmat({'-'},1,numel(parameters)-1));
save([optDir '/enumOptimize_' strrep(datestr(now),':','-') '_' [name{:}]]);

% Display results
diary(diaryFile)
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
disp(['Optimal PRAUC: ' num2str(optimalPRAUC) sprintf('\n')]);
diary off

if numel(parameters) > 1
    logger.data(end+1) = struct('parameter',{parameters},'iteration',1,'values',{values},'PRAUC',PRAUC,'stdPRAUC',stdPRAUC,'dims',dims);
else
    logger.data(end+1) = struct('parameter',parameters,'iteration',1,'values',values,'PRAUC',PRAUC,'stdPRAUC',stdPRAUC,'dims',dims);
end

end
