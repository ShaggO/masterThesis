clc, clear all

go = load('results/optimize/inriaParametersGo');

% SVM arguments
% -c cost of C-SVC (default 1)
% -p epsilon (default 0.1)
go.svmArgs = struct('s',1,'logc',-2,'p',0.1);

go.method = modifyDescriptor(go.method,'colour','none');

data = inriaData;
diaryFile = ['inriaParametersGo_' strrep(datestr(now),':','-') '.out'];
diary(diaryFile)
disp('Optimization of svm for GO started.');
diary off;

logger = handler(emptyLogger);
[~,go.svmArgs] = inriaOptimizeZoom(data,diaryFile,logger,go.method,go.svmArgs,'logc', ...
        (-6:2)',(-0.5:0.1:0.5)');

totalTime = tic;
go.svmPath = inriaTestSvm(go.method,go.svmArgs,true,[],40,1*10^4);
totalTime = toc(totalTime)

clear data;
save('results/optimize/inriaParametersGo','-struct','go');
