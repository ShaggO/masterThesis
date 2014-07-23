clc, clear all, close all

name = 'Go';
yRange = [0.7 0.8];

for j = 1:6
    params = load(['results/optimize/parameterStudy' name '_' num2str(j) '-of-6.mat']);
    logger(:,j) = params.loggerParameterResults.data;
end

% plotLoggerResults(logger(1,:),'r',['dtuParameters' name '_gridRadius'],{},false,yRange)
% plotLoggerResults(logger(2,:),'\rho',['dtuParameters' name '_centerSigma'],{},false,yRange)
% plotLoggerResults(logger(3,:),'\alpha',['dtuParameters' name '_cellSigma'],{},false,yRange)
% plotLoggerResults(logger(4,:),'\beta',['dtuParameters' name '_binSigma'],{},false,yRange)
% plotLoggerResults(logger(5,:),'n',['dtuParameters' name '_binCount'],{},false,yRange)
% plotLoggerResults(logger(5,:),'n',['dtuParameters' name '_binCount'],{},true,yRange)
% plotLoggerResults(logger(6,:),'\eta',['dtuParameters' name '_normSigma'],{},false,yRange)
% 
% plotLoggerResults(logger(2:-1:1),'r',['dtuParameters' name '_cellSpacing'],{'Square','Triangle','location','best'},false)
% plotLoggerResults(logger(2:-1:1),'r',['dtuParameters' name '_cellSpacing'],{'Square','Triangle','location','best'},true)
% 
% plotLoggerResults(logger([3 8 9]),'\alpha',['dtuParameters' name '_cellSigmaAlt'],{'Gaussian','Triangle','Box','location','southeast'},false,[0.992 1],6)
% plotLoggerResults(logger([4 10 11]),'\beta',['dtuParameters' name '_binSigmaAlt'],{'Gaussian','Triangle','Box','location','southeast'},false,[0.996 1],6)

%% Grid layout table
params.logger.data = reshape(params.logger.data,[29 6]);
layout = params.logger.data(1,:);
gridType = layout(1).values{1};
gridSize = layout(1).values{2};
cellFilter = layout(1).values{3};

sizes = unique(cell2mat(gridSize'),'rows','stable');
sizes = sizes([4 3 2 1 6 5 7],:);
types = unique(gridType,'stable');
data = zeros(size(sizes,1),numel(types));
fid = fopen('table.txt','w');
for i = 1:size(sizes,1)
    s = ['$' num2str(sizes(i,1)) ' \\times ' num2str(sizes(i,2)) '$'];
    for j = 1:numel(types)
        idx = find(ismember(gridType',types{j}) & ...
            ismember(cell2mat(gridSize'),sizes(i,:),'rows'));
        if ~isempty(idx)
            data(i,j) = mean(cellfun(@(x) x(idx),{layout(:).PRAUC}));
            s = [s ' & $' sprintf('%.3f',data(i,j)) '$'];
        else
            s = [s ' & -'];
        end
    end
    s = [s ' \\\\ \n'];
    fprintf(fid,s);
end

% fid = fopen('table.txt','w');
% fprintf(fid,'');