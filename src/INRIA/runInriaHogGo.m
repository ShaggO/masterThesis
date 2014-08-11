clc, clear all

hog = load('results/optimize/inriaParametersHog');
go = load('results/optimize/inriaParametersGo');

% SVM arguments
% -c cost of C-SVC (default 1)
% -p epsilon (default 0.1)
svmArgs = struct('s',1,'logc',-2,'p',0.1);

methodGo = modifyDescriptor(go.method,'gridSize',2.2,'binCount',9,'colour','none');
methodHog = modifyDescriptor(hog.method,'colour','none');

method = methodStruct( ...
    'window',methodGo.detectorArgs, ...
    {'hog','cellhist'}, ...
    {methodHog.descriptorArgs,methodGo.descriptorArgs}, ...
    1,{'kx-'});

data = inriaData;
diaryFile = ['inriaParametersHogGo_' strrep(datestr(now),':','-') '.out'];
diary(diaryFile)
disp('Optimization of svm for HogGo started.');
diary off;

logger = handler(emptyLogger);
[~,svmArgs] = inriaOptimizeZoom(data,diaryFile,logger,method,svmArgs,'logc', ...
        (-6:2)',(-0.5:0.1:0.5)');

totalTime = tic;
svmPath = inriaTestSvm(method,svmArgs,true,[],40,1*10^4);
totalTime = toc(totalTime)

clear data;
save('results/optimize/inriaParametersHogGo');