function [Lsvm, acc, P] = inriaTest(method,desSave)

if nargin < 2
    desSave = false;
end

load('paths')
load([inriaDataSet '/inriaTrain'])
load([inriaDataSet '/inriaTest'])

[mFunc, mName] = parseMethod(method);

desPath = [inriaResults '/descriptors_' mName '.mat'];
desVars = {'DposTrain','LposTrain','DnegTrain','LnegTrain','DposTest','LposTest','DnegTest','LnegTest'};
[loaded,desLoad] = loadIfExist(desPath,'file');
if loaded && all(ismember(desVars,fieldnames(desLoad)))
    DposTrain = desLoad.DposTrain;
    LposTrain = desLoad.LposTrain;
    DnegTrain = desLoad.DnegTrain;
    LnegTrain = desLoad.LnegTrain;
    DposTest = desLoad.DposTest;
    LposTest = desLoad.LposTest;
    DnegTest = desLoad.DnegTest;
    LnegTest = desLoad.LnegTest;
    disp('Descriptors loaded');
else
    %% Compute descriptors
    DposTrain = inriaDescriptors(posTrain,mFunc);
    LposTrain = ones(numel(posTrain),1);
    DnegTrain = inriaDescriptors(negTrain,mFunc);
    LnegTrain = -ones(numel(negTrain),1);
    DposTest = inriaDescriptors(posTest,mFunc);
    LposTest = ones(numel(posTest),1);
    DnegTest = inriaDescriptors(negTest,mFunc);
    LnegTest = -ones(numel(negTest),1);
    
    if desSave
        save(desPath,desVars{:})
    end
end

%% Train and test SVM
svm = svmtrain([LposTrain; LnegTrain],[DposTrain; DnegTrain],'-h 0');
[Lsvm, acc, P] = svmpredict([LposTest; LnegTest],[DposTest; DnegTest],svm);

end