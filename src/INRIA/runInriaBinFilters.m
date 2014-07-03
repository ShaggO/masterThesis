clc, clear all

name = {'Go','Si'};
for i = 1:numel(name)
    load(['results/optimize/inriaParameters' name{i}]);

    data = inriaData;
    loggerBinFilter = handler(struct('parameter',{},'iteration',{},'values',{},'PRAUC',{}));
    [~] = inriaOptimizeEnum(data,diaryFile,loggerBinFilter,method,svmArgs,'binFilter',{'box','triangle','gaussian'});
    clear data; 
    save(['results/optimize/inriaParameters' name{i}]);
end
