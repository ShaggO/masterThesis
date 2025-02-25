function [matchROCAUC, matchPRAUC, dims] = dtuTest(setNum,method,pathTypes,display,runInParallel,testType)
%DTUTEST Evaluates given methods by the image correspondence problem on the
% DTU dataset. Plots the average ROC AUC and PR AUC over given image sets
% for each method.
if nargin < 3
    pathTypes = 1:4;
end

if nargin < 4
    display = true;
end

if nargin < 5
    runInParallel = false;
end
if nargin < 6
    testType = 'test';
end

desSave = false;

setNum = reshape(setNum,1,[]);
pathTypes = reshape(pathTypes,1,[]);
[~,~,imNum,liNum] = dtuPaths(testType);

tic
% Number of images in each set
imgNum = sum(cellfun(@numel,imNum(pathTypes)) .* ...
    cellfun(@numel,liNum(pathTypes))) * numel(setNum);

% Pre-allocate result matrices
matchROCAUC = zeros(imgNum,numel(method));
matchPRAUC = zeros(size(matchROCAUC));
meanROCAUC = zeros(numel(method),1);
meanPRAUC = zeros(size(meanROCAUC));

% Generate method cells
mName = cell(numel(method),1);
mFunc = cell(numel(method),1);
for i = 1:numel(method)
    m = method(i);
    [mFunc{i}, mName{i}] = parseMethod(m);
end

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

time = tic;

% Start/get cluster with current profile
if runInParallel
    gcp;
    dimsC = cell(imgNum,1);
    % Run in parallel
    parfor c = 1:imgNum % Run all methods on each requested image
        tic;
        disp([timestamp(time) ' Image ' num2str(c) ' (' num2str(imgNum) ' images in total)']);
        idx = idx2spil(c,:);
        [s,i,l] = deal(idx(1),idx(3),idx(4));

        % Run on all lighting settings and all images in path across all sets
        [pathMatches, dimsC{c}] = imageCorrespondence(s,i,l,mFunc,mName,[method.cache],desSave);

        matchROCAUC(c,:) = [pathMatches.ROCAUC];
        matchPRAUC(c,:) = [pathMatches.PRAUC];
    end
    dims = dimsC{1};
else
    % Run sequentially
    for c = 1:imgNum % Run on each method and each chosen image path (pathType)
        tic;
        disp([timestamp(time) ' Image ' num2str(c) '/' num2str(imgNum)]);
        idx = idx2spil(c,:);
        [s,i,l] = deal(idx(1),idx(3),idx(4));

        % Run on all lighting settings and all images in path across all sets
        [pathMatches, dims] = imageCorrespondence(s,i,l,mFunc,mName,[method.cache],desSave);

        matchROCAUC(c,:) = [pathMatches.ROCAUC];
        matchPRAUC(c,:) = [pathMatches.PRAUC];
    end
end

% % Compute means of all images for each method
% meanROCAUC = mean(matchROCAUC,1);
% meanPRAUC = mean(matchPRAUC,1);

% Compute means for showing results
plotROCAUC = cell(numel(method),numel(imNum));
plotPRAUC = cell(size(plotROCAUC));

% Create a nicely formatted cell of mean AUCs
% for each path type
for p = pathTypes
    % Retrieve results for path from result matrix
    pIdx = idx2spil(:,2) == p;
    roc = reshape(matchROCAUC(pIdx,:),[numel(liNum{p}) numel(imNum{p}) numel(setNum) numel(method)]);
    pr = reshape(matchPRAUC(pIdx,:),[numel(liNum{p}) numel(imNum{p}) numel(setNum) numel(method)]);

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
    plotROCAUC(:,p) = mat2cell(roc, ones(1, numel(method)));
    plotPRAUC(:,p) = mat2cell(pr, ones(1, numel(method)));
end

if display
    displayOptimizeResults(plotROCAUC,plotPRAUC,pathTypes,testType,{method.plotParams},mName);
end

end
