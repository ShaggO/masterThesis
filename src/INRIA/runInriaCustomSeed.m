clc, clear all

profile off, profile on;
pathSuffix = '_2_30';

generateInriaImagesCustomSeed(2,30)
generateInriaScaleSpacesCustomSeed(pathSuffix)

nHard = 10^5;
windowSize = [134 70];

name = {'Go','Si','GoSi','Hog','HogDT'};

svmPath = cell(numel(name),1);
for i = 1:numel(name)
    params = load(['results/optimize/inriaParameters' name{i}]); % SI settings
    svmPath{i} = inriaTestSvm(params.method,params.svmArgs,true,nHard,pathSuffix);
    copyfile(svmPath{i},['results/inriaTestSvm' name{i} '100k_30_seed1.mat'])
end

profile off;
p = profile('info');
save('customseed2profile.mat','p');

% save('results/inriaSeed2','svmPath')
