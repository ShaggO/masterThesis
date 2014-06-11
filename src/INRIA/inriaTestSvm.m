function svmPath = inriaTestSvm(method,svmArgs,desSave)

if nargin < 3
    desSave = true;
end

runInParallel = true;

load('paths')
load([inriaDataSet '/inriaMetadata'])

[~, mName] = parseMethod(method);
desDir = [inriaResults '/' mName];

svmPath = [desDir '/svm_test_' svmArgs2string(svmArgs) '.mat'];
svmVars = {'probPos','probNeg','ROC','PR','ROCAUC','PRAUC'};
[loaded,svmLoad] = loadIfExist(svmPath,'file');
if loaded && all(ismember(svmVars,fieldnames(svmLoad)))
    disp('Loaded svm file.')
else
    diaryFile = [desDir '/inriaTestSvm_' strrep(datestr(now),':','-') '.out'];
    
    % INRIA data wrapper
    data = inriaData;
    
    tic
    
    %% Initial training
    [LposTrain,DposTrain] = data.getDescriptors(method,desSave,'posTrain','all',runInParallel);
    DposTrain = sparse(double(DposTrain));
    [LnegTrainCutouts,DnegTrainCutouts] = ...
        data.getDescriptors(method,desSave,'negTrainCutouts','all',runInParallel);
    DnegTrainCutouts = sparse(double(DnegTrainCutouts));
    ratio = numel(LnegTrainCutouts) / numel(LposTrain);
    svm = lineartrain([LposTrain; LnegTrainCutouts], ...
        [DposTrain; DnegTrainCutouts],[svmArgs2string(svmArgs) ' -w1 ' num2str(ratio)]);
    % svm = svmtrain(L,D,[svmArgs ' -m 500 -h 0']);
    diary(diaryFile)
    disp([timestamp() ' Initial training done.'])
    diary off
    
    %% Add hard negative training data
    DnegTrainHard = sparse(0,0);
    totalNegTrain = 0;
    for i = 1:nNegTrainFull
        [LnegTrainFull,DnegTrainFull] = ...
            data.getDescriptors(method,desSave,'negTrainFull',i,false);
        DnegTrainFull = sparse(double(DnegTrainFull));
        totalNegTrain = totalNegTrain + size(DnegTrainFull,1);
        
        Lsvm = linearpredict(LnegTrainFull,DnegTrainFull,svm);
        DnegTrainHard = [DnegTrainHard; DnegTrainFull(Lsvm == 1,:)];
    end
    LnegTrainHard = -ones(size(DnegTrainHard,1),1);
    diary(diaryFile)
    disp([timestamp() ' Classified negative training data: ' num2str(size(DnegTrainHard,1)) ' hard negatives out of ' num2str(totalNegTrain) '.'])
    diary off
    
    %% Retraining with hard negatives
    ratio = (numel(LnegTrainCutouts) + numel(LnegTrainHard)) / numel(LposTrain);
    svm = lineartrain([LposTrain; LnegTrainCutouts; LnegTrainHard], ...
        [DposTrain; DnegTrainCutouts; DnegTrainHard],[svmArgs2string(svmArgs) ' -w1 ' num2str(ratio)]);
    diary(diaryFile)
    disp([timestamp() ' Retraining done.'])
    diary off
    
    %% Test on positive test data
    [LposTest,DposTest] = data.getDescriptors(method,desSave,'posTest','all',runInParallel);
    DposTest = sparse(double(DposTest));
    [~,acc,probPos] = linearpredict(LposTest,DposTest,svm);
    diary(diaryFile)
    disp([timestamp() ' Classified positive test data: ' num2str(sum(probPos >= 0)/numel(probPos)) ' accuracy.'])
    diary off
    
    %% Test on negative test data
    probNeg = [];
    totalNegTest = 0;
    for i = 1:nNegTestFull
        [LnegTestFull,DnegTestFull] = ...
            data.getDescriptors(method,desSave,'negTestFull',i,false);
        DnegTestFull = sparse(double(DnegTestFull));
        totalNegTest = totalNegTest + size(DnegTestFull,1);
        
        [~,~,probNegi] = linearpredict(LnegTestFull,DnegTestFull,svm);
        probNeg = [probNeg; probNegi];
    end
    LnegTest = -ones(numel(probNeg),1);
    diary(diaryFile)
    disp([timestamp() ' Classified negative test data: ' num2str(sum(probNeg < 0)/numel(probNeg)) ' accuracy.'])
    diary off

    %% Evaluation measures
    [ROC,PR] = confusionMeasure([LposTest; LnegTest],[probPos; probNeg]);
    ROC = flipud(ROC); PR = flipud(PR);
    ROCAUC = ROCarea(ROC','roc');
    PRAUC = ROCarea(PR','pr');
    diary(diaryFile)
    disp([timestamp() ' Computed ROC AUC: ' num2str(ROCAUC)])
    diary off

    if ~exist(desDir,'dir')
        mkdir(desDir);
    end
    save(svmPath,svmVars{:})
end

% plotInriaResults(svmPath);

end
