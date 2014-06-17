clc, clear all

pathSuffix = '_1_30';

generateInriaImagesCustomSeed(1,30)
generateInriaScaleSpacesCustomSeed(pathSuffix)

nHard = 10^5;
windowSize = [134 70];

name = {'Go','Si','GoSi','Hog','HogDT'};

svmPath = cell(numel(name),1);
for i = 1:numel(name)
    params = load(['results/optimize/inriaParameters' name{i}]); % SI settings
    svmPath{i} = inriaTestSvm(params.method,params.svmArgs,true,nHard,pathSuffix);
    copyfile(svmPath{i},['results/inriaTestSvm' name{i} '100kSeed2.mat'])
end

% save('results/inriaSeed2','svmPath')