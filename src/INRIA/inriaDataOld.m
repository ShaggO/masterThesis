function [L,D] = inriaDataOld(method,desSave,type,index)

if nargin < 4
    index = 'all';
end

load('paths')
    
[mFunc, mName] = parseMethod(method);
desDir = [inriaResults '/' mName];

if desSave
    if ~exist(desDir,'dir')
        mkdir(desDir);
    end
end

if strcmp(index,'all')
    s = 'all';
else
    s = sprintf('%.4d',index);
end

switch type
    case 'posTrain'
        desPath = [desDir '/DposTrain_' s '.mat'];
        imgPath = [inriaDataSet '/inriaPosTrain'];
        L = 1;
    case 'negTrainCutouts'
        desPath = [desDir '/DnegTrainCutouts_' s '.mat'];
        imgPath = [inriaDataSet '/inriaNegTrainCutouts'];
        L = -1;
    case 'negTrainFull'
        desPath = [desDir '/DnegTrainFull_' s '.mat'];
        imgPath = [inriaDataSet '/inriaNegTrainFull'];
        L = -1;
    case 'posTest'
        desPath = [desDir '/DposTest_' s '.mat'];
        imgPath = [inriaDataSet '/inriaPosTest'];
        L = 1;
    case 'negTestCutouts'
        desPath = [desDir '/DnegTestCutouts_' s '.mat'];
        imgPath = [inriaDataSet '/inriaNegTestCutouts'];
        L = -1;
    case 'negTestFull'
        desPath = [desDir '/DnegTestFull_' s '.mat'];
        imgPath = [inriaDataSet '/inriaNegTestFull'];
        L = -1;
end
    
desVars = {'D'};
[loaded,desLoad] = loadIfExist(desPath,'file');
if loaded && all(ismember(desVars,fieldnames(desLoad)))
    D = desLoad.D;
    disp([num2str(size(D,1)) ' descriptors loaded.']);
else
    load(imgPath)
    if strcmp(index,'all')
        D = inriaDescriptors(images,mFunc);
    else
        D = inriaDescriptors(images(index),mFunc);
    end
    if desSave
        save(desPath,desVars{:})
    end
end

L = repmat(L,size(D,1),1);

%     % split training data into training/validation
%     [SposTrain, SnegTrain, SposTest, SnegTest] = inriaSplit(n,k);
%     Dtrain = [DposTrain(SposTrain,:); DnegTrain(SnegTrain,:)];
%     Ltrain = [ones(numel(SposTrain),1); -ones(numel(SnegTrain),1)];
%     Dtest = [DposTrain(SposTest,:); DnegTrain(SnegTest,:)];
%     Ltest = [ones(numel(SposTest),1); -ones(numel(SnegTest),1)];

end