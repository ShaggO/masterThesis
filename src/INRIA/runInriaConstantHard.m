clc, clear all

nHard = [0 1 2 5 10 20 35 50 75 100] * 10^3;
nHard = [{[]}, mat2cell(nHard,1,ones(1,numel(nHard)))];
windowSize = [134 70];

name = {'Go','Si','GoSi','Hog'};

svmPath = cell(numel(nHard),numel(name));
PRAUC = zeros(numel(nHard),numel(name));
nHardAuto = zeros(1,numel(name));
for j = 1:numel(nHard)
    for i = 1:numel(name)
        if strcmp(name{i},'GoSi') && ~isempty(nHard{j}) && nHard{j} > 51*10^3
            PRAUC(j,i) = NaN;
            svmPath{j,i} = '';
            continue
        end
        params = load(['results/optimize/inriaParameters' name{i}]); % SI settings
        svmPath{j,i} = inriaTestSvm(params.method,params.svmArgs,true,nHard{j});
        test = load(svmPath{j,i});
        PRAUC(j,i) = test.PRAUC;
        if isempty(nHard{j})
            nHardAuto(i) = test.totalNegTrain;
        end
    end
end

save('results/inriaConstantHard','svmPath','PRAUC','name','nHardAuto')
