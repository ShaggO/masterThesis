function [ROCAUC, knnPath] = inriaTestKnn(n,k,method,desSave,neighbours)

if nargin < 5
    desSave = true;
end

load('paths')

[~, mName] = parseMethod(method);
desDir = [inriaResults '/' mName];

if isempty(k)
    knnPath = [desDir '/knn_test_' svmArgs '.mat'];
else
    knnPath = [desDir '/knn_train-' num2str(k) 'of' num2str(n) '_' num2str(neighbours) '.mat'];
end
knnVars = {'ratio','knnTime','Ltrain','Ltest','n','k','ROC','PR','ROCAUC','PRAUC'};
[loaded,knnLoad] = loadIfExist(knnPath,'file');
if loaded && all(ismember(knnVars,fieldnames(knnLoad)))
    disp('Loaded k-NN file.')
    ROCAUC = knnLoad.ROCAUC;
else
    [Ltrain,Dtrain,Ltest,Dtest] = inriaData(n,k,method,desSave);

    %% k-NN and ROC
    knnTime = tic;
    ratio = knn(neighbours,Ltrain,Dtrain,Dtest);
    knnTime = toc(knnTime)
    [ROC,PR] = confusionMeasure(Ltest,ratio); ROC = flipud(ROC); PR = flipud(PR);
    ROCAUC = ROCarea(ROC','roc');
    PRAUC = ROCarea(PR','pr');
    
    save(knnPath,knnVars{:})
end

% plotInriaResults(knnPath)

end