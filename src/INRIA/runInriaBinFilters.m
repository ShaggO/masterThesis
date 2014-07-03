clc, clear all

windowSize = [134 70];

load('paths');

name = {'Go','Si'};
for i = 1:numel(name)
    load(['results/optimize/inriaParameters' name{i}]);
    
    loggerBinFilter = handler(struct('parameter',{},'iteration',{},'values',{},'PRAUC',{}));
    [~] = inriaOptimizeEnum(data,diaryFile,loggerBinFilter,method,svmArgs,'binFilter',{'box','triangle','gaussian'});
    
    save(['results/optimize/inriaParameters' name{i}]);
end