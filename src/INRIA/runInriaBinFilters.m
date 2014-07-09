clc, clear all

data = inriaData;

name = {'Go','Si'};
for i = 1:numel(name)
    params = load(['results/optimize/inriaParameters' name{i}]);

    params.loggerBinFilter = handler(emptyLogger);
    [~] = inriaOptimizeEnum(data,params.diaryFile,params.loggerBinFilter,...
        params.method,params.svmArgs,'binFilter',{'box','triangle','gaussian'});
    save(['results/optimize/inriaParameters' name{i}],'-struct','params');
end
