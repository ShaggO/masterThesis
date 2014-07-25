clear all; clc;
logger = handler(emptyLogger);
diaryFile = ['results/optimize/inriaParametersGo_' strrep(datestr(now),':','-') '.out'];
diary(diaryFile)
disp('Optimization of parameters for GO started.');

%% Default settings across optimization parameters
oldParams = load('results/optimize/inriaParametersGo.mat');
svmArgs = oldParams.svmArgs;
method = modifyDescriptor(oldParams.method,'cellFilter','box','cellSigma',[3.3 3.3],'binFilter','triangle','binSigma',1);

data = inriaData(40,10^4);
startTime = tic;

%% Optimize the following parameters
[~,svmArgs] = inriaOptimizeZoom(data,diaryFile,logger,method,svmArgs,'logc', ...
    (-6:2)',(-0.5:0.1:0.5)');
iters = 3;
for i = 1:iters
    diary(diaryFile)
    disp([timestamp(startTime) ' Optimizing parameters (iteration ' num2str(i) '/' num2str(iters) '):']);
    diary off
    method = inriaOptimizeEnum(data,diaryFile,logger,method,svmArgs,'gridType',{'square window','triangle window'});
    %method = inriaOptimizeZoom(data,diaryFile,logger,method,svmArgs,'gridSize', ...
    %    (1.6:0.4:3.2)',(-0.2:0.1:0.2)');

    % Alpha using box, triangle and Gaussian filters
    cellMethod(1) = modifyDescriptor(method,'cellFilter','box');
    cellMethod(2) = modifyDescriptor(method,'cellFilter','triangle');
    cellMethod(3) = modifyDescriptor(method,'cellFilter','gaussian');
    [cellMethod(1),~,~,cellAUC(1)] = inriaOptimizeZoom(data,diaryFile,logger,cellMethod(1),svmArgs,'cellSigma', ...
           repmat((2:0.5:4)',[1 2]),repmat((-0.2:0.1:0.2)',[1 2]));
    [cellMethod(2),~,~,cellAUC(2)] = inriaOptimizeZoom(data,diaryFile,logger,cellMethod(2),svmArgs,'cellSigma', ...
           repmat((1.5:0.5:3)',[1 2]),repmat((-0.2:0.1:0.2)',[1 2]));
    [cellMethod(3),~,~,cellAUC(3)] = inriaOptimizeZoom(data,diaryFile,logger,cellMethod(3),svmArgs,'cellSigma', ...
        repmat((1:0.5:2.5)',[1 2]),repmat((-0.2:0.1:0.2)',[1 2]));
    [~,cellInd] = max(cellAUC);
    diary(diaryFile)
    disp(['Cell filters: box (' num2str(cellAUC(1)) '), triangle (' num2str(cellAUC(2)) '), Gaussian (' num2str(cellAUC(3)) ')']);
    diary off
    method = cellMethod(cellInd);

    % Beta using box, triangle and Gaussian filters
    binMethod(1) = modifyDescriptor(method,'binFilter','box');
    binMethod(2) = modifyDescriptor(method,'binFilter','triangle');
    binMethod(3) = modifyDescriptor(method,'binFilter','gaussian');
    [binMethod(1),~,~,binAUC(1)] = inriaOptimizeZoom(data,diaryFile,logger,binMethod(1),svmArgs,'binSigma', ...
        (1:0.5:2.5)',(-0.2:0.1:0.2)');
    [binMethod(2),~,~,binAUC(2)] = inriaOptimizeZoom(data,diaryFile,logger,binMethod(2),svmArgs,'binSigma', ...
        (0.5:0.5:1.5)',(-0.2:0.1:0.2)');
    [binMethod(3),~,~,binAUC(3)] = inriaOptimizeZoom(data,diaryFile,logger,binMethod(3),svmArgs,'binSigma', ...
        (0.5:0.5:1.5)',(-0.2:0.1:0.2)');
    [~,binInd] = max(binAUC);
    diary(diaryFile)
    disp(['Bin filters: box (' num2str(binAUC(1)) '), triangle (' num2str(binAUC(2)) '), Gaussian (' num2str(binAUC(3)) ')']);
    diary off
    method = binMethod(binInd);

    %method = inriaOptimizeEnum(data,diaryFile,logger,method,svmArgs,'cellNormStrategy',{0,4});
    method = inriaOptimizeZoom(data,diaryFile,logger,method,svmArgs,'binCount', ...
        (8:16)');
    method = inriaOptimizeZoom(data,diaryFile,logger,method,svmArgs,'normSigma', ...
        repmat((5:9)',[1 2]),repmat((-0.4:0.2:0.4)',[1 2]));
    [~,svmArgs] = inriaOptimizeZoom(data,diaryFile,logger,method,svmArgs,'logc', ...
        (-6:2)',(-0.5:0.1:0.5)');
end
diary(diaryFile)
totalTime = timestamp(startTime)
struct(method.descriptorArgs{:})
disp([timestamp(startTime) ' Computing test results:']);
diary off

%% Test with optimal parameters
svmPath = inriaTestSvm(method,svmArgs);
load paths;
optDir = 'results/optimize';
if ~exist(optDir,'dir')
    mkdir(optDir);
end
clear data;
save([optDir '/inriaParametersGo']);
