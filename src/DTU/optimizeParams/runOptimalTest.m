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

% Generate method and setnum cells
chosenGo = go(3).method;
chosenGo = modifyDescriptor(chosenGo,'normSigma',[1.6 1.6]);

chosenSi = si(1).method;

chosenGoSi = chosenGo;
chosenGoSi.descriptorArgs = {chosenGoSi.descriptorArgs,chosenSi.descriptorArgs};
chosenGoSi.descriptor = {'cellhist','cellhist'};

GoSi = go.method;
for i = 1:splits
    GoSi(i).descriptorArgs = {go(i).method.descriptorArgs,si(i).method.descriptorArgs};
    GoSi(i).descriptor = {'cellhist','cellhist'};
end

% Define methods and their corresponding sets
methods = {[go.method],chosenGo,[si.method],chosenSi,GoSi,chosenGoSi};
setNums = {[go.setNumTest],(1:60)',[si.setNumTest],(1:60)',[go.setNumTest],(1:60)'};

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
save('results/optimize/DTUparamsTest');
