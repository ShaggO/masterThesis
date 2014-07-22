clc, clear all, close all

params = load('results/optimize/inriaParametersGo');
logger = params.loggerParameterResults.data';

logger(1).values(end) = [];
logger(2).values(end) = [];

plotLoggerResults(logger(3),'\alpha','cellSigma',{},false)
plotLoggerResults(logger(4),'\beta','binSigma',{},false)
plotLoggerResults(logger(5),'n','binCount',{},false)
plotLoggerResults(logger(5),'n','binCount',{},true)
plotLoggerResults(logger(6),'\eta','normSigma',{},false)
plotLoggerResults(logger(7),'log(C)','logC',{},false)

plotLoggerResults(logger(2:-1:1),'r','cellSpacing',{'Square','Triangle','location','best'},false)
plotLoggerResults(logger(2:-1:1),'r','cellSpacing',{'Square','Triangle','location','best'},true)

plotLoggerResults(logger([3 8 9]),'\alpha','cellSigmaAlt',{'Gaussian','Triangle','Box','location','southeast'},false,[0.992 1],6)
plotLoggerResults(logger([4 10 11]),'\beta','binSigmaAlt',{'Gaussian','Triangle','Box','location','southeast'},false,[0.996 1],6)
