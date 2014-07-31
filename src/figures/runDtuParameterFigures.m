clc, clear all, close all

names = {'Go'}; % ,'Si'
aucRange = [0.7 0.8];
dimRange = [0 450];

for k = 1:numel(names)
    for j = 1:6
        params = load(['results/optimize/parameterStudy' names{k} '_' num2str(j) '-of-6.mat']);
        logger(:,j) = params.loggerParameterResults.data;
    end

    loggerMean = logger(:,1);
    for i = 1:size(logger,1)
        PRAUCi = reshape([logger(i,:).PRAUC],[],6)';
        loggerMean(i).PRAUC = mean(PRAUCi,1);
        loggerMean(i).stdPRAUC = std(PRAUCi,0,1);
    end

    radiusLogger = loggerMean(1,:);
    radiusLogger.values = radiusLogger.values(5:end,:);
    radiusLogger.PRAUC = radiusLogger.PRAUC(:,5:end);
    radiusLogger.stdPRAUC = radiusLogger.stdPRAUC(:,5:end);
    plotLoggerResults(radiusLogger,'r',['dtuParameters' names{k} '_gridRadius'],{},false,aucRange)
    plotLoggerResults(loggerMean(2,:),'\rho',['dtuParameters' names{k} '_centerSigma'],{},false,aucRange)
    alphaLogger = loggerMean(3,:);
    alphaLogger.values = alphaLogger.values(1:end-11,:);
    plotLoggerResults(alphaLogger,'\alpha',['dtuParameters' names{k} '_cellSigma'],{},false,aucRange)
    plotLoggerResults(loggerMean(4,:),'\beta',['dtuParameters' names{k} '_binSigma'],{},false,aucRange)
    plotLoggerResults(loggerMean(5,:),'n',['dtuParameters' names{k} '_binCount'],{},false,aucRange)
    plotLoggerResults(loggerMean(5,:),'n',['dtuParameters' names{k} '_binCount'],{},true,dimRange)
    plotLoggerResults(loggerMean(6,:),'\eta',['dtuParameters' names{k} '_normSigma'],{},false,aucRange)

    plotLoggerResults(loggerMean([3 7 8]),'\alpha',['dtuParameters' names{k} '_cellSigmaAlt'],{'Gaussian','Triangle','Box','location','southeast'},false,aucRange,6)
    plotLoggerResults(loggerMean([4 9 10]),'\beta',['dtuParameters' names{k} '_binSigmaAlt'],{'Gaussian','Triangle','Box','location','southeast'},false,aucRange,6)

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
    fid = fopen(['table' names{k} '.txt'],'w');
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
end