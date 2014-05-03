clear all; clc;
diaryFile = 'optimizeParameterGo.out';
diary(diaryFile)
disp('Optimization of parameters for GO started.');

% leave out 1st sixth
setNum = dtuSplitSets(6,2:6);

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
   'gridType','concentric polar',...
   'gridSize',[12 2],...
   'gridRadius',10,...
   'centerFilter','gaussian',...
   'centerSigma',[1.5 1.5],...
   'cellFilter','polar gaussian',...
   'cellSigma',[1 1],...
   'normType','pixel',...
   'normSigma',[2 2],...
   'binSigma',1.2,...
   'binCount',8,...
   'cellNormStrategy',0},...
   matchCache,{'co-'});

%% Grid optimization
gs = [24 1; 20 1; 16 1; 12 1; 8 1; ...
    12 2; 10 2; 8 2; 6 2; ...
    8 3; 6 3; 6 4];
n = size(gs,1);
gsRings = gs(gs(:,2) > 1,:);
nRings = size(gsRings,1);

gridTypes = {};
gridSizes = {};
cellFilters = {};

% polar grid, polar gaussian filter
idx = numel(gridTypes) + (1:nRings);
gridTypes(idx) = {'polar'};
gridSizes(idx) = mat2cell(gsRings,ones(nRings,1),2);
cellFilters(idx) = {'polar gaussian'};

% concentric polar grid, polar gaussian filter
idx = numel(gridTypes) + (1:nRings);
gridTypes(idx) = {'concentric polar'};
gridSizes(idx) = mat2cell(gsRings,ones(nRings,1),2);
cellFilters(idx) = {'polar gaussian'};

% polar central grid, polar gaussian filter
idx = numel(gridTypes) + (1:n);
gridTypes(idx) = {'polar central'};
gridSizes(idx) = mat2cell(gs,ones(n,1),2);
cellFilters(idx) = {'polar gaussian'};

% concentric polar central grid, polar gaussian filter
idx = numel(gridTypes) + (1:nRings);
gridTypes(idx) = {'concentric polar central'};
gridSizes(idx) = mat2cell(gsRings,ones(nRings,1),2);
cellFilters(idx) = {'polar gaussian'};

% log-polar grid, polar gaussian filter
idx = numel(gridTypes) + (1:n);
gridTypes(idx) = {'log-polar'};
gridSizes(idx) = mat2cell(gs,ones(n,1),2);
cellFilters(idx) = {'polar gaussian'};

% log-polar grid, gaussian filter
idx = numel(gridTypes) + (1:n);
gridTypes(idx) = {'log-polar'};
gridSizes(idx) = mat2cell(gs,ones(n,1),2);
cellFilters(idx) = {'gaussian'};

disp(['Total number of grid parameters to test: ' num2str(numel(gridTypes))]);
diary off

startTime = tic;

%% Optimize the following parameters
iters = 3;
for i = 1:iters
    diary(diaryFile)
    disp([timestamp(startTime) ' Iteration ' num2str(i) '/' num2str(iters)]);
    diary off
    method = enumOptimizeParameter(setNum,method,diaryFile,'gridType',gridTypes,'gridSize',gridSizes,'cellFilter',cellFilters);
    method = zoomOptimizeParameter(setNum,method,diaryFile,'gridRadius', ...
        (2.5:2.5:20)',(-1:0.5:1)');
    method = modifyDescriptor(method,'centerFilter','gaussian');
    method = zoomOptimizeParameter(setNum,method,diaryFile,'centerSigma', ...
        repmat((0.5:0.5:2)',[1 2]),repmat((-0.2:0.1:0.2)',[1 2]));
    method = enumOptimizeParameter(setNum,method,diaryFile,'centerFilter',{'gaussian','none'});
    method = zoomOptimizeParameter(setNum,method,diaryFile,'cellSigma', ...
        repmat((0.5:0.5:2)',[1 2]),repmat((-0.2:0.1:0.2)',[1 2]));
    method = zoomOptimizeParameter(setNum,method,diaryFile,'binSigma', ...
        (0.5:0.5:2)',(-0.2:0.1:0.2)');
    method = zoomOptimizeParameter(setNum,method,diaryFile,'binCount', ...
        (4:2:16)');
    method = zoomOptimizeParameter(setNum,method,diaryFile,'normSigma', ...
        repmat((1:5)',[1 2]),repmat((-0.4:0.2:0.4)',[1 2]));
end
diary(diaryFile)
totalTime = timestamp(startTime)
method.descriptorArgs
diary off
