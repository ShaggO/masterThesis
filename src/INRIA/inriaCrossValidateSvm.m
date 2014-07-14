function [PRAUC, dims] = inriaCrossValidateSvm(data,nSplit,method,svmArgs,runInParallel)

desSave = true;
nMethod = numel(method);

PRAUC = zeros(nSplit,nMethod);
dims = zeros(1,nMethod);
% pre-calculate descriptors
for km = 1:nMethod
    [~,D,~] = data.getDescriptors(method(km),desSave,'posTrain','all',true);
    data.getDescriptors(method(km),desSave,'negTrainCutouts','all',true);
    dims(km) = size(D,2);
end

if runInParallel && all(dims < 12600)
    gcp;
    % iterate over splits and methods
    parfor k = 1:nSplit*nMethod
        [ks,km] = ind2sub([nSplit nMethod],k);
        [~,PRAUC(k)] = inriaValidateSvm(data,nSplit,ks,method(km),svmArgs,desSave);
    end
else
    % iterate over splits and methods
    for k = 1:nSplit*nMethod
        [ks,km] = ind2sub([nSplit nMethod],k);
        [~,PRAUC(k)] = inriaValidateSvm(data,nSplit,ks,method(km),svmArgs,desSave);
    end
end
PRAUC = mean(PRAUC,1);

end
