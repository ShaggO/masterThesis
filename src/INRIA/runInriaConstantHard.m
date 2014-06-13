clc, clear all

nHard = [1 2 5 10 20 40 60 80 100] * 10^3;
windowSize = [134 70];

name = {'Go','Si','GoSi','Hog','HogDT'};

svmPath = cell(numel(nHard),numel(name));
PRAUC = zeros(numel(nHard),numel(name));
for j = 1:numel(nHard)
    for i = 1:numel(name)
        params = load(['results/optimize/inriaParameters' name{i}]); % SI settings
        svmPath{j,i} = inriaTestSvm(params.method,params.svmArgs,true,nHard(j));
        test = load(svmPath{j,i});
        PRAUC(j,i) = test.PRAUC;
    end
end
    
save('results/inriaConstantHard','svmPath','PRAUC','name')