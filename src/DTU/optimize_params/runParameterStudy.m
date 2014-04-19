clear all; clc;
disp('Optimization of parameters started');

setNum = 1;

%% Default settings across optimization parameters
peakThresholdDog = 6.5;
peakThresholdHarris = 10^4;
matchCache = true;
detector = 'vl';
detectorArgs = {'method','MultiscaleHarris','peakthreshold',peakThresholdHarris,'cache',1};

descriptor = 'cellhist';
desArgs = {...
    'colour','gray',...
    'contentType','go',... % {'go','si','go,si','go-si'}
    'magnitudeType','m',... % {'m','c','j2','m,c','m-c'}
    'normType','pixel',...
    'scaleBase',2^(1/3),...
    'rescale',1/2,...
    'cache',1};
method = methodStruct(...
    detector, detectorArgs,...
    descriptor, desArgs,...
    matchCache,{'ro-'});

[des.centerFilter,des.cellFilter,des.normFilter,des.binFilter] = deal('gaussian');

% Optimize the following parameters
%% Grid optimization
gridTypes = {};
gridSizes = {};
gridTypes(1:5) = {'square'};
gridTypes(6:19) = {'polar'};
gridTypes(20:29) = {'concentric polar'};
gridSizes(1:5) = mat2cell([1:5;1:5]',ones(5,1),2);
gridSizes(6:19) = mat2cell([24 1;20 1;16 1;12 1;8 1;4 1;12 2;8 2;4 2;...
    8 3;6 3;4 3;6 4;4 4],ones(14,1),2);
gridSizes(20:29) = mat2cell([12 2;8 2;4 2;8 3;6 3;4 3;6 4;4 4;4 5;4 6],...
    ones(10,1),2);

disp(['Total number of grid parameters to test: ' num2str(numel(gridTypes))]);

[method,optimal] = enumOptimizeParameter(setNum,method,'gridType',gridTypes,'gridSize',gridSizes);

% gridRadius: [2:40] (10 values)
gridRadius = zoomOptimizeParameter(setNum,method,'gridRadius',linspace(2,40,8)',2);
% centerSigma [1/3:2]
centerSigma = zoomOptimizeParameter(setNum,method,'centerSigma',repmat(linspace(1/3,2,8)',[1 2]),2);
% cellSigma [1/3:1/3:2], 3, 4
cellSigma = zoomOptimizeParameter(setNum,method,'cellSigma',repmat([1/3:1/3:2,3,4]',[1 2]),2);
% binSigma [0.5:0.5:4]
binSigma = zoomOptimizeParameter(setNum,method,'binSigma',[0.5:0.5:4]',2);
% binCount [4:16]
binCount = zoomOptimizeParameter(setNum,method,'binCount',[4:16]',1);

% normSigma pixel [1:10]
normSigmaPixel = zoomOptimizeParameter(setNum,method,'normSigma',repmat([1:10]',[1 2]),1);
% normSigma box [2,3] (HOG)
method.normType = 'block';
normSigmaBox = zoomOptimizeParameter(setNum,method,'normSigma',repmat([2,3]',[1 2]),1);
