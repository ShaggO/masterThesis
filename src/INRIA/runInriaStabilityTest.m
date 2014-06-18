clc, clear all

nHard = 10^5;
nWindows = [1 2 5 10 20 40 60];
seed = (1:5)*10^4;
%nWindows = 40;
%seed = 2*10^4;
name = {'Go','Si','GoSi','Hog','HogDT'};

start = tic;
for i = 1:numel(name)
    params = load(['results/optimize/inriaParameters' name{i}]); % SI settings
    for j = 1:numel(nWindows)
        for k = 1:numel(seed)
            svmPath = inriaTestSvm(params.method,params.svmArgs,true,nHard,nWindows(j),seed(k));
            copyfile(svmPath,['results/inriaTestSvm' name{i} '100k_' num2str(nWindows(j)) '_' num2str(seed(k)) '.mat'])
        end
    end
end
stop = toc(start)
