clear all; clc;
diary optimizeParameter.out
disp('Optimization of parameters started');

setNum = dtuSplitSets(10,1);

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
   'gridSize',[8 3],...
   'gridRadius',10,...
   'centerFilter','gaussian',...
   'centerSigma',[2 2],...
   'cellFilter','gaussian',...
   'cellSigma',[1 1],...
   'normType','pixel',...
   'normSigma',[2 2],...
   'binSigma',1.15,...
   'binCount',8,...
   'cellNormStrategy',0},...
   matchCache,{'co-'});

%% Grid optimization
gs = [24 1;20 1;16 1;12 1;8 1;4 1;12 2;8 2;4 2; ...
    8 3;6 3;4 3;6 4;4 4;4 5;4 6];
gsNorm = gs(gs(:,2) < 5 & gs(:,2) > 1,:);
nNorm = size(gsNorm,1);
gsNormCen = gs(gs(:,2) < 5,:);
nNormCen = size(gsNormCen,1);
gsConc = gs(gs(:,2) > 1,:);
nConc = size(gsConc,1);

gridTypes = {};
gridSizes = {};
cellFilters = {};

gridTypes(end+(1:nNorm)) = {'polar'};
gridSizes(end+(1:nNorm)) = mat2cell(gsNorm,ones(nNorm,1),2);
gridTypes(end+(1:nConc)) = {'concentric polar'};
gridSizes(end+(1:nConc)) = mat2cell(gsConc,ones(nConc,1),2);
gridTypes(end+(1:nNormCen)) = {'polar central'};
gridSizes(end+(1:nNormCen)) = mat2cell(gsNormCen,ones(nNormCen,1),2);
gridTypes(end+(1:nConc)) = {'concentric polar central'};
gridSizes(end+(1:nConc)) = mat2cell(gsConc,ones(nConc,1),2);

n = numel(gridTypes);
cellFilters(1:n) = {'gaussian'};
cellFilters(n+(1:n)) = {'polar gaussian'};
gridTypes(n+(1:n)) = gridTypes(1:n);
gridSizes(n+(1:n)) = gridSizes(1:n);

disp(['Total number of grid parameters to test: ' num2str(numel(gridTypes))]);
diary off

startTime = tic;

%% Optimize the following parameters
for i = 1
    diary optimizeParameter.out
    disp([timestamp(startTime) ' Iteration ' num2str(i)]);
    diary off
    method = enumOptimizeParameter(setNum,method,'gridType',gridTypes,'gridSize',gridSizes,'cellFilter',cellFilters);
    method = zoomOptimizeParameter(setNum,method,'gridRadius',[2.5:2.5:20 30 40]',2);
    method = modifyDescriptor(method,'centerFilter','gaussian');
    method = zoomOptimizeParameter(setNum,method,'centerSigma',repmat([1/3:1/3:2,3,4]',[1 2]),2);
    method = enumOptimizeParameter(setNum,method,'centerFilter',{'gaussian','none'});
    method = zoomOptimizeParameter(setNum,method,'cellSigma',repmat([1/3:1/3:2,3,4]',[1 2]),2);
    method = zoomOptimizeParameter(setNum,method,'binSigma',[0.5:0.5:4]',2);
    method = zoomOptimizeParameter(setNum,method,'binCount',[4:16]',1);
    method = zoomOptimizeParameter(setNum,method,'normSigma',repmat([1:10]',[1 2]),1);
end
diary optimizeParameter.out
totalTime = timestamp(startTime)
diary off
