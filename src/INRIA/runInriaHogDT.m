clc, clear all

windowSize = [134 70];

load('paths');

% SVM arguments
% -c cost of C-SVC (default 1)
% -p epsilon (default 0.1)
svmArgs = struct('s',1,'logc',-2,'p',0.1);
% svmArgs2 = struct('s',1,'logc',-3,'p',0.1);

%      'window',{'type','square','scales',2^(1/3).^(0:6),'spacing',10,'windowSize',windowSize}, ...
method = methodStruct( ...
    'window',{'type','square','scales',2^(1/3).^(0:6),'spacing',10,'windowSize',windowSize}, ...
    'hog',{'variant','dalaltriggs'}, ...
    0,{'rx-'});

data = inriaData;
diaryFile = ['inriaParametersHogDT_' strrep(datestr(now),':','-') '.out'];
diary(diaryFile)
disp('Optimization of svm for HOG (DT) started.');
diary off;

logger = handler(emptyLogger);
[~,svmArgs] = inriaOptimizeZoom(data,diaryFile,logger,method,svmArgs,'logc', ...
        (-6:2)',(-0.5:0.1:0.5)');

profile off,profile on
totalTime = tic;
svmPath = inriaTestSvm(method,svmArgs,true,10^5);
totalTime = toc(totalTime)
profile off
% profile viewer

% plotInriaResults(svmPath,svmPath2)
clear data;
save('results/optimize/inriaParametersHogDT');
