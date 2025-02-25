clear all; clc;
logger = handler(emptyLogger);
diaryFile = ['results/optimize/inriaParametersGoTriangle_' strrep(datestr(now),':','-') '.out'];
diary(diaryFile)
disp('Optimization of parameters for GO (triangle bin filter) started.');

%% Default settings across optimization parameters
peakThresholdDog = 6.5;
peakThresholdHarris = 10^4;

windowSize = [134 70];
svmArgs = struct('s',1,'logc',-2,'p',0.1);
method = methodStruct( ...
    'window',{'type','square','scales',2^(1/3).^(0:6),'spacing',10,'windowSize',windowSize}, ...
    'cellhist',{...
    'colour','gray',...
    'contentType','go',...
    'magnitudeType','m',...
    'rescale',1,...
    'scaleBase',2^(1/3),...
    'scaleOffset',0,...
    'gridType','square window',...
    'gridSize',2.5,...
    'gridRadius',windowSize,...
    'centerFilter','none',...
    'cellFilter','gaussian',...
    'cellSigma',[1 1],...
    'normType','pixel',...
    'normSigma',[1.6 1.6],...
    'binFilter','triangle',...
    'binSigma',1.2,...
    'binCount',12,...
    'cellNormStrategy',4},...
    true,{'co-'});

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
    method = inriaOptimizeZoom(data,diaryFile,logger,method,svmArgs,'gridSize', ...
        (2:0.5:4)',(-0.2:0.1:0.2)');
    method = inriaOptimizeZoom(data,diaryFile,logger,method,svmArgs,'cellSigma', ...
        repmat((0.5:0.5:2)',[1 2]),repmat((-0.2:0.1:0.2)',[1 2]));
    method = inriaOptimizeEnum(data,diaryFile,logger,method,svmArgs,'cellNormStrategy',{0,4});
    method = inriaOptimizeZoom(data,diaryFile,logger,method,svmArgs,'binSigma', ...
        (0.5:0.5:2.5)',(-0.2:0.1:0.2)');
    method = inriaOptimizeZoom(data,diaryFile,logger,method,svmArgs,'binCount', ...
        (4:2:16)');
    method = inriaOptimizeZoom(data,diaryFile,logger,method,svmArgs,'normSigma', ...
        repmat((3:10)',[1 2]),repmat((-0.4:0.2:0.4)',[1 2]));
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
save([optDir '/inriaParametersGoTriangle']);
