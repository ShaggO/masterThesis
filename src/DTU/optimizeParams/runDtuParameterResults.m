clc, clear all;

names = {'Go','Si'};
names = {'Si'};
splits = 1:6;
for j = 1:numel(names)
    % leave out one sixth as test, rest as train
    for split = splits

        %% Default settings across optimization parameters
        paramFile = ['results/optimize/parameterStudy' names{j} '_' num2str(split) '-of-' num2str(numel(splits))];
        params = load(paramFile);

        setNumTrain = dtuSplitSets(6,splits(splits ~= split));
        setNumTest = dtuSplitSets(6,split);
        diary(params.diaryFile)
        disp('--------');
        disp(['Split: ' num2str(split) ' of ' nums2str(splits)]);
        disp('--------');
        diary off

        params.loggerParameterResults = handler(emptyLogger);


        startTime = tic;

        %% Optimize the following parameters
        iters = 3;
        zoomOptimizeParameter(setNumTrain,params.method,params.diaryFile,params.loggerParameterResults,'gridRadius', ...
            (5:0.5:20)');

        zoomOptimizeParameter(setNumTrain,params.method,params.diaryFile,params.loggerParameterResults,'centerSigma', ...
            repmat((0.5:0.1:3)',[1 2]));

        zoomOptimizeParameter(setNumTrain,params.method,params.diaryFile,params.loggerParameterResults,'cellSigma', ...
            repmat((0.5:0.1:3)',[1 2]));

        zoomOptimizeParameter(setNumTrain,params.method,params.diaryFile,params.loggerParameterResults,'binSigma', ...
            (0.5:0.1:3.5)');
        zoomOptimizeParameter(setNumTrain,params.method,params.diaryFile,params.loggerParameterResults,'binCount', ...
            (4:16)');
        zoomOptimizeParameter(setNumTrain,params.method,params.diaryFile,params.loggerParameterResults,'normSigma', ...
            repmat((1:0.2:5)',[1 2]));

        save(paramFile,'-struct','params');

        %% Alpha and beta tests
        % Triangle and box alpha:
        methodAlphaTri = modifyDescriptor(params.method,'cellFilter','polar triangle');
        methodAlphaBox = modifyDescriptor(params.method,'cellFilter','polar box');

        % Triangle and box beta:
        methodBetaTri = modifyDescriptor(params.method,'binFilter','triangle');
        methodBetaBox = modifyDescriptor(params.method,'binFilter','box');

        % Run alpha and beta dense
        zoomOptimizeParameter(setNumTrain,methodAlphaTri,params.diaryFile,params.loggerParameterResults, ...
            'cellSigma', repmat((0.5:0.1:3)',[1 2]));
        zoomOptimizeParameter(setNumTrain,methodAlphaBox,params.diaryFile,params.loggerParameterResults, ...
            'cellSigma', repmat((0.5:0.1:3)',[1 2]));
        zoomOptimizeParameter(setNumTrain,methodBetaTri,params.diaryFile,params.loggerParameterResults, ...
            'binSigma', (0.5:0.1:3.5)');
        zoomOptimizeParameter(setNumTrain,methodBetaBox,params.diaryFile,params.loggerParameterResults, ...
            'binSigma', (0.5:0.1:3.5)');

        save(paramFile,'-struct','params');

        %% Additional parameter choice tests
        enumOptimizeParameter(setNumTrain,params.method,params.diaryFile,params.loggerParameterResults, ...
            'normType', {'pixel','none'});
        enumOptimizeParameter(setNumTrain,params.method,params.diaryFile,params.loggerParameterResults, ...
            'cellNormStrategy', {0,4});
        enumOptimizeParameter(setNumTrain,params.method,params.diaryFile,params.loggerParameterResults, ...
            'rescale', {0.5,1});
        enumOptimizeParameter(setNumTrain,params.method,params.diaryFile,params.loggerParameterResults, ...
            'colour', {'gray','none','opponent','c-colour'});
        save(paramFile,'-struct','params');
    end
end
