function [meanROCAUC, meanPRAUC] = dtuTest(setNum,method,pathTypes,display,runInParallel)
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

[imNumKey,~,imNum,liNum,pathLabels] = dtuPaths();

% Compute matches
tic
matchROCAUC = cell(numel(method),numel(pathTypes));
matchPRAUC = cell(size(matchROCAUC));
meanROCAUC = zeros(numel(method),1);
meanPRAUC = zeros(size(meanROCAUC));
mName = cell(numel(method),1);
mFunc = cell(numel(method),1);
for i = 1:numel(method)
    m = method(i);
    [mFunc{i}, mName{i}] = parseMethod(m);
end

% Start/get cluster with current profile
if runInParallel
    gcp;
    parfor c = 1:numel(pathTypes) % Run on each method and each chosen image path (pathType)
        % This code is the body of the compuations in dtuTest.
        % They are put in a separate script in order to turn on/off
        % parallel computations
        disp([timestamp() ' Path: ' pathLabels{c}]);
        tic

        % Run on all lighting settings and all images in path across all sets
        pathMatches = imageCorrespondence(setNum,imNum{c},liNum{c},mFunc,mName,[method.cache]);

        % Reshape to given input dimensions
        roc = reshape([pathMatches.ROCAUC],[numel(method) numel(liNum{c}) numel(imNum{c}) numel(setNum)]);
        pr = reshape([pathMatches.PRAUC],[numel(method) numel(liNum{c}) numel(imNum{c}) numel(setNum)]);
        % Dimensions of roc and pr: [method, light, image, set]
        % Compute means for each path
        if numel(liNum{c}) > 1
            roc = mean(mean(roc,4),3);
            pr = mean(mean(pr,4),3);
        else
            roc = permute(mean(mean(roc,4),2),[1 3 2 4]);
            pr = permute(mean(mean(pr,4),2),[1 3 2 4]);
        end

        % Append
        matchROCAUC(:,c) = mat2cell(roc,ones(1, numel(method)));
        matchPRAUC(:,c) = mat2cell(pr,ones(1, numel(method)));
    end
else
    % Run sequentially
    for c = 1:numel(pathTypes) % Run on each method and each chosen image path (pathType)
        % This code is the body of the compuations in dtuTest.
        % They are put in a separate script in order to turn on/off
        % parallel computations
        disp([timestamp() ' Path: ' pathLabels{c}]);
        tic

        % Run on all lighting settings and all images in path across all sets
        pathMatches = imageCorrespondence(setNum,imNum{c},liNum{c},mFunc,mName,[method.cache]);

        % Reshape to given input dimensions
        roc = reshape([pathMatches.ROCAUC],[numel(method) numel(liNum{c}) numel(imNum{c}) numel(setNum)]);
        pr = reshape([pathMatches.PRAUC],[numel(method) numel(liNum{c}) numel(imNum{c}) numel(setNum)]);
        % Dimensions of roc and pr: [method, light, image, set]
        % Compute means for each path
        if numel(liNum{c}) > 1
            roc = mean(mean(roc,4),3);
            pr = mean(mean(pr,4),3);
        else
            roc = permute(mean(mean(roc,4),2),[1 3 2 4]);
            pr = permute(mean(mean(pr,4),2),[1 3 2 4]);
        end

        % Append
        matchROCAUC(:,c) = mat2cell(roc,ones(1, numel(method)));
        matchPRAUC(:,c) = mat2cell(pr,ones(1, numel(method)));
    end
end

for m = 1:numel(method)
    meanROCAUC(m) = mean([matchROCAUC{m,:}]);
    meanPRAUC(m) = mean([matchPRAUC{m,:}]);
end

% Display results
if display
    for k = pathTypes % Generate figure for each image path
        if any(pathTypes == 1) && k == 1
            before = find(imNum{k} < imNumKey,1,'last');
        else
            before = 0;
        end
        if numel(liNum{k}) > 1
            x = liNum{k};
        else
            x = imNum{k};
        end

        figure('units','normalized','outerposition',[0 0 1 1]);
        h = zeros(numel(method),1);
        hold on;
        for i = 1:numel(method)
            plot(x(1:before),matchROCAUC{i,k}(1:before),method(i).plotParams{:});
            h(i) = plot(x(before+1:end),matchROCAUC{i,k}(before+1:end),method(i).plotParams{:});
        end
        padding = (x(end)-x(1))/20;
        axis([x(1)-padding x(end)+padding 0 1]);
        title(['ROC AUC ' pathLabels{k} ]);
        legend(h,mName,'location','southeast','interpreter','none');

        figure('units','normalized','outerposition',[0 0 1 1]);
        hold on;
        for i = 1:numel(method)
            plot(x(1:before),matchPRAUC{i,k}(1:before),method(i).plotParams{:});
            h(i) = plot(x(before+1:end),matchPRAUC{i,k}(before+1:end),method(i).plotParams{:});
        end
        axis([x(1)-padding x(end)+padding 0 1]);
        title(['PR AUC ' pathLabels{k} ]);
        legend(h,mName,'location','southeast','interpreter','none');

    end
end
