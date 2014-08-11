clc, clear all

si = load('results/optimize/inriaParametersSi');

% SVM arguments
% -c cost of C-SVC (default 1)
% -p epsilon (default 0.1)
si.svmArgs = struct('s',1,'logc',-2,'p',0.1);

si.method = modifyDescriptor(si.method,'colour','none');

data = inriaData;
diaryFile = ['inriaParametersSi_' strrep(datestr(now),':','-') '.out'];
diary(diaryFile)
disp('Optimization of svm for SI started.');
diary off;

logger = handler(emptyLogger);
[~,si.svmArgs] = inriaOptimizeZoom(data,diaryFile,logger,si.method,si.svmArgs,'logc', ...
        (-6:2)',(-0.5:0.1:0.5)');

totalTime = tic;
si.svmPath = inriaTestSvm(si.method,si.svmArgs,true,[],40,1*10^4);
totalTime = toc(totalTime)

clear data;
save('results/optimize/inriaParametersSi','-struct','si');
