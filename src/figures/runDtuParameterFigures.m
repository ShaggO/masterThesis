clc, clear all, close all

for i = 1:6
    params = load(['results/optimize/parameterStudyGo_' num2str(i) '-of-6.mat']);
    logger(:,i) = params.loggerParameterResults.data;
end

yRange = [0.7 0.8];

% plotLoggerResults(logger(1,:),'r','gridRadius',{},false,yRange)
% plotLoggerResults(logger(2,:),'\rho','centerSigma',{},false,yRange)
% plotLoggerResults(logger(3,:),'\alpha','cellSigma',{},false,yRange)
% plotLoggerResults(logger(4,:),'\beta','binSigma',{},false,yRange)
% plotLoggerResults(logger(5,:),'n','binCount',{},false,yRange)
plotLoggerResults(logger(5,:),'n','binCount',{},true,yRange)
plotLoggerResults(logger(6,:),'\eta','normSigma',{},false,yRange)
% 
% plotLoggerResults(logger(2:-1:1),'r','cellSpacing',{'Square','Triangle','location','best'},false)
% plotLoggerResults(logger(2:-1:1),'r','cellSpacing',{'Square','Triangle','location','best'},true)
% 
% plotLoggerResults(logger([3 8 9]),'\alpha','cellSigmaAlt',{'Gaussian','Triangle','Box','location','southeast'},false,[0.992 1],6)
% plotLoggerResults(logger([4 10 11]),'\beta','binSigmaAlt',{'Gaussian','Triangle','Box','location','southeast'},false,[0.996 1],6)