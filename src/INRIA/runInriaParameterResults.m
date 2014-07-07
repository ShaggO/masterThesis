clc, clear all

data = inriaData;

name = {'Go','Si'};
for i = 1:numel(name)
    params = load(['results/optimize/inriaParameters' name{i}]);

    params.loggerParameterResults = handler(struct('parameter',{},'iteration',{},'values',{},'PRAUC',{}));
    
    % set gridsize values
    r = struct(params.method.descriptorArgs{:});
    if strcmp(r.gridType,'square window')
        mink = (r.gridRadius(2)/2-2)/(2*2)-3*r.cellSigma(2)/2;
        maxk = (r.gridRadius(2)/2-2)/(2*4)-3*r.cellSigma(2)/2;
        gridSize = (r.gridRadius(2)/2-2)./(2*(round(mink):-1:round(maxk))+3*r.cellSigma(2))-10^-6;
    elseif strcmp(r.gridType,'triangle window')
        mink = (r.gridRadius(2)/2-2)/(sqrt(3)*2)-3*r.cellSigma(2)/sqrt(3);
        maxk = (r.gridRadius(2)/2-2)/(sqrt(3)*4)-3*r.cellSigma(2)/sqrt(3);
        gridSize = (r.gridRadius(2)/2-2)./(sqrt(3)*(round(mink):-1:round(maxk))+3*r.cellSigma(2))-10^-6;
    end
    
    [~] = inriaOptimizeZoom(data,params.diaryFile,params.loggerParameterResults,params.method,params.svmArgs, ...
        'gridSize', gridSize');
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
