clc, clear all

nHard = 10^5;
windowSize = [134 70];

name = {'Go','Si','GoSi','Hog'};

svmPath = cell(numel(name),1);
for i = 1:numel(name)
    params = load(['results/optimize/inriaParameters' name{i}]); % SI settings
    svmPath{i} = inriaTestSvm(params.method,params.svmArgs,true,nHard);
end

save('results/inriaConstantHard','svmPath')
