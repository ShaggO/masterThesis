function [svmPath, PRAUC] = inriaValidateSvm(data,n,k,method,svmArgs,desSave)

if nargin < 3
    desSave = true;
end

switch class(svmArgs)
    case 'char'
    case 'struct'
        svmArgs = svmArgs2string(svmArgs);
    otherwise
        error('svmArgs must be string or struct.')
end

load('paths')
load([inriaDataSet '/inriaMetadata'])

[~, mName] = parseMethod(method);
desDir = [inriaResults '/' mName];

svmPath = [desDir '/svm_validate_' num2str(k) 'of' num2str(n) '_' svmArgs '.mat'];
svmVars = {'prob','Ltest','ROC','PR','ROCAUC','PRAUC'};
[loaded,svmLoad] = loadIfExist(svmPath,'file');
if loaded && all(ismember(svmVars,fieldnames(svmLoad)))
    disp('Loaded svm file.')
    PRAUC = svmLoad.PRAUC;
else
    tic
    
    %% Load training data
    [LposTrain,DposTrain] = data.getDescriptors(method,desSave,'posTrain');
    DposTrain = sparse(double(DposTrain));
    [LnegTrainCutouts,DnegTrainCutouts] = ...
        data.getDescriptors(method,desSave,'negTrainCutouts');
    DnegTrainCutouts = sparse(double(DnegTrainCutouts));
    
    %% Split training data into training/validation
    [SposTrain, SnegTrain, SposTest, SnegTest] = inriaSplit(n,k,data.nWindows);
    Dtrain = [DposTrain(SposTrain,:); DnegTrainCutouts(SnegTrain,:)];
    Ltrain = [LposTrain(SposTrain); LnegTrainCutouts(SnegTrain)];
    Dtest = [DposTrain(SposTest,:); DnegTrainCutouts(SnegTest,:)];
    Ltest = [LposTrain(SposTest); LnegTrainCutouts(SnegTest)];
    
    %% Training
    ratio = numel(SnegTrain) / numel(SposTrain);
    svm = lineartrain(Ltrain,Dtrain,[svmArgs ' -w1 ' num2str(ratio)]);
    disp([timestamp() ' Training done.'])
    
    %% Test
    [~,~,prob] = linearpredict(Ltest,Dtest,svm);
    disp([timestamp() ' Classified data.'])

    %% Evaluation measures
    [ROC,PR] = confusionMeasure(Ltest,prob);
    ROC = flipud(ROC); PR = flipud(PR);
    ROCAUC = ROCarea(ROC','roc');
    PRAUC = ROCarea(PR','pr');
    disp([timestamp() ' Computed ROC AUC: ' num2str(ROCAUC) ', PR AUC: ' num2str(PRAUC)])

    if ~exist(desDir,'dir')
        mkdir(desDir);
    end
    save(svmPath,svmVars{:})
end

% plotInriaResults(svmPath);

end