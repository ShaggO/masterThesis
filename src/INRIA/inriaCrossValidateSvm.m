function PRAUC = inriaCrossValidateSvm(data,nSplit,method,svmArgs,runInParallel)

desSave = true;
nMethod = numel(method);

PRAUC = zeros(nSplit,nMethod);
% pre-calculate descriptors
for km = 1:nMethod
    data.getDescriptors(method(km),desSave,'posTrain','all',runInParallel);
    data.getDescriptors(method(km),desSave,'negTrainCutouts','all',runInParallel);
end

if runInParallel
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
