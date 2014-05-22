function [Lsvm, acc, prob] = inriaTest(n,k,method,svmArgs,desSave)

if nargin < 7
    desSave = false;
end

load('paths')
load([inriaDataSet '/inriaTrain'])
load([inriaDataSet '/inriaTest'])

[mFunc, mName] = parseMethod(method);

%% Training descriptors
desDir = [inriaResults '/' mName];
desPath = [desDir '/Dtrain.mat'];
desVars = {'DposTrain','LposTrain','DnegTrain','LnegTrain'};
[loaded,desLoad] = loadIfExist(desPath,'file');
if loaded && all(ismember(desVars,fieldnames(desLoad)))
    DposTrain = desLoad.DposTrain;
    LposTrain = desLoad.LposTrain;
    DnegTrain = desLoad.DnegTrain;
    LnegTrain = desLoad.LnegTrain;
    disp('Training descriptors loaded.');
else
    DposTrain = inriaDescriptors(posTrain,mFunc);
    LposTrain = ones(numel(posTrain),1);
    DnegTrain = inriaDescriptors(negTrain,mFunc);
    LnegTrain = -ones(numel(negTrain),1);
    
    if desSave
        if ~exist(desDir,'dir')
            mkdir(desDir);
        end
        save(desPath,desVars{:})
    end
end

%% Testing descriptors
if isempty(k)
    desPath = [desDir '/Dtest.mat'];
    desVars = {'DposTest','LposTest','DnegTest','LnegTest'};
    [loaded,desLoad] = loadIfExist(desPath,'file');
    if loaded && all(ismember(desVars,fieldnames(desLoad)))
        DposTest = desLoad.DposTest;
        LposTest = desLoad.LposTest;
        DnegTest = desLoad.DnegTest;
        LnegTest = desLoad.LnegTest;
        disp('Testing descriptors loaded.');
    else
        DposTest = inriaDescriptors(posTest,mFunc);
        LposTest = ones(numel(posTest),1);
        DnegTest = inriaDescriptors(negTest,mFunc);
        LnegTest = -ones(numel(negTest),1);
        
        if desSave
            if ~exist(desDir,'dir')
                mkdir(desDir);
            end
            save(desPath,desVars{:})
        end
    end
    
    % use original training/test data
    Dtrain = [DposTrain; DnegTrain];
    Ltrain = [LposTrain; LnegTrain];
    Dtest = [DposTest; DnegTest];
    Ltest = [LposTest; LnegTest];
else
    % split training data into training/validation
    [SposTrain, SnegTrain, SposTest, SnegTest] = inriaSplit(n,k);
    Dtrain = [DposTrain(SposTrain,:); DnegTrain(SnegTrain,:)];
    Ltrain = [LposTrain(SposTrain); LnegTrain(SnegTrain)];
    Dtest = [DposTrain(SposTest,:); DnegTrain(SnegTest,:)];
    Ltest = [LposTrain(SposTest); LnegTrain(SnegTest)];
end

%% Train and test SVM
if isempty(k)
    svmPath = [desDir '/svm_test_' svmArgs '.mat'];
else
    svmPath = [desDir '/svm_train-' num2str(k) 'of' num2str(n) '_' svmArgs '.mat'];
end
svmVars = {'svm','Lsvm','acc','prob','trainTime','predictTime'};
[loaded,svmLoad] = loadIfExist(svmPath,'file');
if loaded && all(ismember(svmVars,fieldnames(svmLoad)))
    disp('Loaded svm file.')
    return
else
    trainTime = tic;
    svm = svmtrain(Ltrain,Dtrain,svmArgs);
    trainTime = toc(trainTime)
    predictTime = tic;
    [Lsvm, acc, prob] = svmpredict(Ltest,Dtest,svm);
    predictTime = toc(predictTime)
    
    if ~exist(desDir,'dir')
        mkdir(desDir);
    end
    save(svmPath,svmVars{:})
end

end