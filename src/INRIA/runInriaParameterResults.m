clc, clear all

data = inriaData;

name = {'Go','Si'};
for i = 1:numel(name)
    params = load(['results/optimize/inriaParameters' name{i}]);

    params.loggerParameterResults = handler(struct('parameter',{},'iteration',{},'values',{},'PRAUC',{}));
    
    [~] = inriaOptimizeZoom(data,params.diaryFile,params.loggerParameterResults,params.method,params.svmArgs, ...
        'gridSize', (2:0.1:4)');
    [~] = inriaOptimizeZoom(data,params.diaryFile,params.loggerParameterResults,params.method,params.svmArgs, ...
        'cellSigma', repmat((0.5:0.1:2)',[1 2]));
    [~] = inriaOptimizeZoom(data,params.diaryFile,params.loggerParameterResults,params.method,params.svmArgs, ...
        'binSigma', (0.5:0.1:2.5)');
    [~] = inriaOptimizeZoom(data,params.diaryFile,params.loggerParameterResults,params.method,params.svmArgs, ...
        'binCount', (4:16)');
    [~] = inriaOptimizeZoom(data,params.diaryFile,params.loggerParameterResults,params.method,params.svmArgs, ...
        'normSigma', repmat((3:0.2:10)',[1 2]));
    [~] = inriaOptimizeZoom(data,params.diaryFile,params.loggerParameterResults,params.method,params.svmArgs, ...
        'logc', (-6:0.1:2)');
    
    save(['results/optimize/inriaParameters' name{i}],'-struct','params');
end
