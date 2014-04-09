clear all; clc;
disp('Optimization of parameters started');

setNum = 1;

% Default settings across optimization parameters
peakThresholdDog = 6.5;
peakThresholdDogFull = 5;
peakThresholdHarris = 10^4;
detector = 'vl';
detectorArgs = {'method','MultiscaleHarris','peakthreshold',peakThresholdHarris,'cache',1};

descriptor = 'cellhist';
desArgs = {...
    'colour','gray',...
    'contentType','go',... % {'go','si','go,si','go-si'}
    'magnitudeType','m',... % {'m','c','j2','m,c','m-c'}
    'normType','pixel',...
    'scaleBase',2,...
    'rescale',1,...
    'cache',1};

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
        desArgsTemp = desArgs;
        desArgsTemp(end+1:end+4) = {'gridType',grid.gridType,...
                'gridSize',grid.gridSize(j,:)};
        method(counter) = methodStruct(...
                detector, detectorArgs,...
                descriptor, desArgsTemp,{'ro-'});
        counter = counter + 1;
    end
end
dtuTest(setNum,method,5,false);
