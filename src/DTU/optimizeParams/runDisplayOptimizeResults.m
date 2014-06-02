clear all; clc;

%% Load Go and Si splits
splits = 6;
for i = 1:splits
    go(i) = load(['results/optimize/parameterStudyGo_' num2str(i) '-of-' num2str(splits) '.mat']);
    si(i) = load(['results/optimize/parameterStudySi_' num2str(i) '-of-' num2str(splits) '.mat']);
end
%% Load sift results
sift = load('results/optimize/full-sift-dtuTest-test.mat');
siftCombined = load('results/optimize/combined_sift_test.mat');

%% compute
matchROCAUC = [cat(1,go.testROCAUC),cat(1,si.testROCAUC),sift.matchROCAUC,siftCombined.matchROCAUC];
matchPRAUC = [cat(1,go.testPRAUC),cat(1,si.testPRAUC),sift.matchPRAUC,siftCombined.matchPRAUC];

pathTypes = 1:6;
[imNumKey,liNumKey,imNum,liNum,pathLabels] = dtuPaths('test');
plotROCAUC = cell(4,numel(imNum));
plotPRAUC = cell(size(plotROCAUC));

setNum = 1:60;
% Number of images in each set
imgNum = sum(cellfun(@numel,imNum(pathTypes)) .* ...
    cellfun(@numel,liNum(pathTypes))) * numel(setNum);

% Generate indexing matrix
idx2spil = zeros(imgNum,4);

n = 0;
for s = setNum
    for p = pathTypes
        for i = imNum{p}
            for l = liNum{p}
                n = n+1;
                idx2spil(n,:) = [s,p,i,l];
            end
        end
    end
end

% Create a nicely formatted cell of mean AUCs
% for each path type
for p = pathTypes
    % Retrieve results for path from result matrix
    pIdx = idx2spil(:,2) == p;
    roc = reshape(matchROCAUC(pIdx,:),[numel(liNum{p}) numel(imNum{p}) numel(setNum) 4]);
    pr = reshape(matchPRAUC(pIdx,:),[numel(liNum{p}) numel(imNum{p}) numel(setNum) 4]);

    % Compute means based on number of lightings per image
    if numel(liNum{p}) > 1
        % Light path
        roc = permute(mean(mean(roc,2),3),[4 1 3 2]);
        pr = permute(mean(mean(pr,2),3),[4 1 3 2]);
    else
        % Viewpoint path (arc/linear)
        roc = permute(mean(roc,3),[4 2 3 1]);
        pr = permute(mean(pr,3),[4 2 3 1]);
    end
    % Insert result into plotting cell
    plotROCAUC(:,p) = mat2cell(roc, ones(1, 4));
    plotPRAUC(:,p) = mat2cell(pr, ones(1, 4));
end

displayDtuResults(plotROCAUC,plotPRAUC,pathTypes,'test',{{'-k'},{'-b'},{'-r'},{'-m'}},{'go','si','sift','vl sift'});
