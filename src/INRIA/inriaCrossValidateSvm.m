function [PRAUC, dims] = inriaCrossValidateSvm(data,nSplit,method,svmArgs,runInParallel)

desSave = true;
nMethod = numel(method);

PRAUC = zeros(nSplit,nMethod);
dims = zeros(1,nMethod);

switch class(svmArgs)

    case 'char'
        svmArgsString = svmArgs;
    case 'struct'
        svmArgsString = svmArgs2string(svmArgs);
    otherwise
        error('svmArgs must be string or struct.')
end

load('paths');
allExist = true;
for k = 1:nSplit*nMethod
    [ks,km] = ind2sub([nSplit nMethod],k);
    [~, mName] = parseMethod(method(km));
    desDir = [inriaResults '/' mName];
    svmPath = [desDir '/svm_validate_' num2str(ks) 'of' num2str(nSplit) '_' svmArgsString '_' num2str(data.nWindows) '_' num2str(data.seed) '.mat'];
    svmVars = {'prob','Ltest','ROC','PR','ROCAUC','PRAUC'};
    [loaded,svmLoad] = loadIfExist(svmPath,'file');
    if ~(loaded && all(ismember(svmVars,fieldnames(svmLoad))))
        allExist = false;
        break;
    end
end

% pre-calculate descriptors
if ~allExist
    for km = 1:nMethod
        [~,D,~] = data.getDescriptors(method(km),desSave,'posTrain','all',true);
        data.getDescriptors(method(km),desSave,'negTrainCutouts','all',true);
        dims(km) = size(D,2);
    end
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
