clc, clear all

for j = 1:6
    params = load(['results/optimize/parameterStudyGo_' num2str(j) '-of-6.mat']);
    logger2(:,j) = params.loggerParameterResults.data;
end
logger1 = reshape(params.logger.data,[],6);

loggerMean1 = logger1(:,1);
loggerMean2 = logger2(:,1);
for i = 1:size(logger1,1)
    PRAUCi = reshape([logger1(i,:).PRAUC],[],6)';
    loggerMean1(i).PRAUC = mean(PRAUCi,1);
    loggerMean1(i).stdPRAUC = std(PRAUCi,0,1);
end
for i = 1:size(logger2,1)
    PRAUCi = reshape([logger2(i,:).PRAUC],[],6)';
    loggerMean2(i).PRAUC = mean(PRAUCi,1);
    loggerMean2(i).stdPRAUC = std(PRAUCi,0,1);
end

loggerMean1(22)
loggerMean2(11)
loggerMean2(12)
loggerMean2(13)
loggerMean2(14)
