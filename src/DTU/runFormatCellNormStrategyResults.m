clear all; clc;

setNum = 1:60;
mNum = 4;
testType = 'train';
pathTypes = 1:6;

[imNumKey,~,imNum,liNum,pathLabels] = dtuPaths(testType);

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

load('paths');
load([dtuResults '/resultsCellNormStrategy2.mat']);
PRmeans = zeros(numel(pathTypes),numel(method));
ROCmeans = zeros(numel(pathTypes),numel(method));
PRstd = PRmeans;
ROCstd = ROCmeans;
for i = pathTypes
    PRmeans(i,:) = mean(PR(idx2spil(:,2) == i,:),1);
    PRstd(i,:) = std(PR(idx2spil(:,2) == i,:),1,1);
    ROCmeans(i,:) = mean(ROC(idx2spil(:,2) == i,:),1);
    ROCstd(i,:) = std(ROC(idx2spil(:,2) == i,:),1,1);
end

Xs = repmat((1:numel(pathTypes))',[1 numel(method)]);

labels = {'Strat 0','Strat 1','Strat 2','Strat 3'};

figure;
errorbar(Xs,PRmeans,PRstd);
hold on;
legend(labels{:});
xlabel('pathtype');
ylabel('mean PR auc');

figure;
errorbar(Xs,ROCmeans,ROCstd);
legend(labels{:});
xlabel('pathtype');
ylabel('mean ROC auc');
