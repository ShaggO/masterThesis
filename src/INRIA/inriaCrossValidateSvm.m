function PRAUC = inriaCrossValidateSvm(data,nSplit,method,svmArgs,runInParallel)

desSave = true;
nMethod = numel(method);

PRAUC = zeros(nSplit,nMethod);
if runInParallel
    gcp;
    % pre-calculate descriptors
    parfor km = 1:nMethod
        data.getDescriptors(method(km),desSave,'posTrain');
        data.getDescriptors(method(km),desSave,'negTrainCutouts');
    end
    % iterate over splits and methods
    parfor k = 1:nSplit*nMethod
        [ks,km] = ind2sub([nSplit nMethod],k);
        [~,PRAUC(k)] = inriaValidateSvm(data,nSplit,ks,method(km),svmArgs,desSave);
    end
else
    % pre-calculate descriptors
    for km = 1:nMethod
        data.getDescriptors(method(km),desSave,'posTrain');
        data.getDescriptors(method(km),desSave,'negTrainCutouts');
    end
    % iterate over splits and methods
    for k = 1:nSplit*nMethod
        [ks,km] = ind2sub([nSplit nMethod],k);
        [~,PRAUC(k)] = inriaValidateSvm(data,nSplit,ks,method(km),svmArgs,desSave);
    end
end
PRAUC = mean(PRAUC,1);

end