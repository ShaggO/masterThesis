clc, clear all, close all

name = 'dtuParametersGo';
yRange = [0.7 0.8];

for j = 1:6
    params = load(['results/optimize/parameterStudyGo_' num2str(j) '-of-6.mat']);
    logger(:,j) = params.loggerParameterResults.data;
end

plotLoggerResults(logger(1,:),'r',[name 'gridRadius'],{},false,yRange)
plotLoggerResults(logger(1,:),'r',[name 'gridRadius'],{},true,yRange)
% plotLoggerResults(logger(2,:),'\rho',[name 'centerSigma'],{},false,yRange)
% plotLoggerResults(logger(3,:),'\alpha',[name 'cellSigma'],{},false,yRange)
% plotLoggerResults(logger(4,:),'\beta',[name 'binSigma'],{},false,yRange)
% plotLoggerResults(logger(5,:),'n',[name 'binCount'],{},false,yRange)
% plotLoggerResults(logger(5,:),'n',[name 'binCount'],{},true,yRange)
% plotLoggerResults(logger(6,:),'\eta',[name 'normSigma'],{},false,yRange)
% 
% plotLoggerResults(logger(2:-1:1),'r','cellSpacing',{'Square','Triangle','location','best'},false)
% plotLoggerResults(logger(2:-1:1),'r','cellSpacing',{'Square','Triangle','location','best'},true)
% 
% plotLoggerResults(logger([3 8 9]),'\alpha','cellSigmaAlt',{'Gaussian','Triangle','Box','location','southeast'},false,[0.992 1],6)
% plotLoggerResults(logger([4 10 11]),'\beta','binSigmaAlt',{'Gaussian','Triangle','Box','location','southeast'},false,[0.996 1],6)