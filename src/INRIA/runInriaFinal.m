clc, clear all

nHard = 10^5;
nWindows = 40;
seed = 1*10^4;
name = {'Go','Si','GoSi','Hog','HogDT'};

params = load(['results/optimize/inriaParameters' name{i}]); % settings
start = tic;
for i = 1:numel(name)
    svmPath = inriaTestSvm(params.method,params.svmArgs,true,nHard,nWindows,seed);
    copyfile(svmPath,['results/inriaTestSvm' name{i} 'Final.mat'])
end
stop = toc(start)