clear all; clc;
diaryFile = ['optimizeParameterGo_' strrep(datestr(now),':','-') '.out'];
diary(diaryFile)
disp('Optimization of parameters for GO started.');

% leave out one sixth as test, rest as train
for split = 1:6
    splits = 1:6;
    setNumTrain = dtuSplitSets(6,splits(splits ~= split));
    setNumTest = dtuSplitSets(6,split);
    diary(diaryFile)
    disp('--------');
    disp(['Split: ' num2str(split) ' of ' nums2str(splits)]);
    disp('--------');
    diary off

    %% Default settings across optimization parameters
    peakThresholdDog = 6.5;
    peakThresholdHarris = 10^4;
    matchCache = true;

    method = methodStruct( ...
        'vl',{'method','dog','peakthreshold',peakThresholdDog,'cache',1}, ...
       'cellhist',{...
       'colour','gray',...
       'contentType','go',...
       'magnitudeType','m',...
       'rescale',1/2,...
       'gridType','polar central',...
       'gridSize',[12 2],...
       'gridRadius',12.5,...
       'centerFilter','gaussian',...
       'centerSigma',[1.3 1.3],...
       'cellFilter','polar gaussian',...
       'cellSigma',[0.9 0.9],...
       'normType','pixel',...
       'normSigma',[1.6 1.6],...
       'binSigma',1.3,...
       'binCount',12,...
       'cellNormStrategy',0},...
       matchCache,{'co-'});

    %% Grid optimization
    gs = [12 2; 10 2; 8 2; 6 2; ...
        8 3; 6 3; 6 4];
    n = size(gs,1);
    gsLog = gs(gs(:,2) < 3,:);
    nLog = size(gsLog,1);

    gridTypes = {};
    gridSizes = {};
    cellFilters = {};

    % polar grid, polar gaussian filter
    idx = numel(gridTypes) + (1:n);
    gridTypes(idx) = {'polar'};
    gridSizes(idx) = mat2cell(gs,ones(n,1),2);
    cellFilters(idx) = {'polar gaussian'};

    % concentric polar grid, polar gaussian filter
    idx = numel(gridTypes) + (1:n);
    gridTypes(idx) = {'concentric polar'};
    gridSizes(idx) = mat2cell(gs,ones(n,1),2);
    cellFilters(idx) = {'polar gaussian'};

    % polar central grid, polar gaussian filter
    idx = numel(gridTypes) + (1:n);
    gridTypes(idx) = {'polar central'};
    gridSizes(idx) = mat2cell(gs,ones(n,1),2);
    cellFilters(idx) = {'polar gaussian'};

    % concentric polar central grid, polar gaussian filter
    idx = numel(gridTypes) + (1:n);
    gridTypes(idx) = {'concentric polar central'};
    gridSizes(idx) = mat2cell(gs,ones(n,1),2);
    cellFilters(idx) = {'polar gaussian'};

    % log-polar grid, gaussian filter
    idx = numel(gridTypes) + (1:nLog);
    gridTypes(idx) = {'log-polar'};
    gridSizes(idx) = mat2cell(gsLog,ones(nLog,1),2);
    cellFilters(idx) = {'gaussian'};

    % concentric log-polar grid, gaussian filter
    idx = numel(gridTypes) + (1:nLog);
    gridTypes(idx) = {'concentric log-polar'};
    gridSizes(idx) = mat2cell(gsLog,ones(nLog,1),2);
    cellFilters(idx) = {'gaussian'};

    diary(diaryFile)
    disp(['Total number of grid parameters to test: ' num2str(numel(gridTypes))]);
    diary off

    startTime = tic;

    %% Optimize the following parameters
    iters = 3;
    for i = 1:iters
        diary(diaryFile)
        disp([timestamp(startTime) ' Optimizing grid layout (iteration ' num2str(i) '/' num2str(iters) '):']);
        diary off
        method = enumOptimizeParameter(setNumTrain,method,diaryFile,'gridType',gridTypes,'gridSize',gridSizes,'cellFilter',cellFilters);
        method = zoomOptimizeParameter(setNumTrain,method,diaryFile,'gridRadius', ...
            (5:2.5:20)',(-1:0.5:1)');
        method = modifyDescriptor(method,'centerFilter','gaussian');
        method = zoomOptimizeParameter(setNumTrain,method,diaryFile,'centerSigma', ...
            repmat((0.5:0.5:2)',[1 2]),repmat((-0.2:0.1:0.2)',[1 2]));
        method = enumOptimizeParameter(setNumTrain,method,diaryFile,'centerFilter',{'gaussian','none'});
        method = zoomOptimizeParameter(setNumTrain,method,diaryFile,'cellSigma', ...
            repmat((0.5:0.5:2)',[1 2]),repmat((-0.2:0.1:0.2)',[1 2]));
    end
    diary(diaryFile)
    disp([timestamp(startTime) ' Optimizing other parameters: ']);
    diary off
    method = zoomOptimizeParameter(setNumTrain,method,diaryFile,'binSigma', ...
        (0.5:0.5:2)',(-0.2:0.1:0.2)');
    method = zoomOptimizeParameter(setNumTrain,method,diaryFile,'binCount', ...
        (4:2:16)');
    method = zoomOptimizeParameter(setNumTrain,method,diaryFile,'normSigma', ...
        repmat((1:5)',[1 2]),repmat((-0.4:0.2:0.4)',[1 2]));
    diary(diaryFile)
    totalTime = timestamp(startTime)
    method.descriptorArgs
    disp([timestamp(startTime) ' Computing test results:']);
    diary off

    %% Test with optimal parameters
    [testROCAUC, testPRAUC] = dtuTest(setNumTest,method,1:6,false,true,'test');
    load paths;
    optDir = [dtuResults '/optimize'];
    if ~exist(optDir,'dir')
        mkdir(optDir);
    end
    save([optDir '/parameterStudyGo_' num2str(split) '-of-' num2str(numel(splits))]);
end
