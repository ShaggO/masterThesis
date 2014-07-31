clc, clear all, close all

names = {'inriaParametersGo','inriaParametersSi'}; % ,'inriaParametersSi'
yRanges = {[0.994 1],[0.97 1]};
yRangeDims = {[0 12000],[0 12000]};
yRangeCellSigmaAlt = {[0.994 1],[0.97 1]};
yRangeBinSigmaAlt = {[0.994 1],[0.97 1]};
betas = [10, 11];
height = 3.5;
heightDims = 3;

for i = 1:numel(names)
    name = names{i};
    yRange = yRanges{i};
    yRangeDim = yRangeDims{i};
    params = load(['results/optimize/' name ]);
    logger = params.loggerParameterResults.data';

    logger(1).values(end) = [];
    logger(2).values(end) = [];

%     plotLoggerResults(logger(8),'\alpha',[name '_cellSigma'],{},false,yRanges{i},height)
%     plotLoggerResults(logger(betas(i)),'\beta',[name '_binSigma'],{},false,yRanges{i},height)
    plotLoggerResults(logger(3),'n',[name '_binCount'],{},false,yRanges{i},height)
    plotLoggerResults(logger(3),'n',[name '_binCount'],{},true,yRangeDims{i},heightDims)
    plotLoggerResults(logger(4),'\eta',[name '_normSigma'],{},false,yRanges{i},height)
    plotLoggerResults(logger(5),'log C',[name '_logC'],{},false,yRanges{i},height)

    plotLoggerResults(logger(2:-1:1),'r',[name '_cellSpacing'],{'Square','Triangle','location','southwest'},false,yRanges{i},height)
    plotLoggerResults(logger(2:-1:1),'r',[name '_cellSpacing'],{'Square','Triangle','location','northeast'},true,yRangeDims{i},heightDims)

    plotLoggerResults(logger([6 7 8]),'\alpha',[name '_cellSigmaAlt'],{'G','Tri','Box','location','southeast'},false,yRangeCellSigmaAlt{i},height,false)
    plotLoggerResults(logger([9 10 11]),'\beta',[name '_binSigmaAlt'],{'G','Tri','Box','location','southeast'},false,yRangeBinSigmaAlt{i},height,false)
end
