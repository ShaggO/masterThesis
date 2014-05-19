function [Lsvm, acc, P] = inriaTest(method)

load('paths')
load([inriaDataSet '/inriaTrain'])
load([inriaDataSet '/inriaTest'])

[mFunc, ~] = parseMethod(method);

%% Compute descriptors
DposTrain = inriaDescriptors(posTrain,mFunc);
LposTrain = ones(numel(posTrain),1);
DnegTrain = inriaDescriptors(negTrain,mFunc);
LnegTrain = -ones(numel(negTrain),1);
DposTest = inriaDescriptors(posTest,mFunc);
LposTest = ones(numel(posTest),1);
DnegTest = inriaDescriptors(negTest,mFunc);
LnegTest = -ones(numel(negTest),1);

%% Train and test SVM
svm = svmtrain([LposTrain; LnegTrain],[DposTrain; DnegTrain]);
[Lsvm, acc, P] = svmpredict([LposTest; LnegTest],[DposTest; DnegTest],svm);

end