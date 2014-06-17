clc, clear all

runGenerateInriaImagesSeed2
runGenerateInriaScaleSpacesSeed2

nHard = 10^5;
seed = 2;
windowSize = [134 70];

name = {'Go','Si','GoSi','Hog','HogDT'};

svmPath = cell(numel(name),1);
for i = 1:numel(name)
    params = load(['results/optimize/inriaParameters' name{i}]); % SI settings
    svmPath{i} = inriaTestSvm(params.method,params.svmArgs,true,nHard,seed);
    copyfile(svmPath{i},['results/inriaTestSvm' name{i} '100kSeed2.mat'])
end

% save('results/inriaSeed2','svmPath')