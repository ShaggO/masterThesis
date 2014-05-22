function [Lsvm, acc, P] = inriaTest(n,k,method,svmArgs,desSave)

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
    disp('Training descriptors loaded');
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
        disp('Testing descriptors loaded');
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
    
    Dtrain = [DposTrain; DnegTrain];
    Ltrain = [LposTrain; LnegTrain];
    Dtest = [DposTest; DnegTest];
    Ltest = [LposTest; LnegTest];
else
    [SposTrain, SnegTrain, SposTest, SnegTest] = inriaSplit(n,k);
    Dtrain = [DposTrain(SposTrain); DnegTrain(SnegTrain)];
    Ltrain = [DposTrain(SposTrain); DnegTrain(SnegTrain)];
    Dtest = [DposTrain(SposTest); DnegTrain(SnegTest)];
    Ltest = [DposTrain(SposTest); DnegTrain(SnegTest)];
end

%% Train and test SVM
svm = svmtrain(Ltrain,Dtrain,svmArgs);
[Lsvm, acc, P] = svmpredict(Ltest,Dtest,svm);

end