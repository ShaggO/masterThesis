clc, clear all

for j = 1:6
    params = load(['results/optimize/parameterStudyGo_' num2str(j) '-of-6.mat']);
    logger(:,j) = params.loggerParameterResults.data;
end

loggerMean = logger(:,1);
for i = 1:size(logger,1)
    PRAUCi = reshape([logger(i,:).PRAUC],[],6)';
    loggerMean(i).PRAUC = mean(PRAUCi,1);
    loggerMean(i).stdPRAUC = std(PRAUCi,0,1);
end

loggerMean(12)
loggerMean(13)
loggerMean(14)