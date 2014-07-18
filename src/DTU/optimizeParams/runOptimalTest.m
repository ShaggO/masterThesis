clear all; clc;

pathTypes = 1:6;
display = false;
runInParallel = true;

%% Load Go and Si splits
splits = 6;
for i = 1:splits
    go(i) = load(['results/optimize/parameterStudyGo_' num2str(i) '-of-' num2str(splits) '.mat']);
    si(i) = load(['results/optimize/parameterStudySi_' num2str(i) '-of-' num2str(splits) '.mat']);
end

GoSi = go.method;
for i = 1:splits
    GoSi(i).descriptorArgs = {go(i).method.descriptorArgs,si(i).method.descriptorArgs};
    GoSi(i).descriptor = {'cellhist','cellhist'};
end

% Define methods and their corresponding sets
methods = {[go.method],[si.method],GoSi};
setNums = {[go.setNumTest],[si.setNumTest],[go.setNumTest]};

% Compute ROC and PR on test
ROC  = cell(size(methods));
PR   = ROC;
for i = 1:numel(methods)
    for j = 1:numel(methods{i})
        [ROCi,PRi] = dtuTest(setNums{i}(:,j),methods{i}(j),pathTypes,display,runInParallel,'test');
        ROC{i} = [ROC{i};ROCi];
        PR{i} = [PR{i};PRi];
    end
end

% Save results
save('results/optimize/DTUparamsTestFinal');
