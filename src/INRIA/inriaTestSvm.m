function [Lsvm,acc,prob,svmPath] = inriaTestSvm(n,k,method,svmArgs,desSave)

if nargin < 5
    desSave = true;
end

load('paths')

[~, mName] = parseMethod(method);
desDir = [inriaResults '/' mName];

if isempty(k)
    svmPath = [desDir '/svm_test_' svmArgs '.mat'];
else
    svmPath = [desDir '/svm_train-' num2str(k) 'of' num2str(n) '_' svmArgs '.mat'];
end
svmVars = {'svm','Lsvm','acc','prob','trainTime','predictTime','Ltrain','Ltest','n','k','ROC','PR','ROCAUC','PRAUC'};
[loaded,svmLoad] = loadIfExist(svmPath,'file');
if loaded && all(ismember(svmVars,fieldnames(svmLoad)))
    disp('Loaded svm file.')
    Lsvm = svmLoad.Lsvm;
    acc = svmLoad.acc;
    prob = svmLoad.prob;
else
    [Ltrain,Dtrain,Ltest,Dtest] = inriaData(n,k,method,desSave);

    %% Train and test SVM
    trainTime = tic;
    % -m cachesize (default 100)
    % -h shrinking (default 1)
    
%     svm = svmtrain(Ltrain,Dtrain,[svmArgs ' -m 500 -h 0']);
    svm = lineartrain(Ltrain,sparse(Dtrain),svmArgs);
    
    trainTime = toc(trainTime)
    predictTime = tic;
    
%     [Lsvm, acc, prob] = svmpredict(Ltest,Dtest,svm);
    [Lsvm, acc, prob] = linearpredict(Ltest,sparse(Dtest),svm);
    
    predictTime = toc(predictTime)

    %% Evaluation measures
    [ROC,PR] = confusionMeasure(Ltest,prob); ROC = flipud(ROC); PR = flipud(PR);
    ROCAUC = ROCarea(ROC','roc');
    PRAUC = ROCarea(PR','pr');

    if ~exist(desDir,'dir')
        mkdir(desDir);
    end
    save(svmPath,svmVars{:})
end

% plotInriaResults(svmPath);

end
