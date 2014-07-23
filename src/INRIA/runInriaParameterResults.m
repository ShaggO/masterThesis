clc, clear all

data = inriaData;

names = {'Go','Si'};
for i = 1:numel(names)
    params = load(['results/optimize/inriaParameters' names{i}]);

    params.loggerParameterResults = handler(emptyLogger);

    % set gridsize values

    r = struct(params.method.descriptorArgs{:});
    % Triangle
    mink = (r.gridRadius(2)-4)/(sqrt(3)*1.6)-6/sqrt(3);
    maxk = (r.gridRadius(2)-4)/(sqrt(3)*4)-6/sqrt(3);
    n = 2*round((mink:-1:maxk)/2)+6/sqrt(3);
    gridSizeTriangle = (r.gridRadius(2)-4)./(sqrt(3)*unique(n))-10^-6;

    % Square
    mink = (r.gridRadius(2)-4)/(2*1.6)-3;
    maxk = (r.gridRadius(2)-4)/(2*4)-3;
    n = 2*round((mink:-1:maxk)/2)+3;
    gridSizeSquare = (r.gridRadius(2)-4)./(2*unique(n))-10^-6;

    methodTri = modifyDescriptor(params.method,'gridType','triangle window');
    methodSqu = modifyDescriptor(params.method,'gridType','square window');


    %% Optimization parameters
    % Gridtypes triangle and square
    inriaOptimizeZoom(data,params.diaryFile,params.loggerParameterResults,methodTri,params.svmArgs, ...
        'gridSize', gridSizeTriangle');
    inriaOptimizeZoom(data,params.diaryFile,params.loggerParameterResults,methodSqu,params.svmArgs, ...
        'gridSize', gridSizeSquare');
    % Other optimal
    inriaOptimizeZoom(data,params.diaryFile,params.loggerParameterResults,params.method,params.svmArgs, ...
        'cellSigma', repmat((0.5:0.1:3)',[1 2]));
    inriaOptimizeZoom(data,params.diaryFile,params.loggerParameterResults,params.method,params.svmArgs, ...
        'binSigma', (0.5:0.1:3)');
    inriaOptimizeZoom(data,params.diaryFile,params.loggerParameterResults,params.method,params.svmArgs, ...
        'binCount', (4:16)');
    inriaOptimizeZoom(data,params.diaryFile,params.loggerParameterResults,params.method,params.svmArgs, ...
        'normSigma', repmat((3:0.2:10)',[1 2]));
    inriaOptimizeZoom(data,params.diaryFile,params.loggerParameterResults,params.method,params.svmArgs, ...
        'logc', (-6:0.1:2)');

    %% Alpha and beta tests
    % Triangle and box alpha:
    methodAlphaTri = modifyDescriptor(params.method,'cellFilter','triangle');
    methodAlphaBox = modifyDescriptor(params.method,'cellFilter','box');

    % Triangle and box beta:
    methodBetaTri = modifyDescriptor(params.method,'binFilter','triangle');
    methodBetaBox = modifyDescriptor(params.method,'binFilter','box');

    % Run alpha and beta dense
    inriaOptimizeZoom(data,params.diaryFile,params.loggerParameterResults,methodAlphaTri,params.svmArgs, ...
        'cellSigma', repmat((0.5:0.1:3)',[1 2]));
    inriaOptimizeZoom(data,params.diaryFile,params.loggerParameterResults,methodAlphaBox,params.svmArgs, ...
        'cellSigma', repmat((0.5:0.1:3)',[1 2]));
    inriaOptimizeZoom(data,params.diaryFile,params.loggerParameterResults,methodBetaTri,params.svmArgs, ...
        'binSigma', (0.5:0.1:3)');
    inriaOptimizeZoom(data,params.diaryFile,params.loggerParameterResults,methodBetaBox,params.svmArgs, ...
        'binSigma', (0.5:0.1:3)');

    %% Additional parameter choice tests
    inriaOptimizeEnum(data,params.diaryFile,params.loggerParameterResults,params.method,params.svmArgs, ...
        'normType', {'pixel','none'});
    inriaOptimizeEnum(data,params.diaryFile,params.loggerParameterResults,params.method,params.svmArgs, ...
        'cellNormStrategy', {0,4});
    inriaOptimizeEnum(data,params.diaryFile,params.loggerParameterResults,params.method,params.svmArgs, ...
        'smooth', {true,false});
    inriaOptimizeEnum(data,params.diaryFile,params.loggerParameterResults,params.method,params.svmArgs, ...
        'colour', {'gray','none'});

    save(['results/optimize/inriaParameters' names{i}],'-struct','params');
end
