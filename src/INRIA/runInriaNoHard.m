clc, clear all

nHard = 0;
windowSize = [134 70];

name = {'Go','Si','GoSi','Hog','HogDT'};

svmPath = cell(numel(name),1);
for i = 1:numel(name)
    params = load(['results/optimize/inriaParameters' name{i}]); % SI settings
    svmPath{i} = inriaTestSvm(params.method,params.svmArgs,true,nHard);
end

save('results/inriaNoHard','svmPath')
