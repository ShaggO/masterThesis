clc, clear all;

names = {'Go','Si'};
splits = 1:6;
for name = names
    diaryFile = ['optimizeParameter' name '_' strrep(datestr(now),':','-') '.out'];
    diary(diaryFile)
    disp(['Dense report results for optimal parameters of ' name]);

    % leave out one sixth as test, rest as train
    for split = splits
        setNumTrain = dtuSplitSets(6,splits(splits ~= split));
        setNumTest = dtuSplitSets(6,split);
        diary(diaryFile)
        disp('--------');
        disp(['Split: ' num2str(split) ' of ' nums2str(splits)]);
        disp('--------');
        diary off

        %% Default settings across optimization parameters
        load paths;
        paramFile = ['results/optimize/parameterStudyGo_' num2str(split) '-of-' num2str(numel(splits))];
        params = load(paramFile);
        params.loggerParameterResults = handler(emptyLogger);


        startTime = tic;

        %% Optimize the following parameters
        iters = 3;
        zoomOptimizeParameter(setNumTrain,params.method,params.diaryFile,params.loggerParameterResults,'gridRadius', ...
            (5:0.5:20)');

        zoomOptimizeParameter(setNumTrain,params.method,params.diaryFile,params.loggerParameterResults,'centerSigma', ...
            repmat((0.5:0.1:2)',[1 2]));

        zoomOptimizeParameter(setNumTrain,params.method,params.diaryFile,params.loggerParameterResults,'cellSigma', ...
            repmat((0.5:0.1:2)',[1 2]));

        zoomOptimizeParameter(setNumTrain,params.method,params.diaryFile,params.loggerParameterResults,'binSigma', ...
            (0.5:0.1:2)');
        zoomOptimizeParameter(setNumTrain,params.method,params.diaryFile,params.loggerParameterResults,'binCount', ...
            (4:16)');
        zoomOptimizeParameter(setNumTrain,params.method,params.diaryFile,params.loggerParameterResults,'normSigma', ...
            repmat((1:0.2:5)',[1 2]));

        save(paramFile,'-struct','params');

        %% Alpha and beta tests
        % Triangle and box alpha:
        methodAlphaTri = modifyDescriptor(params.method,'binFilter','triangle');
        methodAlphaBox = modifyDescriptor(params.method,'binFilter','box');

        % Triangle and box beta:
        methodBetaTri = modifyDescriptor(params.method,'cellFilter','triangle');
        methodBetaBox = modifyDescriptor(params.method,'cellFilter','box');

        % Run alpha and beta dense
        zoomOptimizeParameter(setNumTrain,methodAlphaTri,params.diaryFile,params.loggerParameterResults, ...
            'cellSigma', repmat((0.5:0.1:2)',[1 2]));
        zoomOptimizeParameter(setNumTrain,methodAlphaBox,params.diaryFile,params.loggerParameterResults, ...
            'cellSigma', repmat((0.5:0.1:2)',[1 2]));
        zoomOptimizeParameter(setNumTrain,methodBetaTri,params.diaryFile,params.loggerParameterResults, ...
            'binSigma', (0.5:0.1:2.5)');
        zoomOptimizeParameter(setNumTrain,methodBetaBox,params.diaryFile,params.loggerParameterResults, ...
            'binSigma', (0.5:0.1:2.5)');

        save(paramFile,'-struct','params');

        %% Additional parameter choice tests
        enumOptimizeParameter(setNumTrain,params.method,params.diaryFile,params.loggerParameterResults, ...
            'normType', {'pixel','none'});
        enumOptimizeParameter(setNumTrain,params.method,params.diaryFile,params.loggerParameterResults, ...
            'cellNormStrategy', {0,3});
        enumOptimizeParameter(setNumTrain,params.method,params.diaryFile,params.loggerParameterResults, ...
            'rescale', {0.5,1});
        enumOptimizeParameter(setNumTrain,params.method,params.diaryFile,params.loggerParameterResults, ...
            'colour', {'gray','none','opponent','c-colour'});
        save(paramFile,'-struct','params');
    end
end
