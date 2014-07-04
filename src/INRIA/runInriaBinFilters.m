clc, clear all

data = inriaData;

name = {'Go','Si'};
for i = 1:numel(name)
    params = load(['results/optimize/inriaParameters' name{i}]);

    params.loggerBinFilter = handler(struct('parameter',{},'iteration',{},'values',{},'PRAUC',{}));
    [~] = inriaOptimizeEnum(data,params.diaryFile,params.loggerBinFilter,...
        params.method,params.svmArgs,'binFilter',{'box','triangle','gaussian'});
    save(['results/optimize/inriaParameters' name{i}],'-struct','params');
end
