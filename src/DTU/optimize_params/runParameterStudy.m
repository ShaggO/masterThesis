clear all; clc;
disp('Optimization of parameters started');

setNum = 1;

% Default settings across optimization parameters
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
grids(1).gridType = 'square';
grids(1).gridSize = [1:5;1:5]';
grids(2).gridType = 'polar';
grids(2).gridSize = [24 1;20 1;16 1;12 1;8 1;4 1;...
                   12 2;8 2; 4 2;...
                   8 3;6 3;4 3;...
                   6 4;4 4];
grids(3).gridType = 'concentric polar';
grids(3).gridSize = [12 2; 8 2;4 2;...
                     8 3;6 3;4 3;...
                     6 4;4 4;...
                     4 5;
                     4 6];

paramNum = 0;
for i = 1:numel(grids)
    paramNum = paramNum + size(grids(i).gridSize,1);
end
disp(['Total number of grid parameters to test: ' num2str(paramNum)]);

counter = 1;
for grid = grids
    for j = 1:size(grid.gridSize,1)
        methodV(counter) = modifyDescriptor(method,...
            'gridType',grid.gridType,...
            'gridSize',grid.gridSize(j,:));
        counter = counter + 1;
    end
end
[ROCAUC, PRAUC] = dtuTest(setNum,methodV,1:6,false,true,'train');
[optimalPRAUC, optimalInd] = max(PRAUC);
method = methodV(optimalInd);
%method = methodV(23);

[~,gTypeInd] = ismember('gridType',method.descriptorArgs(1:2:end));
[~,gSizeInd] = ismember('gridSize',method.descriptorArgs(1:2:end));
disp(['Optimal grid: ' method.descriptorArgs{gTypeInd*2}...
    ', size: ' nums2str(method.descriptorArgs{gSizeInd*2})]);


% gridRadius: [2:40] (10 values)
gridRadius = optimizeParameter(setNum,method,'gridRadius',linspace(2,40,8)',2);
% centerSigma [1/3:2]
centerSigma = optimizeParameter(setNum,method,'centerSigma',repmat(linspace(1/3,2,8)',[1 2]),2);
% cellSigma [1/3:1/3:2], 3, 4
cellSigma = optimizeParameter(setNum,method,'cellSigma',repmat([1/3:1/3:2,3,4]',[1 2]),2);
% binSigma [0.5:0.5:4]
binSigma = optimizeParameter(setNum,method,'binSigma',[0.5:0.5:4]',2);
% binCount [4:16]
binCount = optimizeParameter(setNum,method,'binCount',[4:16]',1);

% normSigma pixel [1:10]
normSigmaPixel = optimizeParameter(setNum,method,'normSigma',repmat([1:10]',[1 2]),1);
% normSigma box [2,3] (HOG)
method.normType = 'block';
normSigmaBox = optimizeParameter(setNum,method,'normSigma',repmat([2,3]',[1 2]),1);
