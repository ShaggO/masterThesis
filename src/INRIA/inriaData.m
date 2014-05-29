function [Ltrain,Dtrain,Ltest,Dtest] = inriaData(n,k,method,desSave)

if nargin < 4
    desSave = true;
end

load('paths')

load([inriaDataSet '/inriaTrain'])
load([inriaDataSet '/inriaTest'])
    
[mFunc, mName] = parseMethod(method);
desDir = [inriaResults '/' mName];

%% Training descriptors
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

end