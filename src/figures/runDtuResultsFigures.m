clear all; clc;
close all;

%% Load Go and Si splits
%splits = 6;
%for i = 1:splits
%    go(i) = load(['results/optimize/parameterStudyGo_' num2str(i) '-of-' num2str(splits) '.mat']);
%    si(i) = load(['results/optimize/parameterStudySi_' num2str(i) '-of-' num2str(splits) '.mat']);
%end
own = load('results/optimize/DTUparamsTestFinal.mat');
%% Load sift results
sifts = load('results/optimize/fullsift_dogsift_test.mat');

%% Set methods
%matchROCAUC = [cat(1,go.testROCAUC),cat(1,si.testROCAUC),sifts.ROC];
%matchPRAUC = [cat(1,go.testPRAUC),cat(1,si.testPRAUC),sifts.PR];
%plotArgs = {{'-k'},{'-b'},{'-r'},{'-m'}};
%legends = {'go','si','DoG + sift','full-sift'};
matchROCAUC = [own.ROC{:} sifts.ROC];
matchPRAUC = [own.PR{:} sifts.PR];
matchROCAUC = [own.ROC{:} sifts.ROC(:,1)];
matchPRAUC = [own.PR{:} sifts.PR(:,1)];
plotArgs = {{'-r'},{'-g'},{'-b'},{'--','Color',[0.6 0.6 0.6]}};
legends = {'GO','SI','GO+SI','SIFT'};
%legends = {'Optimal GO','Chosen GO','Optimal SI','Chosen SI','"Optimal" Go-Si','Chosen Go-Si','DoG + sift','full-sift'};

pathTypes = 1:6;
[imNumKey,liNumKey,imNum,liNum,pathLabels] = dtuPaths('test');
plotROCAUC = cell(size(matchROCAUC,2),numel(imNum));
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
    roc = reshape(matchROCAUC(pIdx,:),[numel(liNum{p}) numel(imNum{p}) numel(setNum) size(matchROCAUC,2)]);
    pr = reshape(matchPRAUC(pIdx,:),[numel(liNum{p}) numel(imNum{p}) numel(setNum) size(matchPRAUC,2)]);

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
    plotROCAUC(:,p) = mat2cell(roc, ones(1, size(matchROCAUC,2)));
    plotPRAUC(:,p) = mat2cell(pr, ones(1, size(matchPRAUC,2)));
end

displayDtuReportResults(plotROCAUC,plotPRAUC,pathTypes,'test',plotArgs,legends);

%% Results table
fid = fopen('table.txt','w');
dims = {'300/350','200','500/550','128'};
for i = 1:size(matchPRAUC,2)
    s = [legends{i} ' & $' num2str(dims{i}) '$ & $' sprintf('%.3f',mean(matchPRAUC(:,i))) '$ & $' sprintf('%.3f',mean(matchROCAUC(:,i))) '$ \\\\ \n'];
    fprintf(fid,s);
end