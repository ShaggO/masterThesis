clc, clear all

nHard = 10^5;
windowSize = [134 70];

name = {'Go','Si','GoSi','Hog'};

for i = 1:numel(name)
    load(['results/optimize/inriaParameters' name]); % SI settings
    svmPath{i} = inriaTestSvm(method,svmArgs,true,nHard);
end

save('results/inriaConstantHard','svmPath')