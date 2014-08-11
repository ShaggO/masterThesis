clc, clear all

go = load('results/optimize/inriaParametersGo');
si = load('results/optimize/inriaParametersSi');

% SVM arguments
% -c cost of C-SVC (default 1)
% -p epsilon (default 0.1)
svmArgs = struct('s',1,'logc',-2,'p',0.1);

methodGo = modifyDescriptor(go.method,'gridType','square window','gridSize',2.5,'binCount',13,'colour','none');
methodSi = modifyDescriptor(si.method,'gridType','square window','gridSize',2.5,'binCount',5,'colour','none');

method = methodStruct( ...
    'window',methodGo.detectorArgs, ...
    {'cellhist','cellhist'}, ...
    {methodGo.descriptorArgs,methodSi.descriptorArgs}, ...
    1,{'kx-'});

data = inriaData;
diaryFile = ['inriaParametersCompact3_' strrep(datestr(now),':','-') '.out'];
diary(diaryFile)
disp('Optimization of svm for Compact3 started.');
diary off;

logger = handler(emptyLogger);
[~,svmArgs] = inriaOptimizeZoom(data,diaryFile,logger,method,svmArgs,'logc', ...
        (-6:2)',(-0.5:0.1:0.5)');

totalTime = tic;
svmPath = inriaTestSvm(method,svmArgs,true,[],40,1*10^4);
totalTime = toc(totalTime)

clear data;
save('results/optimize/inriaParametersCompact3');
