clc, clear all

go = load('results/optimize/inriaParametersGo');

% SVM arguments
% -c cost of C-SVC (default 1)
% -p epsilon (default 0.1)
svmArgs = struct('s',1,'logc',-2,'p',0.1);

method = modifyDescriptor(go.method,'gridType','square window','gridSize',2.5);

data = inriaData;
diaryFile = ['inriaParametersCompact1_' strrep(datestr(now),':','-') '.out'];
diary(diaryFile)
disp('Optimization of svm for Compact1 started.');
diary off;

logger = handler(emptyLogger);
[~,svmArgs] = inriaOptimizeZoom(data,diaryFile,logger,method,svmArgs,'logc', ...
        (-6:2)',(-0.5:0.1:0.5)');

totalTime = tic;
svmPath = inriaTestSvm(method,svmArgs,true,[],40,1*10^4);
totalTime = toc(totalTime)

clear data;
save('results/optimize/inriaParametersCompact1');
