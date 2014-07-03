clc, clear all

nHard = 10^5;
nWindows = 40;
seed = 1*10^4;
%name = {'Go','Si','GoSi','Hog','HogDT'};
name = {'Go','Si','Hog','HogDT'};

start = tic;
for i = 1:numel(name)
    params = load(['results/optimize/inriaParameters' name{i}]); % settings
    svmPath = inriaTestSvm(params.method,params.svmArgs,true,nHard,nWindows,seed);
    copyfile(svmPath,['results/inriaTestSvm' name{i} 'Final.mat'])
end
stop = toc(start)
