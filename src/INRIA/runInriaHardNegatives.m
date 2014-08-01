clc, clear all

nHard = {[],[0]};
windowSize = [134 70];

name = {'GoSi','Go','GoChosenSmall','Si','Hog'};

svmPath = cell(numel(nHard),numel(name));
PRAUC = zeros(numel(nHard),numel(name));
ROCAUC = PRAUC;
recall = PRAUC;

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
        ROCAUC(j,i) = test.ROCAUC;
        recall(j,i) = test.ROC(find(test.ROC(:,2) >= 10^-4,1),2);
        if isempty(nHard{j})
            nHardAuto(i) = test.nNegTrainHard;
        end
    end
end

save('results/inriaHardNegatives','svmPath','name','PRAUC','ROCAUC','recall','nHardAuto')
